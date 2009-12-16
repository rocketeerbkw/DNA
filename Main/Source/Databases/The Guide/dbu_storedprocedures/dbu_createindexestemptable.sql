/*
	dbu_createindexestemptable
	
	Creates a global temp table called ##TableIndexes containing commands to create and drop 
	all the index & unique constraints for the given table
	
	Once created you can call dbu_execcmds to drop and create the indexes:
		dbu_execcmds '##TableIndexes', 'DropCMD'   - Drops all the Indexes defined in ##TableIndexes
		dbu_execcmds '##TableIndexes', 'CreateCMD' - Creates all the Indexes defined in ##TableIndexes
		
	E.g.
		EXEC dbu_createindexestemptable 'ThreadEntries'
		EXEC dbu_execcmds '##TableIndexes', 'DropCMD'
		....
		EXEC dbu_execcmds '##TableIndexes', 'CreateCMD'
		DROP TABLE ##TableIndexes
*/
CREATE PROCEDURE dbu_createindexestemptable @tablename varchar(100) = NULL
AS
	WITH TableIndexes AS
	(
		SELECT	@tablename AS 'TableName',
				si.name,
				si.index_id,
				si.type_desc,
				si.is_unique,
				si.is_primary_key,
				si.is_unique_constraint
			FROM sys.indexes si
			JOIN sys.objects so ON si.object_id = so.object_id
			WHERE so.name=@tablename AND si.name IS NOT NULL
	),
	DropPK AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' DROP CONSTRAINT '+ti.name as DropCMD,
				ti.name
				FROM TableIndexes ti
				WHERE ti.is_primary_key = 1
	),
	DropUnqConst AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' DROP CONSTRAINT '+ti.name as DropCMD, 
				ti.name 
				FROM TableIndexes ti
				WHERE ti.is_unique_constraint = 1
	),
	DropIndexes AS
	(
		SELECT 'DROP INDEX '+ ti.name+' ON '+ti.TableName as DropCMD, 
				ti.name 
				FROM TableIndexes ti
				WHERE ti.is_primary_key = 0 AND ti.is_unique_constraint = 0
	),
	DropCmds AS
	(
		SELECT * FROM DropPK
		UNION
		SELECT * FROM DropUnqConst
		UNION
		SELECT * FROM DropIndexes
	),
	KeyCols AS
	(
		SELECT	ti.TableName, 
				ti.name,
				cols.COLUMN_NAME, 
				ic.is_included_column
			FROM sys.index_columns ic
			INNER JOIN TableIndexes ti ON ic.index_id = ti.index_id AND ic.object_id = OBJECT_ID(ti.tablename)
			INNER JOIN INFORMATION_SCHEMA.COLUMNS cols on ic.column_id = cols.ORDINAL_POSITION
			WHERE cols.TABLE_NAME = ti.TableName
	),
	KeyColList AS
	(
		SELECT DISTINCT name, '('+LEFT(colList, LEN(colList)-2)+')' AS colList
			FROM KeyCols kc
				CROSS APPLY (SELECT COLUMN_NAME+', ' AS [text()] FROM KeyCols 
								WHERE name = kc.name AND is_included_column = 0
								FOR XML PATH('')) AS s(colList)
	),
	KeyIncludeList AS
	(
		SELECT DISTINCT name, '('+LEFT(colList, LEN(colList)-2)+')' AS colList
			FROM KeyCols kc
				CROSS APPLY (SELECT COLUMN_NAME+', ' AS [text()] FROM KeyCols 
								WHERE name = kc.name AND is_included_column = 1
								FOR XML PATH('')) AS s(colList)
	),
	CreatePK AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' ADD CONSTRAINT '+ti.name+' PRIMARY KEY'+kcl.colList as CreateCMD,
				ti.name
				FROM TableIndexes ti
				INNER JOIN KeyColList kcl ON ti.name = kcl.name
				WHERE ti.is_primary_key = 1
	),
	CreateUnqConst AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' ADD CONSTRAINT '+ti.name+' UNIQUE'+kcl.colList as CreateCMD,
				ti.name
				FROM TableIndexes ti
				INNER JOIN KeyColList kcl ON ti.name = kcl.name
				WHERE ti.is_unique_constraint = 1
	),
	CreateIndexes AS
	(
		SELECT 'CREATE '+
					CASE WHEN ti.is_unique = 1 THEN 'UNIQUE ' ELSE N'' END+
					(ti.type_desc COLLATE Latin1_General_CI_AS)+
					' INDEX '+ (ti.name COLLATE Latin1_General_CI_AS )+' ON '+ti.TableName+kcl.colList+
					CASE WHEN kil.colList IS NOT NULL THEN ' INCLUDE '+kil.colList ELSE '' END 
					AS CreateCMD,
					ti.name 
				FROM TableIndexes ti
				INNER JOIN KeyCols kc ON ti.name = kc.name
				INNER JOIN KeyColList kcl ON ti.name = kcl.name
				LEFT JOIN KeyIncludeList kil ON ti.name = kil.name
				WHERE ti.is_primary_key = 0 AND ti.is_unique_constraint = 0
	),
	CreateCmds AS
	(
		SELECT * FROM CreatePK
		UNION
		SELECT * FROM CreateUnqConst
		UNION
		SELECT * FROM CreateIndexes
	)
	SELECT cc.CreateCMD, dc.DropCMD, ti.* 
		INTO ##TableIndexes
		FROM TableIndexes ti
		LEFT JOIN DropCmds dc ON ti.name = dc.name
		LEFT JOIN CreateCmds cc ON ti.name = cc.name
