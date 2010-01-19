/*
	See dbu_createfkeystemptable for details on how to use this SP
	
	Note: @nocheck - when set to 1, it will add the FK with the "NOCHECK" option.  Not generally recommended though!
*/
CREATE PROCEDURE dbu_addfkeys @nocheck bit = NULL
AS
	DECLARE @sql varchar(1000);
	DECLARE C CURSOR FAST_FORWARD FOR SELECT Addcmd FROM ##FKeys;
	OPEN C;
	FETCH NEXT FROM C INTO @sql;
	WHILE @@fetch_status = 0
	BEGIN
		IF @nocheck=1 SET @sql=REPLACE(@sql,'WITH CHECK','WITH NOCHECK')
		EXEC (@sql)
		FETCH NEXT FROM C INTO @sql;
	END
	CLOSE C;
	DEALLOCATE C;