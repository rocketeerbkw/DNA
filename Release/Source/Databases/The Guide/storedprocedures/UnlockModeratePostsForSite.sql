CREATE procedure unlockmoderatepostsforsite @siteid INT, @userid INT, @superuser bit = 0
as

DECLARE @err INT

declare @editgroup int
select @editgroup = GroupID FROM Groups WHERE Name = 'Editor'

--BEGIN TRANSACTION

--Unlock posts and alerts if user is an editor for site concerned.
update ThreadMod
SET Status = CASE WHEN Status = 1 THEN 0 ELSE Status END,
LockedBy = NULL, 
DateLocked = NULL 
where Status <> 3 AND Status <> 4 AND LockedBy IS NOT NULL AND siteid = @siteid 
AND ( siteid IN ( SELECT SiteID FROM GroupMembers WHERE UserID = @userid AND GroupID = @editgroup) OR @superuser = 1 )

SET @err = @@ERROR
IF @err <> 0
BEGIN 
	--ROLLBACK TRANSACTION
	RETURN @err
END

DECLARE @updated INT
SET @updated = @@ROWCOUNT
SELECT @updated 'updated'

RETURN @@ERROR

--Unlock referred items.
--update ThreadMod
--set LockedBy = NULL, DateLocked = NULL 
--where siteid = @siteid AND Status = 2

--SET @err = @@ERROR
--IF @err <> 0
--BEGIN 
--	ROLLBACK TRANSACTION
--	RETURN @err
--END

--COMMIT TRANSACTION
return @@ERROR
