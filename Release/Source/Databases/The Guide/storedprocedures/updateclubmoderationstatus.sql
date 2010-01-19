Create Procedure updateclubmoderationstatus @clubid int, @newstatus int
As

DECLARE @h2g2id int, @forumid int, @clubforumid int, @journalid int
DECLARE @hidden int

SELECT @h2g2id=h2g2id, @clubforumid=clubforum, @journalid=journal FROM Clubs WHERE ClubID=@clubid
SELECT @forumid=forumid, @hidden=hidden FROM GuideEntries WHERE h2g2id=@h2g2id

-- if the new moderation state for the club is 3 (i.e. premoderated),
-- set the article's hidden value to 3 to hide it
if (@newstatus = 3)
	SELECT @hidden=3
ELSE
	SELECT @hidden=null

BEGIN TRANSACTION
DECLARE @ErrorCode INT

	-- we set the moderation status on all associated club objects:
	-- The club's moderation status is defined by the club's article

	-- club's article
	UPDATE GuideEntries SET LastUpdated = getdate(),
					    ModerationStatus=@newstatus,
						Hidden=@hidden
						WHERE h2g2id=@h2g2id
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- club's forum
	UPDATE Forums SET LastUpdated = getdate(),
				  ModerationStatus=@newstatus WHERE forumid=@clubforumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@clubforumid, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- club's journal
	UPDATE Forums SET LastUpdated = getdate(),
				  ModerationStatus=@newstatus WHERE forumid=@journalid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@journalid, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- club's article's forum
	UPDATE Forums SET LastUpdated = getdate(),
				  ModerationStatus=@newstatus WHERE forumid=@forumid
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
