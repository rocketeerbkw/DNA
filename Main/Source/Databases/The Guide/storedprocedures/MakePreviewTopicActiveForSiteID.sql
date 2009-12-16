CREATE PROCEDURE makepreviewtopicactiveforsiteid @isiteid INT, @itopicid INT, @ieditorid INT
AS
BEGIN
	DECLARE @TopicStatus INT
	DECLARE @iLinkTopicID INT 	
	DECLARE @sTitle VARCHAR(255)
	DECLARE @H2G2ID INT 
	DECLARE @H2G2IDLinkTopic INT 
	DECLARE @ErrorCode INT
	DECLARE @Position INT
	DECLARE @PreviewBoardPromoID INT
	DECLARE @PreviewDefaultBoardPromoID INT

	-- Check to make sure the topic is actually a preview topic
	IF NOT EXISTS ( SELECT * FROM dbo.Topics WHERE TopicID = @itopicid AND TopicStatus IN (1,4) )
	BEGIN
		SELECT 'Result' = 0
		RETURN 0
	END

	-- Find out if this topic already has an active link topic
	SELECT	@iLinkTopicID = TopicLinkID,
			@H2G2ID = H2G2ID,
			@TopicStatus = TopicStatus,
			@PreviewBoardPromoID = BoardPromoID,
			@PreviewDefaultBoardPromoID = DefaultBoardPromoID,
			@Position = [Position]
		FROM dbo.Topics
		WHERE TopicID = @itopicid AND SiteID = @isiteid
	
	-- Now get the info from the preview GuideEntry
	DECLARE @ForumID INT
	SELECT @sTitle = Subject, @ForumID = ForumID FROM dbo.GuideEntries WHERE H2G2ID = @H2G2ID

	BEGIN TRANSACTION
	
	-- Check to see if we need to create the active topic or just update the existing.
	IF (@iLinkTopicID IS NULL OR @iLinkTopicID = 0)
	BEGIN
		-- Create the new Active Topic
		EXEC @ErrorCode = createtopic @isiteid, @ieditorid, @sTitle, '', 0, @itopicid, NULL, @Position
					
		--return if error occurs
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		--obtain the new created topic id 
		--by comparing the TopicLinkID,  siteid, the iEditorID and the topic status 
		--the TopicLinkID must always match the preview's toipc's id 
		--the other three parameters are simply extra saftey checks
		SELECT @iLinkTopicID = TopicID FROM dbo.Topics WHERE TopicLinkID = @itopicid AND SiteID = @isiteid AND TopicStatus = 0
		
		--update the TopicLinkID of the preview topic with the value of the newly created topic id
		UPDATE dbo.Topics SET TopicLinkID = @iLinkTopicID WHERE SiteID = @isiteid AND TopicID = @itopicid 
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END	
				
		--obtain the h2g2 guideentry of new created active topic 
		SELECT @H2G2IDLinkTopic = H2G2ID FROM dbo.Topics WHERE TopicID = @iLinkTopicID AND SiteID = @isiteid AND TopicStatus = 0
	
		--make write as 
		UPDATE dbo.GuideEntries	SET [Text] = ge1.[Text], ExtraInfo = ge1.ExtraInfo
			FROM (SELECT * FROM dbo.GuideEntries WHERE H2G2ID = @H2G2ID) as ge1	
			WHERE GuideEntries.H2G2ID = @H2G2IDLinkTopic
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END	
	END
	ELSE
	BEGIN
		--obtain the h2g2 guideentry of active topic 
		DECLARE @LinkForumID INT, @LinkTopicStatus INT
		SELECT @H2G2IDLinkTopic = t.H2G2ID, @Position = t.Position, @LinkForumID = g.ForumID, @LinkTopicStatus = t.TopicStatus
			FROM dbo.Topics t
			INNER JOIN dbo.GuideEntries g ON g.H2G2ID = t.H2G2ID
			WHERE t.TopicID = @iLinkTopicID AND t.SiteID = @isiteid AND t.TopicStatus IN (0,3)

		-- Get the active BoardPromoID from the preview linkID
		DECLARE @ActiveBoardPromoID INT
		IF (@PreviewBoardPromoID IS NOT NULL)
		BEGIN
			SELECT @ActiveBoardPromoID = bpe2.BoardPromoElementID FROM dbo.BoardPromoElements bpe
				INNER JOIN dbo.FrontPageelements fpe ON fpe.ElementID = bpe.ElementID
				INNER JOIN dbo.BoardPromoElements bpe2 ON bpe2.ElementID = fpe.ElementLinkID
				WHERE bpe.BoardPromoElementID = @PreviewBoardPromoID
		END
		
		-- Get the active BoardPromoID from the preview linkID
		DECLARE @ActiveDefaultBoardPromoID INT
		IF (@PreviewDefaultBoardPromoID IS NOT NULL)
		BEGIN
			SELECT @ActiveDefaultBoardPromoID = bpe2.BoardPromoElementID FROM dbo.BoardPromoElements bpe
				INNER JOIN dbo.FrontPageelements fpe ON fpe.ElementID = bpe.ElementID
				INNER JOIN dbo.BoardPromoElements bpe2 ON bpe2.ElementID = fpe.ElementLinkID
				WHERE bpe.BoardPromoElementID = @PreviewDefaultBoardPromoID
		END

		-- Check to see if the status is different between the active a preview
		-- If they are, then we need to update the forum and thread can write flags
		DECLARE @RequiresUpdate TinyInt
		SELECT @RequiresUpdate = CASE WHEN (@TopicStatus = 1 AND @LinkTopicStatus = 0)
											OR (@TopicStatus = 4 AND @LinkTopicStatus = 3) THEN 0
									ELSE 1 END

		-- Check to see if we're archiving or updating.
		IF ( @TopicStatus = 1 )
		BEGIN
			--Update the Active topic/guideentry with the preview information
			UPDATE dbo.GuideEntries SET [Text] = ge1.[Text], ExtraInfo = ge1.ExtraInfo, Subject = ge1.Subject, Status = ge1.Status
				FROM (SELECT * FROM dbo.GuideEntries WHERE H2G2ID = @H2G2ID) AS ge1	
				WHERE GuideEntries.H2G2ID =  @H2G2IDLinkTopic
			SET @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END	

			--Set the new forum title 
			UPDATE dbo.Forums SET Title = @sTitle WHERE ForumID = @LinkForumID 

			-- Update the board promo info and other things.
			UPDATE dbo.Topics
					SET [Position] = pt.Position,
						BoardPromoID = ISNULL(@ActiveBoardPromoID,0),
						DefaultBoardPromoID = ISNULL(@ActiveDefaultBoardPromoID,0),
						TopicStatus = 0
						FROM ( SELECT * FROM dbo.Topics WHERE TopicID = @itopicid ) AS pt
						WHERE dbo.Topics.TopicID = @iLinkTopicID
			SET @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END
			
			IF (@RequiresUpdate > 0)
			BEGIN
				-- Update the forum can write status
				UPDATE dbo.Forums SET CanWrite = PreviewForum.CanWrite, ThreadCanWrite = PreviewForum.ThreadCanWrite
					FROM
					(
						SELECT CanWrite, ThreadCanWrite FROM dbo.Forums WHERE ForumID = @ForumID
					) AS PreviewForum
					WHERE dbo.Forums.ForumID = @LinkForumID
				SET @ErrorCode = @@ERROR
				IF (@ErrorCode = 0)
				BEGIN
					UPDATE dbo.Threads SET CanWrite = 1 WHERE ForumID = @LinkForumID
					SET @ErrorCode = @@ERROR
				END
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					EXEC Error @ErrorCode
					RETURN @ErrorCode
				END
			END
		END
		ELSE
		BEGIN
			-- We need to Archive the Active topic
			UPDATE dbo.Topics SET TopicStatus = 3, [Position] = 0, BoardPromoID = 0, DefaultBoardPromoID = 0 WHERE TopicID = @iLinkTopicID
			SELECT @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END

			-- Update the GuideEntry associated with the topic
			UPDATE dbo.GuideEntries SET Status = 7 WHERE h2g2ID = @H2G2IDLinkTopic
			SELECT @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END
			
			IF (@RequiresUpdate > 0)
			BEGIN
				--Update Forum and Threads associated with Guide Entry to Read Only ( CanWrite = 0 )
				SET @ErrorCode = @@ERROR
				IF ( @@Error = 0 AND @forumID IS NOT NULL )
				BEGIN
					UPDATE dbo.Forums SET CanWrite = 0, ThreadCanWrite = 0 WHERE ForumId = @LinkForumID
					SET @ErrorCode = @@ERROR
					IF ( @ErrorCode = 0 ) 
					BEGIN
						UPDATE dbo.Threads SET CanWrite = 0 WHERE ForumId = @LinkForumID
						SET @ErrorCode = @@ERROR
					END
				END
				
				IF ( @ErrorCode <> 0 )
				BEGIN
					ROLLBACK TRANSACTION
					EXEC Error @ErrorCode
					RETURN @ErrorCode
				END
			END			
		END
	END	

	COMMIT TRANSACTION
END
