CREATE FUNCTION udf_storedprocedureexists (@spname varchar(255))
RETURNS INT
AS
BEGIN
	RETURN ISNULL(OBJECTPROPERTY ( object_id(@spname),'ISPROCEDURE'), 0)
END
