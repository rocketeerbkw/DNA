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

--add temp column
ALTER TABLE dbo.ThreadMod ADD
	ComplaintTextTemp nvarchar(MAX) NULL
GO

--migrate data to temp column

-- Record the max mod id before we procede
DECLARE @MaxModId INT
SELECT @MaxModId = MAX(ModId) FROM ThreadMod

-- Get the list of records that need updating
SELECT ModID INTO #ThreadModToUpdate FROM ThreadMod
CREATE CLUSTERED INDEX IX_ThreadModToUpdate ON #ThreadModToUpdate(ModId)

DECLARE @n INT
SET @n=1
WHILE @n > 0
BEGIN
	;WITH toUpdate as (SELECT TOP(10000) ModID FROM #ThreadModToUpdate ORDER BY ModId)
	UPDATE tm
		SET ComplaintTextTemp = ComplaintText
	FROM ThreadMod tm
	JOIN toUpdate u ON u.ModId = tm.ModId

	;WITH toUpdate as (SELECT TOP(10000) ModID FROM #ThreadModToUpdate ORDER BY ModId)
	DELETE toUpdate
	SET @n=@@ROWCOUNT
END
-- 37 minutes on NewGuide

-- Update any new rows that might have been added in the interim
-- locking the table while it does the switch to the new column
BEGIN TRAN

UPDATE ThreadMod WITH(TABLOCKX)
	SET ComplaintTextTemp = ComplaintText
	WHERE ModId > @MaxModId

--drop old column
ALTER TABLE dbo.ThreadMod
	DROP COLUMN ComplaintText

--Rename column
EXECUTE sp_rename N'dbo.ThreadMod.ComplaintTextTemp', N'ComplaintText', 'COLUMN' 
COMMIT TRAN
GO

IF DB_NAME() = 'SmallGuide'
BEGIN
	--Create New SnapShot.
	DECLARE @filename VARCHAR(128), @SQL nvarchar(1000)
	SELECT @filename = physical_name
	FROM sys.master_files
	WHERE database_id = DB_ID('smallguidess')

	IF ( @filename IS NOT NULL )
	BEGIN
		DROP DATABASE SmallGuideSS
		SET @SQL = 'CREATE DATABASE SmallGuideSS ON 
		( NAME = SmallGuide, FILENAME = ''' + @filename + ''') AS SNAPSHOT OF SmallGuide'
		EXEC sp_executeSQL @SQL
		PRINT 'Recreating SmallGuide SnapShot'
	END
END