/*
	dbu_createfkeystemptable
	
	Creates a global temp table called ##FKeys containing either all the FKs referencing the table @tablename
	or all the FKs in the database if NULL (or no param) is passed in.
	
	Once created you can call the following SPs:
		dbu_dropfkeys - Drops all the FKs defined in ##FKeys
		dbu_addfkeys  - Adds all the FKs defined in ##FKeys
		
	E.g.
		EXEC dbu_createfkeystemptable 'Users'
		EXEC dbu_dropfkeys
		....
		EXEC dbu_addfkeys
		DROP TABLE ##FKeys
*/
CREATE PROCEDURE dbu_createfkeystemptable @tablename varchar(100) = NULL
AS
	SELECT	'ALTER TABLE ['+cols.TABLE_NAME+'] WITH CHECK ADD CONSTRAINT ['+ref.CONSTRAINT_NAME+'] FOREIGN KEY(['+cols.COLUMN_NAME+']) REFERENCES ['+colsU.TABLE_NAME+'] (['+colsU.COLUMN_NAME+'])' AS Addcmd,
			'ALTER TABLE ['+cols.TABLE_NAME+'] DROP CONSTRAINT ['+ref.CONSTRAINT_NAME+']' AS Dropcmd,
			ref.CONSTRAINT_NAME as FKeyName, 
			cols.TABLE_NAME as SourceTable,
			cols.COLUMN_NAME as SourceColumn,
			colsU.TABLE_NAME as TargetTable,
			colsU.COLUMN_NAME as TargetColumn
		INTO ##FKeys
		FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS ref
		INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cols  ON ref.CONSTRAINT_NAME = cols.CONSTRAINT_NAME
		INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE colsU ON ref.UNIQUE_CONSTRAINT_NAME = colsU.CONSTRAINT_NAME
		WHERE colsU.TABLE_NAME=@tablename OR @tablename IS NULL
