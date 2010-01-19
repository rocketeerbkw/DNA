CREATE FUNCTION udf_getcolumntype (@tablename varchar(255), @columnname varchar(255))
RETURNS VARCHAR(128)
AS
BEGIN
DECLARE @typename VARCHAR(128)

	SELECT @typename = mytype.name from sys.tables mytable 
	INNER JOIN sys.columns mycolumn on mytable.object_id = mycolumn.object_id 
	INNER JOIN sys.types mytype on mytype.user_type_id = mycolumn.user_type_id
	WHERE mytable.name = @tablename 
	AND mycolumn.name = @columnname
	
	RETURN @typename
END
