CREATE PROCEDURE unlockexternallinks @userid int, @modclassid int = null
AS
DECLARE @err INT
UPDATE dbo.ExLinkMod
	SET Status = CASE WHEN Status = 1 THEN 0 ELSE Status END,
	LockedBy = NULL, 
	DateLocked = NULL 
FROM ExLinkMod elm, Sites s 
WHERE
	Status <> 3 AND Status <> 4 AND LockedBy = @userid AND elm.siteid = s.siteid AND s.ModClassId = ISNULL(@modclassid, s.ModClassId)

RETURN @@ERROR