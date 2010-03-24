/*
	See dbu_createfkeystemptable for details on how to use this SP
*/
CREATE PROCEDURE dbu_dropfkeys
AS
	DECLARE @sql varchar(1000);
	DECLARE C CURSOR FAST_FORWARD FOR SELECT Dropcmd FROM ##FKeys;
	OPEN C;
	FETCH NEXT FROM C INTO @sql;
	WHILE @@fetch_status = 0
	BEGIN
		EXEC (@sql)
		FETCH NEXT FROM C INTO @sql;
	END
	CLOSE C;
	DEALLOCATE C;