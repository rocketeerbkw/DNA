/*

	This procedure will create a new single-person team, along with its associated private forum
	It creates the forum with write only permissions (so others can start conversations), then
	the team, then adds a teammembers entry, and finally a forumpermissions entry.

*/

CREATE PROCEDURE createnewteam @siteid int, @userid int, @title varchar(255), @role varchar(255), @teamid int OUTPUT, @forumid int OUTPUT, @alertinstantly int = 0
as
DECLARE @ErrorCode INT
BEGIN TRANSACTION

INSERT INTO Forums (Title, SiteID, CanRead, CanWrite, ThreadCanRead, ThreadCanWrite, AlertInstantly) VALUES (@title, @siteid, 0, 1, 0, 0, @alertinstantly)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

select @forumid = @@IDENTITY

INSERT INTO Teams (Type, ForumID) VALUES('CLUB', @forumid)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
SELECT @teamid = @@IDENTITY

insert into TeamMembers (TeamID, UserID, Role)
	VALUES(@teamid, @userid, @role)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Now set the permissions of this forum for the members
	INSERT INTO ForumPermissions (TeamID, ForumID, CanRead, CanWrite, Priority)
	VALUES(@teamid, @forumid, 1,1,1)
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO FaveForums (ForumID, UserID)
		VALUES (@forumid, @userid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION

return 0