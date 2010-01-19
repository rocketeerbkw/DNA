CREATE PROCEDURE searchforuserviaemail @viewinguserid int, @email varchar(255), @checkallsites tinyint
AS
-- Check to see if we found a valid email. Empty or NULL will cause major problems for the database!
IF (@Email != '' AND @Email IS NOT NULL AND @Email != '0')
BEGIN
	DECLARE @ErrorCode INT
	EXEC @ErrorCode = SearchForUserViaEmailInternal @viewinguserid, @Email, @checkallsites
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END