/*
	Unlocks all nicknames currently locked by this user for moderation
*/

CREATE PROCEDURE unlockallnicknamemoderations @userid INT, @modclassid INT = NULL
AS
	DECLARE @Error int
	
	BEGIN TRANSACTION
	
	-- Use UPDLOCK on SELECT statement to ensure we get same result set in INSERT statement
	-- and the following UPDATE statement
	INSERT NicknameModHistory (ModID,StatusID,LockedByChanged,LockedBy,TriggerID,TriggeredBy,DateCreated) 
		SELECT ModID,0,1,NULL,0,@userid,getdate()
			FROM NicknameMod (UPDLOCK) nm, Sites (UPDLOCK) s
			WHERE Status <> 3 AND status <> 4 AND LockedBy = @userid
				AND nm.siteid = s.siteid AND s.ModClassId = ISNULL(@modclassid,s.ModClassId)
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError

	--Clear Locks for current user and mod class.
	UPDATE NicknameMod
		SET Status = CASE WHEN Status = 1 THEN 0 ELSE Status END, 
		LockedBy = NULL, 
		DateLocked = NULL 
		FROM NickNameMod nm, Sites s
		WHERE Status <> 3 AND status <> 4 AND LockedBy = @userid
		AND nm.siteid = s.siteid AND s.ModClassId = ISNULL(@modclassid,s.ModClassId)
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError

	COMMIT TRANSACTION
	RETURN (0)
	
HandleError:
ROLLBACK TRANSACTION
RETURN @Error
