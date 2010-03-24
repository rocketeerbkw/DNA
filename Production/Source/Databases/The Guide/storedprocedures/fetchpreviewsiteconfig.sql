CREATE PROCEDURE fetchpreviewsiteconfig @siteid int
AS
-- First make sure that we have a preview row for the given site.
IF NOT EXISTS ( SELECT * FROM dbo.PreviewConfig WHERE SiteID = @siteid)
BEGIN
	-- Make sure we have an active config before trying to create the preview verison
	DECLARE @Error int
	IF NOT EXISTS ( SELECT * FROM dbo.Sites WHERE SiteID = @siteid )
	BEGIN
		RAISERROR('Fetch Preview Site Data - Active site has not been setup yet!',16,1)
		SELECT @Error = 50000
	END

	-- Now create the new row in the preview config table for the given site.	
	BEGIN TRANSACTION
	INSERT INTO dbo.PreviewConfig SELECT SiteID = @siteid, Config = s.Config, EditKey = NewID()
		FROM dbo.Sites s WHERE s.SiteID = @siteid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	COMMIT TRANSACTION
END

SELECT Config, EditKey FROM dbo.PreviewConfig WHERE SiteID = @siteid