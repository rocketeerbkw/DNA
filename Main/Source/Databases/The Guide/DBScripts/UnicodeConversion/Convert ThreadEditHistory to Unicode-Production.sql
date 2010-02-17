IF DB_NAME() NOT LIKE '%guide%'
BEGIN
	RAISERROR ('Are you sure you want to apply this script to a non-guide db?',20,1) WITH LOG;
	RETURN
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

