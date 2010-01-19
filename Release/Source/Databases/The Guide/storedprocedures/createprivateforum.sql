CREATE PROCEDURE createprivateforum	@userid int, @journalowner int, @title varchar(255), @siteid int, @read int, @write int, @threadread int, @threadwrite int, @forumid INT OUTPUT
as
	declare @ErrorCode int, @journal int
	BEGIN TRANSACTION
	INSERT INTO Forums (Title, JournalOwner, SiteID, CanRead, CanWrite, ThreadCanRead, ThreadCanWrite) 
		VALUES('User-journal', @userid, @siteid, @read, @write, @threadread, @threadwrite)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	SELECT @journal = @@IDENTITY
	
	INSERT INTO ForumPermissions (TeamID, ForumID, CanRead, CanWrite)
	SELECT TeamID, @journal, 1,1 FROM UserTeams WHERE userID = @userid AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	COMMIT TRANSACTION
	select @forumid = @journal
	return 0