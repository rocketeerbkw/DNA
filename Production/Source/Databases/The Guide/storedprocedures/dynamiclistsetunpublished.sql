-- Removes list instance and sets publishstate to 0
CREATE PROCEDURE dynamiclistsetunpublished @listname varchar(40)
AS
BEGIN TRANSACTION

DECLARE @ErrorCode INT

-- Delete instance
DELETE FROM DynamicLists WHERE name = @listname
SET @ErrorCode = @@ERROR
if(@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Unpublish
UPDATE DynamicListDefinitions 
SET PublishState = 0 WHERE name = @listname
SET @ErrorCode = @@ERROR
if(@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
