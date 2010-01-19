CREATE PROCEDURE addnamespacetosite @siteid int, @namespace varchar(255)
AS
DECLARE @NameSpaceID INT, @Error INT
SELECT @NameSpaceID = NameSpaceID FROM dbo.NameSpaces WHERE Name = @NameSPace AND SiteID = @SiteID
IF (@NameSpaceID IS NULL)
BEGIN
	BEGIN TRANSACTION
	INSERT INTO dbo.NameSpaces SELECT Name = @NameSpace, Site = @SiteID
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	SET @NameSpaceID = @@IDENTITY
	COMMIT TRANSACTION
END
SELECT 'NameSpaceID' = @NameSpaceID