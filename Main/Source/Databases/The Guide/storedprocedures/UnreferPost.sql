create procedure unreferpost @modid int, @notes varchar(2000)
as
declare @PostID int
-- find the post id for this post
select @PostID = PostID from ThreadMod where ModID = @modid

BEGIN TRANSACTION
DECLARE @ErrorCode INT

-- setting the status to 'locked' will automatically put it back in the locked
-- batch for the user that referred it
-- need to set ReferredBy to null else decision will appear in the referees stats
update ThreadMod set Status = 1, LockedBy = ReferredBy, ReferredBy = null, 
	DateReferred = null, Notes = @notes, DateLocked = getDate()
	where ModID = @modid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- now unhide the entry using the unhide article SP
exec @ErrorCode = UnhidePost @PostID
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)
