/*
	Unlocks all articles currently locked by this user for moderation (though
	not any referrals they may have)
*/

create procedure unlockallarticlemoderations @userid int, @calledby int, @modclassid int = null
as

declare @ErrorCode int
declare @ExecError int
declare @ModId int

DECLARE c CURSOR FOR
	SELECT am.ModId
		FROM ArticleMod am, Sites s
			WHERE (am.Status = 1 OR am.Status = 0)
				AND am.LockedBy = @userid
				AND am.siteid = s.siteid AND s.ModClassId = ISNULL(@modclassid, s.ModClassId)

open c
fetch next from c into @ModID
while (@@FETCH_STATUS = 0)
begin
	begin transaction

	update ArticleMod
		set Status = 0, LockedBy = NULL, DateLocked = NULL
		where ModID = @ModID;
	select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;

	exec @ExecError = addarticlemodhistory @ModID, 0, 
		NULL, NULL, 1, NULL, 0, @calledby, NULL;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if (@ErrorCode <> 0) goto HandleError;	

	commit transaction
	
	fetch next from c into @ModID
end
close c
deallocate c
return (0)

HandleError:
rollback transaction
close c
deallocate c
return @ErrorCode

