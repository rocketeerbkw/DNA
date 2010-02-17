-- Increase the size of the four data files to 40Gb each, and the log to 80Gb
-- We're going to need this extra space to store the old and new
-- versions of ThreadEntries
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data',  SIZE = 40960000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data2', SIZE = 40960000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data3', SIZE = 40960000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data4', SIZE = 40960000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Log',   SIZE = 81920000KB )
-- This took 20mins on 28-4-09!
GO
-- Put the db into BULK_LOGGED recovery mode so that the operations are minimally logged
ALTER DATABASE [TheGuide] SET RECOVERY BULK_LOGGED 
GO
