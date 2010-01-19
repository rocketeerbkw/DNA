CREATE PROCEDURE additemtoemailalertlistinternal @listid uniqueidentifier, @itemtypename varchar(50), @itemid int, @notifytype int, @groupid int, @result int OUTPUT
AS
/*
	The Result parameter will be filled with one of the following values...
	
	1 = Everything went ok
	0 = Item does not exists
	-1 = Invalid Type given
	-2 = Insert into members table failed
	-3 = Update alert list failed	
*/

-- Setup all the known types so we can be sanity checks for the item
DECLARE @ItemType int, @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int, @PostType int, @UserType int, @VoteType int, @LinkType int, @TeamType int, @PrivateType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT
EXEC SetItemTypeValInternal 'IT_POST', @PostType OUTPUT
EXEC SetItemTypeValInternal 'IT_USER', @UserType OUTPUT
EXEC SetItemTypeValInternal 'IT_VOTE', @VoteType OUTPUT
EXEC SetItemTypeValInternal 'IT_LINK', @LinkType OUTPUT
EXEC SetItemTypeValInternal 'IT_TEAM', @TeamType OUTPUT
EXEC SetItemTypeValInternal 'IT_PRIVATEFORUM', @PrivateType OUTPUT

-- Now get the type for the given item
EXEC SetItemTypeValInternal @itemtypename, @ItemType OUTPUT

-- Check to make sure the item actaully exists
IF (@itemtype = @NodeType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Hierarchy WHERE NodeID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @ArticleType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.GuideEntries WHERE h2g2id = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @ClubType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Clubs WHERE ClubID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @ForumType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Forums WHERE ForumID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @ThreadType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Threads WHERE ThreadID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @PostType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.ThreadEntries WHERE EntryID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @UserType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Users WHERE UserID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @VoteType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Votes WHERE VoteID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @LinkType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Links WHERE LinkID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @TeamType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Teams WHERE TeamID = @itemid ) THEN 1 ELSE 0 END
END
ELSE IF (@itemtype = @PrivateType)
BEGIN
	SET @Result = CASE WHEN EXISTS ( SELECT * FROM dbo.Forums WHERE ForumID = @itemid ) THEN 1 ELSE 0 END
END
ELSE
BEGIN
	SET @Result = -1
END

-- See if we have a valid item to insert
IF (@Result <= 0)
BEGIN
	 -- No!
	RETURN 0
END

-- Check to see if the item already exists in the list!
IF EXISTS ( SELECT * FROM dbo.EmailAlertListMembers WHERE EMailAlertListID = @ListID AND ItemID = @ItemID AND ItemType = @ItemType AND NotifyType = @NotifyTYpe AND AlertGroupID = @GroupID )
BEGIN
	-- Already exists! Just return!
	SET  @Result = 1
	RETURN 0
END

-- Insert into the correct list
DECLARE @Error int
INSERT INTO dbo.EmailAlertListMembers (EMailAlertListID,ItemID,ItemType,NotifyType,AlertGroupID) VALUES (@ListID,@ItemID,@ItemType,@NotifyType,@GroupID)
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	SET @Result = -2
	RETURN @Error
END

-- Now update the users alert list last updated flag. Find out which list the listid belongs to
IF EXISTS ( SELECT * FROM dbo.EMailAlertList WHERE EMailAlertListID = @ListID )
BEGIN
	UPDATE dbo.EmailAlertList SET LastUpdated = GetDate() WHERE EMailAlertListID = @ListID
END
ELSE
BEGIN
	UPDATE dbo.InstantEmailAlertList SET LastUpdated = GetDate() WHERE InstantEMailAlertListID = @ListID
END
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	SET @Result = -3
	RETURN @Error
END

-- We got here so it all went ok
SET @Result = 1