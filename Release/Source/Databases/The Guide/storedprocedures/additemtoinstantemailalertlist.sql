CREATE PROCEDURE additemtoinstantemailalertlist @itemid int, @itemtype int, @notifytype int, @emailalertlistid uniqueidentifier
AS
DECLARE @Error int, @MemberID int
DECLARE @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int, @PostType int, @UserType int, @VoteType int, @LinkType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT
EXEC SetItemTypeValInternal 'IT_POST', @PostType OUTPUT
EXEC SetItemTypeValInternal 'IT_USER', @UserType OUTPUT
EXEC SetItemTypeValInternal 'IT_VOTE', @VoteType OUTPUT
EXEC SetItemTypeValInternal 'IT_LINK', @LinkType OUTPUT
		
SELECT @MemberID = 0

IF (@itemtype = @NodeType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.Hierarchy WHERE NodeID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @ArticleType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.GuideEntries WHERE h2g2id = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @ClubType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.Clubs WHERE ClubID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @ForumType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.Forums WHERE ForumID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @ThreadType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.Threads WHERE ThreadID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @PostType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.ThreadEntries WHERE EntryID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @UserType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.Users WHERE UserID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @VoteType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.Votes WHERE VoteID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END
ELSE IF (@itemtype = @LinkType)
BEGIN
	IF NOT EXISTS ( SELECT * FROM dbo.Links WHERE LinkID = @itemid )
	BEGIN
		SELECT 'Result' = 0, 'MemberID' = @MemberID
		RETURN 0 
	END
END

IF NOT EXISTS ( SELECT ItemID FROM dbo.EmailAlertListMembers WHERE EMailAlertListID = @emailalertlistid AND ItemID = @itemid )
BEGIN
	BEGIN TRANSACTION
	INSERT INTO dbo.EmailAlertListMembers (EMailAlertlistID,ItemID,ItemType,NotifyType,AlertGroupID) VALUES (@emailalertlistid,@itemid,@itemtype,@notifytype,0)
	SELECT @Error = @@ERROR
	SELECT @MemberID = @@IDENTITY
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	UPDATE dbo.InstantEmailAlertList SET LastUpdated = GetDate() WHERE InstantEMailAlertlistID = @emailalertlistid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	COMMIT TRANSACTION
END
ELSE
BEGIN
	SELECT @MemberID = MemberID FROM dbo.EmailAlertListMembers WITH(NOLOCK) WHERE EmailAlertListID = @emailalertlistid AND ItemID = @itemid AND ItemType = @itemtype AND NotifyType = @notifytype
END

SELECT 'Result' = 1, 'MemberID' = @MemberID