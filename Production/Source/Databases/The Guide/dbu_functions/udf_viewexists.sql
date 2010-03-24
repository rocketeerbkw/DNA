CREATE FUNCTION udf_viewexists (@viewname varchar(255))
RETURNS INT
AS
BEGIN
	RETURN ISNULL(OBJECTPROPERTY ( object_id(@viewname),'ISVIEW'), 0)
END
