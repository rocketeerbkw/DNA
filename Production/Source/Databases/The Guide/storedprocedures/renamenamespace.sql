CREATE PROCEDURE renamenamespace @siteid INT, @namespaceid INT, @namespace varchar(255)
AS
BEGIN TRANSACTION
DECLARE @Error INT
UPDATE dbo.NameSPaces SET [Name] = @NameSpace WHERE SIteID = @SiteID AND NameSpaceID = @NameSpaceID
SET @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @Error
END
COMMIT TRANSACTION