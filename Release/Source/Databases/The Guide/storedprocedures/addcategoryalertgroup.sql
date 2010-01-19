CREATE PROCEDURE addcategoryalertgroup @nodeid int, @userid int, @siteid int, @groupid int OUTPUT, @result int OUTPUT
--CREATE PROCEDURE addcategoryalertgroup @nodeid int, @userid int, @notifytype int, @siteid int, @listtype int, @groupid int OUTPUT, @result int OUTPUT
AS
-- Initialise the output parameter
SET @groupid = 0

-- Check to see if we already have this item 
DECLARE @NodeType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
SELECT @GroupID = GroupID FROM dbo.AlertGroups WHERE ItemID = @NodeID AND ItemType = @NodeType AND SiteID = @SiteID AND UserID = @UserID
IF ( @GroupID > 0 )
BEGIN
	-- Already have a group for this item!
	RETURN 0
END

-- Get the first existing alert that matches the isowner status. This will give us the notification type and email alert list
DECLARE @IsOwner int, @notifytype int, @listtype int
SELECT @NotifyType = ISNULL(elm.NotifyType,1), @Listtype = CASE WHEN el.EmailAlertListID IS NOT NULL THEN 1 ELSE 2 END
FROM dbo.EmailAlertListMembers elm
INNER JOIN dbo.AlertGroups ag ON ag.GroupID = elm.AlertGroupID
LEFT JOIN dbo.EmailAlertList el ON el.EmailAlertListID = elm.EMailAlertListID
WHERE ag.IsOwner = 0 AND ag.SiteID = @SiteID AND ag.UserID = @UserID

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

-- Insert the Node into the alert group list
DECLARE @Error int
INSERT INTO dbo.AlertGroups (UserID, ItemID, ItemType, SiteID, IsOwner) VALUES (@UserID, @NodeID, @NodeType, @SiteID, 0)
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
SELECT @GroupID = @@IDENTITY

-- Now insert the individual alerts into the Users alert list
-- First get the users list id
DECLARE @ListID uniqueidentifier
EXEC @Error = getusersalertlistidinternal @UserID, @SiteID, @ListType, @ListID OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError

-- Now add the Node to the list
EXEC @Error = additemtoemailalertlistinternal @ListID, 'IT_NODE', @NodeID, @NotifyType, @GroupID, @Result OUTPUT
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