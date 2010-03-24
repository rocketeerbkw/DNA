Create Procedure dynamiclistupdatelist @id INT, @name varchar(50), @xml varchar(MAX), @duplicate int output
AS 

SET @duplicate = 0
DECLARE @CHECK INT
SELECT @CHECK = [id] from DynamicListDefinitions where [name] = @name
IF (@CHECK IS NULL OR @CHECK = @ID)
BEGIN
	UPDATE DynamicListDefinitions SET [name] = @name, [xml] = @xml,LastUpdated = CURRENT_TIMESTAMP
	WHERE [id] = @Id
END
ELSE
BEGIN
	SET @duplicate = 1
END

RETURN @@ERROR