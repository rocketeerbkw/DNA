create procedure unhidearticle @entryid int, @modid int, @triggerid int, @calledby int
as

declare @ErrorCode int
declare @ExecError int

begin transaction

update GuideEntries
set Hidden = null, LastUpdated = getdate()
where EntryID = @entryid
SELECT @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;	

if (@modid <> 0)
begin 
	set @calledby = nullif (@calledby, 0);
	exec @ExecError = addarticlemodhistory @modid, NULL, 
		NULL, 3, 0, NULL, @triggerid, @calledby, NULL;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if @ErrorCode <> 0 goto HandleError
end

commit transaction
return (0)

HandleError:
rollback transaction
return @ErrorCode