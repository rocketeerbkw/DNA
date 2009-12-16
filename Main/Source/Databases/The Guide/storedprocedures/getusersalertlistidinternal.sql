CREATE PROCEDURE getusersalertlistidinternal @userid int, @siteid int, @listtype int, @listid uniqueidentifier OUTPUT
AS
-- Make sure we're called within a transaction
DECLARE @CommitTransaction int, @Error int
SET @CommitTransaction = 0
IF (@@TRANCOUNT = 0)
BEGIN
	BEGIN TRANSACTION
	SET @CommitTransaction = 1
END

-- See what type of list we are wanting to get
IF ( @ListType = 1 )
BEGIN
	-- Get the users normal alert list
	SELECT @ListID = EMailAlertListID FROM dbo.EmailAlertList WHERE UserID = @UserID AND SiteID = @SiteID
	IF ( @ListID IS NULL )
	BEGIN
		-- Create the new list for the user
		SELECT @ListID = NewID()
		INSERT INTO dbo.EMailAlertList (EmailAlertListID, UserID, CreatedDate, LastUpdated, SiteID)
			VALUES (@ListID, @UserID, GetDate(), GetDate(), @SiteID)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			RETURN @Error
		END
	END
END
ELSE
BEGIN
	-- Get the users instant alert list
	SELECT @ListID = InstantEMailAlertListID FROM dbo.InstantEmailAlertList WHERE UserID = @UserID AND SiteID = @SiteID
	IF ( @ListID IS NULL )
	BEGIN
		-- Create the new list for the user
		SELECT @ListID = NewID()
		INSERT INTO dbo.InstantEMailAlertList (InstantEmailAlertListID, UserID, CreatedDate, LastUpdated, SiteID)
			VALUES (@ListID, @UserID, GetDate(), GetDate(), @SiteID)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			RETURN @Error
		END
	END
END

-- Commit the transaction if we started it
IF (@CommitTransaction = 1)
BEGIN
	COMMIT TRANSACTION
END