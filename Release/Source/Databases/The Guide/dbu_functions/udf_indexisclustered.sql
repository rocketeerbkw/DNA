CREATE FUNCTION udf_indexisclustered(@tablename varchar(255), @indexname varchar(255))
RETURNS INT
AS
BEGIN
	IF (INDEXPROPERTY(object_id(@tablename), @indexname, 'IsClustered') = 1)
	BEGIN
		RETURN 1
	END
RETURN 0
END
