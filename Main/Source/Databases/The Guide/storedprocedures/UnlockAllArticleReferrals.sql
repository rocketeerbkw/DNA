create procedure unlockallarticlereferrals @userid int, @calledby int
as

declare @ErrorCode int
declare @ExecError int
declare @ModId int

declare c cursor for select ModId from ArticleMod where Status = 2 and LockedBy = @userid
open c
fetch next from c into @ModID
while (@@FETCH_STATUS = 0)
begin
	begin transaction

	update ArticleMod
		set LockedBy = NULL, DateLocked = NULL where ModID = @ModID;
	select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;

	set @calledby = nullif (@calledby, 0);
	exec @ExecError = addarticlemodhistory @ModID, NULL, 
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

