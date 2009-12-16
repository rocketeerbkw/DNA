CREATE PROCEDURE movetopicpositionally 
	@itopicid INT, 
	@idirection INT, 
	@editkey uniqueidentifier
AS
BEGIN
	DECLARE @iSiteID INT
	DECLARE @iPosition  INT
	DECLARE @itopicid_Other  INT
	DECLARE @iChange INT
	DECLARE @iChange1 INT
	DECLARE @iTopicStatus INT 
	
	-- Now check to make sure the Editkeys match!
	DECLARE @CurrentKey uniqueidentifier
	SELECT @CurrentKey = EditKey 
	FROM topics 
	WHERE topicID = @itopicid
	IF (@CurrentKey != @editkey)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'ValidEditKey' = 1
		RETURN 0
	END

	--get the id of the site to which this topic
	SELECT @iSiteID = SiteID, @iPosition = [Position], @iTopicStatus = TopicStatus FROM topics WHERE TopicID = @itopicid
		
	--0 means move down
	--1 means move up
	IF @idirection = 0 
	BEGIN				
		--find if this item can be moved down
		--in order to qualify for this operation this item
		--must have another item which is position below it
		IF NOT EXISTS(SELECT * FROM topics WHERE  ( [position] < @iPosition ) AND  ( SiteID = @iSiteID ) AND (TopicStatus = @iTopicStatus) )
		BEGIN
			--cannot move down anymore
			RETURN 0
		END 				
	
		--get the TopicID of the other item being replaced	
		--SELECT @itopicid_Other = TopicID FROM topics WHERE [Position] = (@iPosition -1) AND (SiteID = @iSiteID)  AND (TopicStatus = @iTopicStatus)
	
		SET @iChange = -1										
	END 
	ELSE IF @idirection = 1 
	BEGIN		
		
		--find if this item can be moved up
		--in order to qualify for this operation this item
		--must have another item which is position below it	
		IF NOT EXISTS(SELECT * FROM topics WHERE ( [position] > @iPosition ) AND  ( SiteID = @iSiteID ) AND (TopicStatus = @iTopicStatus))
		BEGIN			
			--cannot move down anymore
			PRINT 'Can not move the Topic '  + CAST (@itopicid AS VARCHAR(10) ) +  ' up as no other items are above it'
			RETURN 0
		END 			
		
		--get the TopicID of the other item being replaced	
		--SELECT @itopicid_Other = TopicID FROM topics WHERE [Position] = (@iPosition + 1) AND (SiteID = @iSiteID) 
		
		SET @iChange = 1							
	END 
		
	--get the TopicID of the other item being replaced	
	SELECT @itopicid_Other = TopicID FROM topics WHERE [Position] = (@iPosition + @iChange ) AND (SiteID = @iSiteID)  AND (TopicStatus = @iTopicStatus)
	
	BEGIN TRANSACTION
		
	--move this item down
	--update edit key to indicate change
	UPDATE topics
	SET [Position] = ( @iPosition  + @iChange), EditKey = NEWID()
	WHERE (TopicID = @itopicid ) 
				
	--return if error occurs
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION		
		RETURN @@ERROR
	END	
	
	--move the replaced item 
	--update edit key to indicate change
	UPDATE topics
	SET [Position] = @iPosition, EditKey = NEWID()
	WHERE (TopicID = @itopicid_Other)				
	
	--return if error occurs
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION		
		RETURN @@ERROR
	END	
	
	SELECT 'ValidEditKey' = 2, 'NewEditKey' = EditKey 
	From topics
	WHERE topicID = @itopicid
	
	COMMIT TRANSACTION
	
	RETURN 0 
END


