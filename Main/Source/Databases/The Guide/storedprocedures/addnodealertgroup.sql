CREATE PROCEDURE addnodealertgroup @nodeid int, @userid int, @siteid int, @groupid int OUTPUT, @result int OUTPUT
AS
-- Initialise the output parameter
SET @groupid = 0
SET @result = 0

-- Check to see if we already have this item 
DECLARE @NodeType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
SELECT @GroupID = GroupID FROM dbo.AlertGroups WHERE ItemID = @nodeid AND ItemType = @NodeType AND SiteID = @SiteID AND UserID = @UserID
IF ( @GroupID > 0 )
BEGIN
	-- Already have a group for this item!
	RETURN 0
END

-- Now get the notification type and alert list for the new item
DECLARE @IsOwner int, @notifytype int, @listtype int
-- Users cannot own nodes
SELECT @IsOwner = 0

-- Get the first existing alert that matches the isowner status. This will give us the notification type and email alert list
SELECT @NotifyType = elm.NotifyType, @Listtype = CASE WHEN el.EmailAlertListID IS NOT NULL THEN 1 ELSE 2 END
FROM dbo.EmailAlertListMembers elm
INNER JOIN dbo.AlertGroups ag ON ag.GroupID = elm.AlertGroupID
LEFT JOIN dbo.EmailAlertList el ON el.EmailAlertListID = elm.EMailAlertListID
WHERE ag.IsOwner = @IsOwner AND ag.SiteID = @SiteID AND ag.UserID = @UserID

--Make sure we've got some defaults if we didn't find any!
IF (@NotifyType IS NULL)
BEGIN
	SET @NotifyType = 1
END
IF (@ListType IS NULL)
BEGIN
	SET @ListType = 1
END

BEGIN TRANSACTION

-- Insert the node into the alert group list
DECLARE @Error int
INSERT INTO dbo.AlertGroups (UserID, ItemID, ItemType, SiteID, IsOwner) VALUES (@UserID, @nodeid, @NodeType, @SiteID, @IsOwner)
SELECT @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError
SELECT @GroupID = @@IDENTITY

-- Now insert the individual alerts into the Users alert list
-- First get the users list id
DECLARE @ListID uniqueidentifier
EXEC @Error = getusersalertlistidinternal @UserID, @SiteID, @ListType, @ListID OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError

-- Now add the node to the list
EXEC @Error = additemtoemailalertlistinternal @ListID, 'IT_NODE', @nodeid, @NotifyType, @GroupID, @Result OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
IF (@Error <> 0 OR @Result <= 0)
BEGIN
	GOTO HandleError
END


COMMIT TRANSACTION
RETURN 0

-- Handle the error
HandleError:
BEGIN
	ROLLBACK TRANSACTION
	EXEC error @Error
	RETURN @Error
END