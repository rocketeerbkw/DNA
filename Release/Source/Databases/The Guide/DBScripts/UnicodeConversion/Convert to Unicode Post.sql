-- Put the db back into FULL recovery mode
ALTER DATABASE [TheGuide] SET RECOVERY FULL
GO
-- Back up the log so we can shrink the log file
DECLARE @disk nvarchar(1000)
SET @disk = N'H:\TempBackup\AfterUnicodeConversion_' + REPLACE(convert(nvarchar(20), getdate(), 120),N':', N'_') + N'.bak'
BACKUP LOG [theguide] TO  DISK = @disk WITH  INIT ,  NOUNLOAD ,  NAME = N'theguide backup Log',  SKIP ,  STATS = 10,  FORMAT ,  MEDIANAME = N'theguideLog',  MEDIADESCRIPTION = N'local Log'
-- took 3mins 16s, and generated a log file backup of 21Gb!
-- took 3mins 50s, and generated a log file backup of 26Gb!
-- took 14m, bak file 89Gb! 29-4-09
GO
-- Back-up log again using above script
GO
DBCC SHRINKFILE(TheGuide_Log,500) -- 3m16s
GO

