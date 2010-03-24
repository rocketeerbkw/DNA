CREATE FUNCTION udf_tableexists (@tablename varchar(255))
RETURNS INT
AS
BEGIN
	RETURN ISNULL(OBJECTPROPERTY ( object_id(@tablename),'ISTABLE'), 0)
END
