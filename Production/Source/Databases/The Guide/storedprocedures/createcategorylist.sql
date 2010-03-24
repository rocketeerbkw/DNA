CREATE PROCEDURE createcategorylist @userid int, @siteid int, @description varchar(128), @website varchar(128), @isowner bit
AS
DECLARE @GUID uniqueidentifier
SELECT @GUID = NewID()
BEGIN TRANSACTION
	-- Insert he given values into the category list table. No need to check for existing lists as a user can have more than one!
	DECLARE @Error INT
	INSERT INTO dbo.CategoryList (CategoryListID, UserID, Description, CreatedDate, LastUpdated, SiteID, Website, IsOwner)
		VALUES (@GUID, @userid, @description, GetDate(), GetDate(), @siteid, @website, @isowner)
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION

-- return the details for the new list
SELECT CategoryListID, UserID, SiteID, Description, Website, IsOwner, CreatedDate, LastUpdated FROM dbo.CategoryList WHERE CategoryListID = @GUID