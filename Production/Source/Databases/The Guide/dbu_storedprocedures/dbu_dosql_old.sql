CREATE PROCEDURE dbu_dosql_old @sql nvarchar(4000),@actiondescription nvarchar(255), @errornum int OUTPUT
AS
IF @@TRANCOUNT = 0
BEGIN
	RAISERROR ('dbu_dosql requires an active transaction', 16, 1)
	RETURN
END

PRINT 'Starting: ' + @actiondescription
PRINT GETDATE()
EXECUTE sp_executesql @sql
SET @errornum = @@ERROR
IF (@errornum <> 0)
BEGIN
	PRINT 'Error: Action ' + @actiondescription + ' has failed'
	ROLLBACK TRANSACTION
	PRINT GETDATE()
	RETURN 1
END
ELSE
BEGIN
	PRINT 'Finished: ' + @actiondescription
	PRINT GETDATE()
	RETURN 0
END
