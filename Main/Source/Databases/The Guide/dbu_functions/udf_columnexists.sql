CREATE FUNCTION udf_columnexists (@tablename varchar(255), @columnname varchar(255))
RETURNS INT
AS
BEGIN
	IF COLUMNPROPERTY(object_id(@tablename), @columnname, 'precision') IS NULL
	BEGIN
		RETURN 0
	END
RETURN 1
END
