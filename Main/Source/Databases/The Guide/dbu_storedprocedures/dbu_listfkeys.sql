CREATE PROCEDURE dbu_listfkeys  @table varchar(100), @mode int = 0, @outtable varchar(500) = null
AS

CREATE TABLE #tables (name varchar(100))
INSERT INTO #tables SELECT name FROM sysobjects WHERE type='U'
 
CREATE TABLE #fkeys (   pktable_qualifier varchar(100), 
                        pktable_owner varchar(100), 
                        pktable_name varchar(100), 
                        pkcolumn_name varchar(100), 
                        fktable_qualifier varchar(100), 
                        fktable_owner varchar(100), 
                        fktable_name varchar(100), 
                        fkcolumn_name varchar(100), 
                        key_seq int, 
                        update_rule int, 
                        delete_rule int, 
                        fk_name varchar(100), 
                        pk_name varchar(100), 
                        deferrability int) 
 
DECLARE @name varchar(100), @sql nvarchar(4000)
DECLARE fcur CURSOR FOR SELECT name FROM #tables
OPEN fcur
FETCH NEXT FROM fcur INTO @name
while @@FETCH_STATUS = 0
BEGIN
	SET @sql = '	insert #fkeys (pktable_qualifier,pktable_owner,pktable_name,pkcolumn_name,fktable_qualifier,fktable_owner, 
                        	fktable_name,fkcolumn_name,key_seq,update_rule,delete_rule,fk_name, 
				pk_name,deferrability) 
        			exec sp_fkeys @pktable_name='''+@name+''''
	 
	EXEC sp_executesql @sql
 
	FETCH NEXT FROM fcur INTO @name
END
CLOSE fcur
DEALLOCATE fcur

IF @mode = 0 
BEGIN
	SELECT 'drop'='alter table '+fktable_name+' drop constraint '+fk_name FROM #fkeys
		WHERE pktable_name=@table OR fktable_name=@table
	 
	SELECT 'add'='alter table '+fktable_name+' add constraint '+fk_name+' FOREIGN KEY ('+fkcolumn_name+') REFERENCES '+pktable_name+' ('+pkcolumn_name+')' FROM #fkeys 
		WHERE pktable_name=@table OR fktable_name=@table
END

IF @mode = 1 AND @outtable IS NOT NULL
BEGIN
	SET @sql = 'INSERT INTO '+@outtable+' SELECT fk_name FROM #fkeys
		WHERE pktable_name='+QUOTENAME(@table,'''')+' OR fktable_name='+QUOTENAME(@table,'''')
	EXEC sp_executesql @sql
END

DROP TABLE #fkeys
DROP TABLE #tables
