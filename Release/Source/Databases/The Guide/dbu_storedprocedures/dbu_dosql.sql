CREATE PROCEDURE dbu_dosql @uid nvarchar(256), @sql nvarchar(max), @actiondescription nvarchar(255), @errornum int OUTPUT
AS
IF @@TRANCOUNT = 0
BEGIN
	RAISERROR ('dbu_dosql requires an active transaction', 16, 1)
	SET @errornum = @@ERROR
	ROLLBACK TRANSACTION
	RETURN 1
END

IF EXISTS (select * from dbo.admin_dbchanges where uid = @uid AND sql <> @sql)
BEGIN
	-- uid already exists but with different SQL applied
	DECLARE @ErrorText nvarchar(256)
	SELECT @ErrorText = 'A UID already exists but with different sql - have you reused a UID or edited the SQL for an old update? You must write a completely new update to fix any problems with existing updates.' + @uid
	RAISERROR (@ErrorText, 16, 1)
	SET @errornum = @@ERROR
	ROLLBACK TRANSACTION
	RETURN 1
END

IF EXISTS (select * from dbo.admin_dbchanges where uid = @uid)
BEGIN
	-- already applied this change
	print N'skipping ' + @actiondescription
	RETURN 0
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
	INSERT INTO dbo.admin_dbchanges (uid, DateApplied, Description, sql)
	VALUES (@uid, getdate(), @actiondescription, @sql)
	PRINT GETDATE()
	RETURN 0
END

