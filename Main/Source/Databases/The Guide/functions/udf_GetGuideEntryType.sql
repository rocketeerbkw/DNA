CREATE  FUNCTION  udf_getguideentrytype (@itype INT)
RETURNS VARCHAR(255)
AS
BEGIN 
	IF (@iType >= 1 AND @iType <= 1000 )
		RETURN 'Article'

	IF (@iType >= 1001 AND @iType <= 2000 )
		RETURN 'Campaign'
	
	
	IF (@iType >= 4001 AND @iType <= 5000 )
		RETURN 'Category'
		
	RETURN NULL;
END

