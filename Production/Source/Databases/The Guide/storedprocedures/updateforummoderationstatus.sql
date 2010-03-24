Create Procedure updateforummoderationstatus	@userid int = null, 
												@h2g2id int = null,
												@forumid int = null,
												@newstatus int = null
As

IF (@forumid is NULL)
BEGIN
	IF (NOT(@userid is NULL))
	BEGIN
		-- If a userid is given, assume it's the user's journal we want
		SELECT @forumid=Journal FROM users WHERE userid=@userid
	END

	IF (NOT(@h2g2id is NULL))
	BEGIN
		-- If a h2g2id is given, assume it's the article's forum we want
		SELECT @forumid=ForumID FROM GuideEntries WHERE h2g2id=@h2g2id
	END
END

BEGIN TRANSACTION
DECLARE @ErrorCode INT

	UPDATE Forums SET LastUpdated = getdate(),
					  ModerationStatus=@newstatus WHERE forumid = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@forumid, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION
SELECT 'Success'=1
