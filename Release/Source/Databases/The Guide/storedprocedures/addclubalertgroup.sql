CREATE PROCEDURE addclubalertgroup @clubid int, @userid int, @siteid int, @groupid int OUTPUT, @result int OUTPUT
--CREATE PROCEDURE addclubalertgroup @clubid int, @userid int, @notifytype int, @siteid int, @listtype int, @groupid int OUTPUT, @result int OUTPUT
AS
-- Initialise the output parameter
SET @groupid = 0
SET @result = 0

-- Check to see if we already have this item 
DECLARE @ClubType int
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
SELECT @GroupID = GroupID FROM dbo.AlertGroups WHERE ItemID = @ClubID AND ItemType = @ClubType AND SiteID = @SiteID AND UserID = @UserID
IF ( @GroupID > 0 )
BEGIN
	-- Already have a group for this item!
	RETURN 0
END

-- Now get the notification type and alert list for the new item
DECLARE @IsOwner int, @notifytype int, @listtype int
SELECT @IsOwner = CASE WHEN EXISTS (SELECT * FROM dbo.Clubs cc INNER JOIN dbo.TeamMembers tm ON tm.TeamID = cc.OwnerTeam WHERE cc.ClubID = @ClubID AND tm.UserID = @UserID ) THEN 1 ELSE 0 END

-- Get the first existing alert that matches the isowner status. This will give us the notification type and email alert list
SELECT @NotifyType = ISNULL(elm.NotifyType,1), @Listtype = CASE WHEN el.EmailAlertListID IS NOT NULL THEN 1 ELSE 2 END
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

-- Insert the Node into the alert group list
DECLARE @Error int
INSERT INTO dbo.AlertGroups (UserID, SiteID, ItemID, ItemType, IsOwner) VALUES (@UserID, @SiteID, @ClubID, @ClubType, @IsOwner)
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
SELECT @GroupID = @@IDENTITY

-- Now insert the individual alerts into the Users alert list
-- First get the users list id
DECLARE @ListID uniqueidentifier
EXEC @Error = getusersalertlistidinternal @UserID, @SiteID, @ListType, @ListID OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError

-- Now add the club into the list
EXEC @Error = additemtoemailalertlistinternal @ListID, 'IT_CLUB', @ClubID, @NotifyType, @GroupID, @Result OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
IF (@Error <> 0 OR @Result <= 0)
BEGIN
	GOTO HandleError
END

-- Get all the relavent details like diary id h2g2id....
DECLARE @JournalID int, @h2g2ID int, @OwnerTeamID int, @MemberTeamID int
SELECT @JournalID = Journal, @h2g2ID = h2g2ID, @OwnerTeamID = OwnerTeam, @MemberTeamID = MemberTeam FROM dbo.Clubs WHERE ClubID = @ClubID

-- Now add the Journal into the list
EXEC @Error = additemtoemailalertlistinternal @ListID, 'IT_FORUM', @JournalID, @NotifyType, @GroupID, @Result OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
IF (@Error <> 0 OR @Result <= 0)
BEGIN
	GOTO HandleError
END

-- Now add the guideentry into the list
EXEC @Error = additemtoemailalertlistinternal @ListID, 'IT_H2G2ID', @h2g2ID, @NotifyType, @GroupID, @Result OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
IF (@Error <> 0 OR @Result <= 0)
BEGIN
	GOTO HandleError
END

-- Now add the Owners Team into the list
EXEC @Error = additemtoemailalertlistinternal @ListID, 'IT_TEAM', @OwnerTeamID, @NotifyType, @GroupID, @Result OUTPUT
SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
IF (@Error <> 0 OR @Result <= 0)
BEGIN
	GOTO HandleError
END

-- Now add the Member Team into the list
EXEC @Error = additemtoemailalertlistinternal @ListID, 'IT_TEAM', @MemberTeamID, @NotifyType, @GroupID, @Result OUTPUT
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
