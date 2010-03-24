CREATE FUNCTION udf_indexexists(@tablename varchar(255), @indexname varchar(255))
RETURNS INT
AS
BEGIN
	IF (INDEXPROPERTY(object_id(@tablename), @indexname, 'IndexID') IS NULL)
	BEGIN
		RETURN 0
	END
RETURN 1	
END
