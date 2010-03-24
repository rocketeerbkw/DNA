CREATE PROCEDURE unarchivetopicinternal @topicid int, @editorid int, @validtopic int OUTPUT
AS
-- Initialise the output param
SET @validtopic = 0

-- First find out what topic status we're dealing with? PreviewArchived 4 or ActiveArchived 3
-- Also pick out the guidentry h2g2id and siteid
DECLARE @NewTopicStatus int, @h2g2ID int, @SiteID int
SELECT @NewTopicStatus = CASE
			WHEN TopicStatus = 3 THEN 0
			WHEN TopicStatus = 4 THEN 1
			ELSE -1 END,
		@h2g2ID = h2g2id,
		@SiteID = SiteID
	FROM dbo.Topics WITH(NOLOCK) WHERE TopicID = @topicid

-- Now check to see if we've got a valid new status
IF (@NewTopicStatus = -1)
BEGIN
	-- We've got a topic that isn't archived! Return not valid!
	SET @validtopic = 0
	RETURN
END

-- See if we need to add a default board promo? Declare and initialise some local variables
DECLARE @DefaultBoardPromoID int, @ExistingTopicForumID int, @TopicPosition int
SELECT @DefaultBoardPromoID = 0, @ExistingTopicForumID = 0, @TopicPosition = 1

SELECT TOP 1 @DefaultBoardPromoID = t.DefaultBoardPromoID,
			@ExistingTopicForumID = g.ForumID
	FROM dbo.Topics t WITH(NOLOCK)
	INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.EntryID = t.h2g2id/10
	WHERE t.SiteID = @SiteID AND t.TopicStatus = @NewTopicStatus

-- Get the next available postition
SELECT @TopicPosition = MAX([Position])+1 FROM dbo.Topics WITH(NOLOCK) WHERE SiteID = @SiteID AND TopicStatus = @NewTopicStatus
IF (@TopicPosition IS NULL)
BEGIN
	SELECT @TopicPosition = 1
END

-- Now get the topicelement id that belongs to the topic
DECLARE @ElementID int
SELECT @ElementID = ElementID FROM dbo.TopicElements WITH(NOLOCK) WHERE TopicID = @topicid

-- Now get the forumid for the guideentry
DECLARE @ForumID int
SELECT @ForumID = ForumID FROM dbo.GuideEntries WITH(NOLOCK) WHERE EntryID = @h2g2ID/10

DECLARE @Error int

-- First update the Topic
UPDATE dbo.Topics
	SET TopicStatus = @NewTopicStatus,
		DefaultBoardPromoID = @DefaultBoardPromoID,
		LastUpdated = GetDate(),
		UserUpdated = @editorid,
		Position = @TopicPosition
	WHERE TopicID = @topicid
SET @Error = @@ERROR
IF (@Error <> 0 )
BEGIN
	EXEC Error @Error
	RETURN @Error
END

-- Now update the FrontPageElement that belongs to the Topic Element, if we found one!
IF (@ElementID IS NOT NULL)
BEGIN
	UPDATE dbo.FrontPageElements
		SET ElementStatus = @NewTopicStatus,
			LastUpdated = GetDate(),
			UserID = @editorid,
			FrontPagePosition = @TopicPosition
		WHERE ElementID = @ElementID
	SET @Error = @@ERROR
	IF (@Error <> 0 )
	BEGIN
		EXEC Error @Error
		RETURN @Error
	END
END

-- Now Update the guideentry for the topic
UPDATE dbo.GuideEntries SET Status = 3, LastUpdated = GetDate(), Editor = @editorid WHERE EntryID = @h2g2ID/10
SET @Error = @@ERROR
IF (@Error <> 0 )
BEGIN
	EXEC Error @Error
	RETURN @Error
END

-- Now update the forum canwrite status
UPDATE dbo.Forums SET CanWrite = 1, ThreadCanWrite = 1 WHERE ForumID = @ForumID
SET @Error = @@ERROR
IF (@Error = 0)
BEGIN
	UPDATE dbo.Threads SET CanWrite = 1 WHERE ForumID = @ForumID
	SET @Error = @@ERROR
END
IF (@Error <> 0)
BEGIN
	EXEC Error @Error
	RETURN @Error
END

-- Finally set the valid topic flag
SET @validtopic = 1