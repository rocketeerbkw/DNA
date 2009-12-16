CREATE PROCEDURE editalertgroups @userid int, @siteid int, @isowner int, @notifytype int, @alertlisttype int, @result int OUTPUT
AS
-- Make sure we set the result flag to a suitable value
SET @Result = 0

-- First get the users list id that was passed in
DECLARE @NewAlertListID uniqueidentifier, @Error int
EXEC @Error = getusersalertlistidinternal @UserID, @SiteID, @alertlisttype, @NewAlertListID OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError

-- Now get the current listid from the items in the emailalertlist table.
DECLARE @CurrentListID uniqueidentifier, @CurrentNotifyType int
SELECT TOP 1 @CurrentListID = elm.EmailAlertListID, @CurrentNotifyType = elm.NotifyType FROM dbo.EmailAlertListMembers elm
	INNER JOIN dbo.AlertGroups ga ON ga.GroupID = elm.AlertGroupID
	WHERE ga.IsOwner = @IsOwner AND ga.UserID = @UserID AND ga.SiteID = @SiteID

-- The list id's don't match, so change the list types to the new one!
IF (@NewAlertListID <> @CurrentListID)
BEGIN
	-- Change the list ids for all the groups with the correct IsOwner status
	UPDATE dbo.EmailAlertListMembers SET EmailAlertListID = @NewAlertListID WHERE AlertGroupID IN
	(
		SELECT GroupID FROM dbo.AlertGroups WHERE UserID = @UserID AND SiteID = @SiteID AND IsOwner = @IsOwner
	)
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

-- Now see if we need to change there's notification types!
IF (@NotifyType <> @CurrentNotifyType)
BEGIN
	-- Change the notification type!
	UPDATE dbo.EmailAlertListMembers SET NotifyType = @NotifyType WHERE AlertGroupID IN
	(
		SELECT GroupID FROM dbo.AlertGroups WHERE UserID = @UserID AND SiteID = @SiteID AND IsOwner = @IsOwner
	)
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

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
