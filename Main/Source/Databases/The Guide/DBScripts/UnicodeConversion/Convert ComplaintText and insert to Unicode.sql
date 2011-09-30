IF DB_NAME() NOT LIKE '%guide%'
BEGIN
	RAISERROR ('Are you sure you want to apply this script to a non-guide db?',20,1) WITH LOG;
	RETURN
END
GO

IF ( DB_NAME() = 'SmallGuide' AND DB_ID('SmallGuideSS') > 0  )
BEGIN
	-- Restore SmallGuide DB from SnapShot, cannot restore whilst it has active connections.
	USE MASTER
	ALTER DATABASE SmallGuide SET OFFLINE WITH ROLLBACK IMMEDIATE
	ALTER DATABASE SmallGuide SET ONLINE
	RESTORE DATABASE SmallGuide FROM DATABASE_SNAPSHOT = 'SmallGuideSS'
	PRINT 'Restoring Small Guide From Snapshot.'
	USE SmallGuide
END
GO

DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype('Threadmod','ComplaintText')
IF @type IS NULL RAISERROR ('Failed to find type for column',20,1) WITH LOG

IF @type = 'nvarchar'
BEGIN 
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR ('This table has already been converted to Unicode.  No need to run this script',20,1) WITH LOG
END
GO

-- Put the db into SIMPLE recovery mode so that the operations are minimally logged
ALTER DATABASE [TheGuide] SET RECOVERY SIMPLE 

--BEGIN TRANSACTION
GO
--add temp column
ALTER TABLE dbo.ThreadMod ADD
	ComplaintTextTemp nvarchar(MAX) NULL
	
GO
--migrate data to temp column
UPDATE dbo.ThreadMod
SET ComplaintTextTemp = ComplaintText
GO

--drop old column
ALTER TABLE dbo.ThreadMod
	DROP COLUMN ComplaintText

GO
--drop old column
EXECUTE sp_rename N'dbo.ThreadMod.ComplaintTextTemp', N'ComplaintText', 'COLUMN' 
GO




