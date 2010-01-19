CREATE FUNCTION udf_getobjectname
(
	@resource_type varchar(500),
	@object_id bigint
)
RETURNS sysname
AS
BEGIN
	DECLARE @ResultVar sysname

	IF @resource_type='OBJECT'
	BEGIN
		SELECT @ResultVar=OBJECT_NAME(CAST(@object_id AS int))
	END
	ELSE
	BEGIN
		SELECT @ResultVar= OBJECT_NAME(p.object_id) FROM sys.partitions p where hobt_id=@object_id
	END
	RETURN @ResultVar
END