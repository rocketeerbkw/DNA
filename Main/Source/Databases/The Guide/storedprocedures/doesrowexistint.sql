/*tests to see if a row in a table exists*/

CREATE PROCEDURE doesrowexistint @tablename VARCHAR(128), @keyfieldname VARCHAR(128), @key INT
As
BEGIN
DECLARE @command NVARCHAR(800)
DECLARE @ErrorCode INT

	SET @command = 	'SELECT ''Success'' = count(*) FROM ' + QUOTENAME(@tablename) + ' t ' +
					'WHERE t.' + QUOTENAME(@keyfieldname) + '= @key'

	EXECUTE sp_executesql @command, 
							N'@key INT',
							@key = @key 

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
return(0)
