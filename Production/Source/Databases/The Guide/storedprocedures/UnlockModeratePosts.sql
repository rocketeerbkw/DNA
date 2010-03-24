create procedure unlockmoderateposts @userid INT, @superuser bit = 0, @modclassid INT = NULL
as

DECLARE @err INT

declare @editgroup int
select @editgroup = GroupID FROM Groups WHERE Name = 'Editor'

--Unlock all posts / alerts /referred items for all sites fo the given mod class for all users where user is an editor.
--Superuser would unlock all items for all sites in the given mod class.
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

--Unlock Refered Items
--update ThreadMod
--set LockedBy = NULL, DateLocked = NULL 
--where Status = 2

--SET @err = @@ERROR
--IF @err <> 0
--BEGIN 
--	ROLLBACK TRANSACTION
--	RETURN @err
--END

--COMMIT TRANSACTION

return @@ERROR
