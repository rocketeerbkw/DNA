CREATE PROCEDURE hidearticle @entryid int, @hiddenstatus int, @modid int, 
	@triggerid int, @calledby int
AS
DECLARE @ErrorCode int
declare @ExecError int

BEGIN TRANSACTION
	UPDATE GuideEntries SET Hidden = @hiddenstatus, LastUpdated = getdate() WHERE EntryID = @entryid
	SELECT @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
	
	if (@modid <> 0)
	begin 
		set @calledby = nullif (@calledby, 0);
		exec @ExecError = addarticlemodhistory @modid, NULL, 
			NULL, 2, 0, NULL, @triggerid, @calledby, NULL;
		select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError			
		if @ErrorCode <> 0 goto HandleError
	end
COMMIT TRANSACTION
return 0

HandleError:
rollback transaction
return @ErrorCode

