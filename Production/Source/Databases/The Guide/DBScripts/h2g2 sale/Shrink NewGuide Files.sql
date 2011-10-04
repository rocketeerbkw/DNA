--DBCC SHRINKFILE (TheGuide_Data, 20480);
-- size 53.17Gb, used 17.82Gb
-- 3h 33m

--select 7*1024 -- 7Gb

use NewGuide

DBCC SHRINKFILE (TheGuide_Data,  7168);
DBCC SHRINKFILE (TheGuide_Data2, 7168);
DBCC SHRINKFILE (TheGuide_Data3, 7168);
DBCC SHRINKFILE (TheGuide_Data4, 7168);
DBCC SHRINKFILE (TheGuide_Log, 500);

USE [master]
GO
ALTER DATABASE [NewGuide] SET RECOVERY FULL WITH NO_WAIT
GO
ALTER DATABASE [NewGuide] SET RECOVERY FULL 
GO

