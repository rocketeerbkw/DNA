CREATE PROCEDURE deletealertgroup @groupid int, @userid int
AS
-- Make sure the user owns the group
IF NOT EXISTS ( SELECT * FROM dbo.AlertGroups WHERE UserID = @UserID AND @GroupID = GroupID )
BEGIN
	-- The user does not own the group item!
	RETURN 0
END

-- Now get the details of the item before we remove it so we can tell the user what they deleted!
DECLARE @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT

DECLARE @ItemName varchar(256), @ItemID int, @ItemType int
SELECT	@ItemID = al.ItemID,
		@ItemType = al.ItemType,
		@ItemName = CASE
			WHEN al.ItemType = @ClubType THEN (SELECT [Name] FROM dbo.Clubs WHERE ClubID = al.ItemID)
			WHEN al.ItemType = @NodeType THEN (SELECT DisplayName FROM dbo.Hierarchy WHERE NodeID = al.ItemID)
			WHEN al.ItemType = @ArticleType THEN (SELECT Subject FROM dbo.GuideEntries WHERE h2g2ID = al.ItemID)
			WHEN al.ItemType = @ForumType THEN (SELECT Title FROM dbo.Forums WHERE ForumID = al.ItemID)
			WHEN al.ItemType = @ThreadType THEN (SELECT FirstSubject FROM dbo.Threads WHERE ThreadID = al.ItemID)
			ELSE 'Not Known' END
	FROM dbo.AlertGroups al
	WHERE al.GroupID = @GroupID

BEGIN TRANSACTION

-- Remove all the items from the email alert list members table which belong to that group
DECLARE @Error int
DELETE FROM dbo.EmailAlertListMembers WHERE AlertGroupID = @GroupID
SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
IF (@Error <> 0)
BEGIN
	GOTO HandleError
END

-- Finally delete the group from the alerts group table
DELETE FROM dbo.AlertGroups WHERE GroupID = @GroupID
SET @Error = dbo.udf_checkerr(@@ERROR,@Error)
IF (@Error <> 0)
BEGIN
	GOTO HandleError
END

COMMIT TRANSACTION

SELECT 'ItemID' = @ItemID, 'ItemType' = @ItemType, 'ItemName' = @ItemName
RETURN 0

-- Handle the error
HandleError:
BEGIN
	ROLLBACK TRANSACTION
	EXEC error @Error
	RETURN @Error
END