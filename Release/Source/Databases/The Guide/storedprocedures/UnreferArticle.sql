create procedure unreferarticle @modid int, @calledby int, @notes varchar(2000)
as
declare @EntryID int
declare @NewLockedBy int
-- find the entry id for this article
select @EntryID = h2g2ID, @NewLockedBy = ReferredBy from ArticleMod where ModID = @modid
select @EntryID = @EntryID / 10

BEGIN TRANSACTION
DECLARE @ErrorCode INT
declare @ExecError int

-- setting the status to 'locked' will automatically put it back in the locked
-- batch for the user that referred it
-- need to set ReferredBy to null else the decision will appear in the referees stats
update ArticleMod set Status = 1, LockedBy = ReferredBy, ReferredBy = null, 
	DateReferred = null, Notes = @notes, DateLocked = getDate()
	where ModID = @modid
if (@@ERROR <> 0) goto HandleError;

-- now unhide the entry using the unhide article SP
set @calledby = nullif (@calledby, 0);
exec @ExecError = UnhideArticle @EntryID, @ModID, 0, @calledby;
select @ErrorCode = @@ERROR; if (@ErrorCode = 0) select @ErrorCode = @ExecError;
if (@ErrorCode <> 0) goto HandleError;

exec @ExecError = addarticlemodhistory @ModID, 1, 
	NULL, NULL, 1, @NewLockedBy, 0, @calledby, @notes;
select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
if (@ErrorCode <> 0) goto HandleError;	

COMMIT TRANSACTION

return (0)

HandleError:
rollback transaction
return @ErrorCode
