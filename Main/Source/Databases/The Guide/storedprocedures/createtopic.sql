CREATE PROCEDURE createtopic @isiteid INT, @ieditorid INT, @stitle VARCHAR(255), @stext VARCHAR(MAX), @itopicstatus INT, @itopiclinkid INT,  @sextrainfo TEXT, @position INT = NULL
AS
	
	--creates a new topic (originally added as part of the message board project)
	--a topic has a one-to-one relationship with a GuideEntry (of article type)
	--note only an editor is alowed to create a topic - moderation is ignored for editors/superusers.
	--note a Topic can either have a live, preview or archieved status
	
	-- istyle is not use within this procedure, but will need removing at some point!
	
BEGIN
	BEGIN TRANSACTION

	--set the position of this entry to be last 	
	DECLARE @iPosition INT
	IF (@position IS NULL)
	BEGIN
		SELECT @iPosition = MAX([Position])+1 FROM dbo.Topics WHERE SiteID = @isiteid AND TopicStatus = @itopicstatus
		IF (@iPosition IS NULL)
		BEGIN
			SELECT @iPosition = 1
		END
	END
	ELSE
	BEGIN
		SELECT @iPosition = @position
	END

	-- Now see if we have any deleted elements that we can re-use. Get the first ID with status = deleted
	DECLARE @iTopicID INT
	DECLARE @h2g2ID INT	
	SELECT @h2g2ID = 0
	SELECT TOP 1 @iTopicID = TopicID, @h2g2id = h2g2id FROM dbo.Topics WHERE TopicStatus = 2 AND SiteID = @isiteid

	-- First get the default board promo from any of the other topics for this site.
	DECLARE @DefaultBoardPromoID INT
	SELECT TOP 1 @DefaultBoardPromoID = DefaultBoardPromoID FROM dbo.Topics WHERE SiteID = @isiteid AND TopicStatus = @itopicstatus
	IF (@DefaultBoardPromoID IS NULL)
	BEGIN
		SELECT @DefaultBoardPromoID = 0
	END

	--declare variables
	DECLARE @ErrorCode INT

	
	IF (@iTopicID IS NULL)
	BEGIN
		DECLARE @iTopicforumID INT
		SET @iTopicForumID = 0
		
		--call the internal version as this takes into account duplicate guideentries.
		EXEC @ErrorCode = createguideentryinternal	@stitle, @stext, @sextrainfo,
													@ieditorid, DEFAULT, 1, DEFAULT, DEFAULT,
													@isiteid, 0, 1, 0, 0, @iTopicForumID OUTPUT, @h2g2ID OUTPUT,
													0, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 1
											
		--return if error occurs
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		--return if error occurs
		IF (@h2g2ID = 0)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Invalid h2g2ID Returned from CreateGuideEntryInternal!',16,1)
			RETURN 50000
		END
		
		--return if an no valid forum id was returned
		IF @iTopicForumID = 0 
		BEGIN
				ROLLBACK TRANSACTION
				RAISERROR('Invalid ForumID Returned from CreateGuideEntryInternal!',16,1)
				RETURN 50000
		END
		
		--unsubscribe editor from topic's forum 
		--prevent editor getting unwanted messages each time a new thread is created on topic's forum
		--editors can still receive messages for threads that they create on this forum 
		DELETE FROM FaveForums WHERE UserID = @ieditorid  AND ForumID = @iTopicForumID
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
		
		-- add new row to topics table
		INSERT INTO dbo.Topics (h2g2id, SiteID, [Position], TopicStatus, TopicLinkID, CreatedDate, LastUpdated, UserCreated, UserUpdated, EditKey, BoardPromoID, DefaultBoardPromoID) 
		VALUES (@h2g2id, @isiteid, @iPosition, @itopicstatus,  @itopiclinkid, GETDATE(), GETDATE(), @ieditorid, @ieditorid, NEWID(), 0, @DefaultBoardPromoID )
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END	
		SELECT @iTopicID = @@IDENTITY	
	END
	ELSE
	BEGIN
		-- Update the deleted topic with the new info!
		UPDATE dbo.Topics
			SET		[Position] = @iPosition, 
					TopicStatus = @itopicstatus, 
					TopicLinkID = @itopiclinkid, 
					CreatedDate = GETDATE(), 
					LastUpdated = GETDATE(), 
					UserCreated = @ieditorid, 
					UserUpdated = @ieditorid, 
					EditKey = NEWID(),
					BoardPromoID = 0,
					DefaultBoardPromoID = @DefaultBoardPromoID
			WHERE TopicID = @iTopicID
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
		
		-- Make sure the guide entry associated with the topic is correctly reinstated.
		UPDATE dbo.GuideEntries
			SET	Status = 1,
				[Text] = @stext,
				Subject = @stitle,
				ExtraInfo = @sextrainfo,
				Editor = @ieditorid,
				DateCreated = GETDATE(), 
				LastUpdated = GETDATE() 
			WHERE h2g2id = @h2g2id
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		--Update Forum and Threads associated with Guide Entry writable
		DECLARE @forumID INT
		SELECT @forumID = f.forumId FROM Forums f
		INNER JOIN GuideEntries g ON g.ForumId = f.ForumId
		WHERE g.h2g2Id = @h2g2ID
		IF (  @ErrorCode = 0 AND @forumID IS NOT NULL )
		BEGIN
			UPDATE dbo.Forums SET CanWrite = 1, ThreadCanWrite = 1, Title = @stitle WHERE ForumId = @forumID
			SET @ErrorCode = @@ERROR
			IF ( @ErrorCode = 0 ) 
			BEGIN
				UPDATE dbo.Threads SET CanWrite = 1 WHERE ForumId = @forumId
				SET @ErrorCode = @@ERROR
			END	
		END
	
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
					
	COMMIT TRANSACTION	

	-- It's vital that this doesn't return a result set when nested in another transaction
	-- If we create multiple result sets, but DNA doesn't process them, it can cause
	-- abnormal termination of the Stored Procedure (EventClass = Attention in SQL Profiler)
	IF @@TRANCOUNT < 1
	BEGIN	
		SELECT 'iTopicID' = @iTopicID
	END

END
