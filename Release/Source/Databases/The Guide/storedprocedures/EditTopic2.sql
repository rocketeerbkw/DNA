CREATE PROCEDURE edittopic2 
	@itopicid INT, 
	@ieditorid INT, 
	@stitle VARCHAR(255), 
	@stext VARCHAR(MAX),  
	@istyle INT, 
	@position INT,
	@editkey uniqueidentifier
AS
	
	--edits an existing topic (originally added as part of the message board project)
	--a topic has a one-to-one relationship with a GuideEntry (of article type)
	--note only an editor is alowed to edit a topic	
		
BEGIN
	-- Now check to make sure the Editkeys match!
	DECLARE @CurrentKey uniqueidentifier
	DECLARE @ForumID int
	DECLARE @Error int

	SELECT @CurrentKey = t.EditKey, @ForumID = g.ForumID
		FROM dbo.topics t WITH(NOLOCK)
		INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.h2g2id = t.h2g2id
		WHERE t.topicID = @itopicid
	IF (@CurrentKey != @editkey)
	BEGIN
		SELECT 'ValidEditKey' = 1
		RETURN 0
	END

	BEGIN TRANSACTION
	
	--update corresponding Forum
	UPDATE dbo.Forums SET Title = @stitle WHERE ForumID = @ForumID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END	

	--update corresponding guide entry
	UPDATE dbo.guideentries SET subject = @stitle, [text] = @stext, style = @istyle
		WHERE h2g2id = ( SELECT h2g2id FROM dbo.topics AS tp WHERE tp.topicID = @itopicid) 
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END	

	--noew updated editor and time edited
	UPDATE dbo.topics SET UserUpdated = @ieditorid, LastUpdated = GETDATE(), EditKey = NEWID(), position = @position
		WHERE topicID = @itopicid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END	
	
	COMMIT TRANSACTION
	
	SELECT 'ValidEditKey' = 2, 'NewEditKey' = EditKey FROM dbo.topics WITH(NOLOCK) WHERE topicID = @itopicid
END
