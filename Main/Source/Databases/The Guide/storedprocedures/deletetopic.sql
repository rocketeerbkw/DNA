/*
	if a live topic is being 'deleted'
	its status is changed to archived
	its linked topic pair is also archived
	its associated topic element, if any, is also archived
	its associated topic element, if any, of the link topic is also achived
	the positions of the other live Topics which belong to the same site as adjusted
	
	if a preview tiopic is being 'deleted' then 
	if it has a link topic then its status should be set to Archive rather than deleted
	if it does not have a link topic then its status should be set to Deleted
	
	
	Topic status is as follows
	===============
	--0 is Active/live
	--1 is Preview
	--2 is deleted
	--3 is ActiveArchived
	--4 is PreviewArchived

*/
CREATE PROCEDURE deletetopic @itopicid INT
AS
BEGIN

	-- Now get the details for the topic we're about to delete
	DECLARE @SiteID INT
	DECLARE @Position INT
	DECLARE @TopicStatus INT
	DECLARE @TopicLinkID INT
	DECLARE @h2g2ID INT
	SELECT @SiteID = SiteID, @Position = [Position], @TopicStatus = TopicStatus, @h2g2ID = h2g2ID, @TopicLinkID = TopicLinkID FROM dbo.Topics WHERE TopicID = @itopicid
	IF (@@ROWCOUNT = 0)
	BEGIN
		-- Could not find the topic, return problem!
		SELECT 'ValidID' = 0
		RETURN 0
	END

	-- Now figure out what the new status should be when it's deleted
	DECLARE @NewStatus INT
	IF (@TopicStatus = 0) -- LIVE
	BEGIN	
		--we can only mark live Topics as archived!
		SELECT @NewStatus = 3				
	END
	ELSE IF (@TopicStatus = 1) -- PREVIEW
	BEGIN	
		--if this has a link topic then both must be marked as archived		
		IF (@TopicLinkID = 0)
		BEGIN	
			SELECT @NewStatus = 2	
		END
		ELSE			
		BEGIN
			SELECT @NewStatus = 4	
		END
	END
	ELSE -- EITHER ARCHIVED OR DELETED
	BEGIN
		-- If it's already deleted or archived, then just return as we don't mess with these.
		SELECT 'ValidID' = 1
		RETURN 0
	END

	BEGIN TRANSACTION
	
	-- Now Update the topic
	DECLARE @Error INT
	UPDATE dbo.Topics SET TopicStatus = @NewStatus, [Position] = 0, BoardPromoID = 0, DefaultBoardPromoID = 0 WHERE TopicID = @iTopicID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	-- Update the GuideEnetry associated with the topic
	UPDATE dbo.GuideEntries SET Status = 7 WHERE h2g2ID = @h2g2ID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	--Update Forum and Threads associated with Guide Entry to Read Only ( CanWrite = 0 )
	DECLARE @forumID INT
	SELECT @forumID = f.forumId FROM Forums f
	INNER JOIN GuideEntries g ON g.ForumId = f.ForumId
	WHERE g.h2g2Id = @h2g2ID
	
	SET @Error = @@ERROR
	IF ( @Error = 0 AND @forumID IS NOT NULL )
	BEGIN
		UPDATE dbo.Forums SET CanWrite = 0, ThreadCanWrite = 0 WHERE ForumId = @forumID
		SET @Error = @@ERROR
		
		IF ( @Error = 0 ) 
		BEGIN
			UPDATE dbo.Threads SET CanWrite = 0 WHERE ForumId = @forumId
			SET @Error = @@ERROR
		END
	END
	
	IF ( @ERROR <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	-- Update the Topics TopicElement part if it has one
	DECLARE @TopicElementID INT
	SELECT @TopicElementID = TopicElementID	FROM dbo.TopicElements WHERE TopicID = @itopicid
	
	-- Check to see if it had one
	IF (@TopicElementID IS NOT NULL)
	BEGIN
		-- Call the Delete topic element procedure
		EXEC @Error = DeleteTopicElement @TopicElementID
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	END

	-- Now update positions
	UPDATE dbo.Topics SET [Position] = [Position] - 1
	WHERE SiteID = @SiteID AND TopicStatus = @TopicStatus AND [Position] > @Position
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	-- Commit the changes
	COMMIT TRANSACTION 

	-- Indicate success
	SELECT 'ValidID' = 1
END