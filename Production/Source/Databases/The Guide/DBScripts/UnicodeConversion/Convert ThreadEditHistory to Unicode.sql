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
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- Check the column type to see if it's already been converted to nvarchar.
DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype('ThreadEditHistory','OldSubject')
IF @type IS NULL RAISERROR ('Failed to find type for column',20,1) WITH LOG

IF @type = 'nvarchar'
BEGIN 
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR ('This table has already been converted to Unicode.  No need to run this script',20,1) WITH LOG
END
GO

-- Put the db into SIMPLE recovery mode so that the operations are minimally logged
ALTER DATABASE [TheGuide] SET RECOVERY SIMPLE 
GO

SELECT CONVERT(nvarchar(255), OldSubject) AS OldSubject, blobid, DateEdited, ForumID, ThreadID, EntryID, 
	CONVERT(nvarchar(MAX), text) AS text
	INTO dbo.Tmp_ThreadEditHistory 
	FROM dbo.ThreadEditHistory
GO
DROP TABLE dbo.ThreadEditHistory
GO
-- Make the Unicode version the real version
EXECUTE sp_rename N'dbo.Tmp_ThreadEditHistory', N'ThreadEditHistory', 'OBJECT' 
GO
--  The entire script took 53s on my machine

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--Recreate SmallGuide Snapshot. Create Database not permitted within transaction.
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

