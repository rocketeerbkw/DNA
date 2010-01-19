CREATE PROCEDURE deletebydatefromeventqueue @date datetime
AS

DECLARE @ErrorCode INT

BEGIN TRANSACTION

DELETE FROM EventQueue WHERE EventDate < @date
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END
	
COMMIT TRANSACTION
