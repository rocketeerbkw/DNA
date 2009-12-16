CREATE FUNCTION udf_triggerexists (@triggername varchar(255))
RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM sysobjects so WHERE so.xtype='TR' AND so.name=@triggername)
		RETURN 1
		
	RETURN 0
END
