CREATE PROCEDURE editgroupalert @userid int, @groupid int, @alerttype int, @notifytype int, @result int OUTPUT
AS
-- Set the default for the Result value
SET @Result = 0

-- Make sure the user owns the group
IF NOT EXISTS ( SELECT * FROM dbo.AlertGroups WITH(NOLOCK) WHERE UserID = @UserID AND @GroupID = GroupID )
BEGIN
	-- The user does not own the group item!
	RETURN 0
END

-- Now see what needs to be done. Get the current notification type and the current list the group belongs to
DECLARE @CurrentNotifyType int, @CurrentAlertType int, @SiteID int
SELECT @CurrentNotifyType = em.NotifyType, @SiteID = al.SiteID, @CurrentAlertType = CASE WHEN em.EmailAlertListID IS NULL THEN 2 ELSE 1 END
FROM dbo.AlertGroups al
INNER JOIN dbo.EMailAlertListMembers em ON em.ItemID = al.ItemID AND em.ItemType = al.ItemTYpe AND em.AlertGroupID = al.GroupID
LEFT JOIN dbo.EmailAlertList el ON el.EmailAlertListID = em.EmailAlertListID

-- Start the transaction
BEGIN TRANSACTION
DECLARE @Error int

-- Do we need to change the alert group?
IF (@CurrentAlertType <> @alerttype)
BEGIN
	-- Yes, now do the move. First find out if we're moving from normal to instant or the other ways round
	IF (@CurrentAlertType = 1)
	BEGIN
		-- It's a normal alert, so make it instant!
		EXEC @Error = makealertgroupitemsinstantinternal @UserID, @GroupID, @SiteID, @result OUTPUT
		SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
		IF (@Error <> 0 OR @Result <= 0)
		BEGIN
			GOTO HandleError
		END
	END
	ELSE
	BEGIN
		-- It's an instant alert, so make it normal!
		EXEC @Error = makealertgroupitemsnormalinternal @UserID, @GroupID, @SiteID, @result OUTPUT
		SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
		IF (@Error <> 0 OR @Result <= 0)
		BEGIN
			GOTO HandleError
		END
	END
END

-- Now check to see if we need to change the notification type
IF (@CurrentNotifyType <> @NotifyType)
BEGIN
	UPDATE dbo.EmailAlertListMembers SET NotifyType = @NotifyType WHERE AlertGroupID = @GroupID
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error) IF (@Error <> 0) GOTO HandleError
END

COMMIT TRANSACTION

-- Every thing went ok! set the result and return
SET  @Result = 0
RETURN 0

-- Handle the error
HandleError:
BEGIN
	ROLLBACK TRANSACTION
	EXEC error @Error
	RETURN @Error
END