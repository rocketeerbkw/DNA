CREATE PROCEDURE makealertgroupitemsnormalinternal @userid int, @groupid int, @siteid int, @result int OUTPUT
AS
-- Start by setting the default value for result
SET  @Result = 0

-- Get the List ID for sanity checking
DECLARE @InstantListID uniqueidentifier
SELECT @InstantListID = InstantEMailAlertListID FROM dbo.InstantEMailAlertList WHERE UserID = @UserID AND SiteID = @SiteID

-- Check to make sure the user actually owns the group
IF NOT EXISTS ( SELECT * FROM dbo.AlertGroups WHERE GroupID = @GroupID AND USerID = @UserID AND SiteID = @SiteID )
BEGIN
	-- The Member doesn't own the list!
	RETURN 0
END

-- Now Get the Users InstantEmailAlertList
DECLARE @ListID uniqueidentifier, @Error int
EXEC @Error = getusersalertlistidinternal @UserID, @SiteID, 1, @ListID OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError

-- Move the item by changing the EMailAlertListID to the noraml one!
UPDATE dbo.EmailalertListMembers SET EmailAlertListID = @ListID WHERE AlertGroupID = @GroupID
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

-- update the lastupdated values for the normal and instant lists	
UPDATE dbo.EmailAlertList SET LastUpdated = GetDate() WHERE EMailAlertlistID = @ListID
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

-- update the lastupdated values for the normal and instant lists	
UPDATE dbo.InstantEmailAlertList SET LastUpdated = GetDate() WHERE InstantEMailAlertlistID = @InstantListID
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

-- Set the result and return ok!
SET @Result = 1
RETURN 0

-- Handle the error
HandleError:
IF (@Error <> 0)
BEGIN
	EXEC Error @Error
	RETURN @Error
END
