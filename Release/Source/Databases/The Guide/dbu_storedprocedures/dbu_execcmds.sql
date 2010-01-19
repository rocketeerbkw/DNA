/*
	dbu_execcmds @table, @colname
	
		This will execute the commands in the @table stored in @colname
*/
CREATE PROCEDURE dbu_execcmds @table varchar(100), @colname varchar(100)
AS

	DECLARE @sql varchar(MAX)
	
	SET @sql = '
		DECLARE @sql varchar(1000);
		DECLARE C CURSOR FAST_FORWARD FOR SELECT '+@colname+' FROM '+@table+'
		OPEN C;
		FETCH NEXT FROM C INTO @sql;
		WHILE @@fetch_status = 0
		BEGIN
			EXEC (@sql)
			FETCH NEXT FROM C INTO @sql;
		END
		CLOSE C;
		DEALLOCATE C;'
		
	EXEC (@sql)