create procedure unlockmoderatepostsforuser @userid int, @modclassid int = null
as

DECLARE @err INT

--BEGIN TRANSACTION

--Unlock posts / alerts for specified user and site mod class.
--Not changing status on locking / unlocking.
update threadmod 
SET Status = CASE WHEN Status = 1 THEN 0 ELSE Status END,
LockedBy = NULL, 
DateLocked = NULL 
FROM threadmod th, sites s 
where Status <> 3 AND Status <> 4 AND LockedBy = @userid AND th.siteid = s.siteid AND s.ModClassId = ISNULL(@modclassid,s.ModClassId)

SET @err = @@ERROR
IF @err <> 0
BEGIN 
	--ROLLBACK TRANSACTION
	RETURN @err
END

--Unlock Referred Items
--update ThreadMod
--set LockedBy = NULL, DateLocked = NULL 
--where LockedBy = @userid AND Status = 2

--SET @err = @@ERROR
--IF @err <> 0
--BEGIN 
--	ROLLBACK TRANSACTION
--	RETURN @err
--END

--COMMIT TRANSACTION
return @@ERROR
