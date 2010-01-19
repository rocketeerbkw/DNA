Create Procedure updatearticlemoderationstatus @h2g2id int, @newstatus int
As
BEGIN TRANSACTION
DECLARE @ErrorCode INT

	UPDATE GuideEntries SET LastUpdated = getdate(),
					    ModerationStatus=@newstatus WHERE h2g2id = @h2g2id
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	declare @forumid int
	select @forumid = ForumID from GuideEntries where h2g2ID = @h2g2id

	-- assume that the associated forum should be given the same moderation status too
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
COMMIT TRANSACTION
SELECT 'Success'=1
