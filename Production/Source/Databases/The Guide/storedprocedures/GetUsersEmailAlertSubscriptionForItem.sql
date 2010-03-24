CREATE PROCEDURE getusersemailalertsubscriptionforitem @userid int, @itemid int, @itemtype int
AS
-- Get the internal values for the different item types.
DECLARE @ArticleType int, @ClubType int, @ForumType int, @ThreadType int
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT

-- Get the details for the item. This also includes what type of email alert it is.
DECLARE @MemberID int
DECLARE @NotifyType int
DECLARE @EmailListType int
DECLARE @Error int

-- Check to see if the item exists in the users EMailAlertLIst
SELECT @MemberID = elm.MemberID, @NotifyType = elm.NotifyType
	FROM dbo.EmailAlertListMembers elm
	INNER JOIN dbo.EmailAlertList el ON el.EMailAlertListID = elm.EMailAlertListID
	WHERE el.UserID = @userid AND elm.ItemType = @itemtype AND elm.ItemID = @itemid
IF ( @MemberID IS NOT NULL )
BEGIN
	-- Found it! It's in the EmailAlertList
	SELECT @EmailListType = 1
END
ELSE
BEGIN
	-- Not in the Email Alert List, Check the Instant list!
	SELECT @MemberID = ielm.MemberID, @NotifyType = ielm.NotifyType
		FROM dbo.EmailAlertListMembers ielm
		INNER JOIN dbo.InstantEmailAlertList iel ON iel.InstantEMailAlertListID = ielm.EMailAlertListID
		WHERE iel.UserID = @userid AND ielm.ItemType = @itemtype AND ielm.ItemID = @itemid
	IF ( @MemberID IS NULL )
	BEGIN
		-- The Item does not belong to either the EMailAlertLIst or InstantEmailAlertList!!!
		RETURN 0
	END
	-- Found it! It's in the InstantEmailAlertList
	SELECT @EmailListType = 2
END

-- Now get all the details depending on the type of item we're looking at!
IF (@itemtype = @ForumType)
BEGIN
	-- Get the Forum and all the threads that the user is subscribed to
	SELECT 'EMailListType' = @EmailListType, 'NotifyType' = @NotifyType, 'ItemType' = @itemtype, 'ItemID' = @itemid, 'MemberID' = @MemberID
	UNION ALL
	SELECT 'EMailListType' = 1, elm.NotifyType, elm.ItemType, elm.ItemID, elm.MemberID
		FROM dbo.EMailAlertListMembers elm
		INNER JOIN dbo.EMailAlertList el ON el.EMailAlertListID = elm.EMailAlertListID AND el.UserID = @userid
		INNER JOIN dbo.ThreadEntries t ON t.ForumID = @itemid
		WHERE elm.ItemID = t.ThreadID
	UNION ALL
	SELECT 'EMailListType' = 2, ielm.NotifyType, ielm.ItemType, ielm.ItemID, ielm.MemberID
		FROM dbo.EMailAlertListMembers ielm
		INNER JOIN dbo.InstantEMailAlertList iel ON iel.InstantEMailAlertListID = ielm.EMailAlertListID AND iel.UserID = @userid
		INNER JOIN dbo.ThreadEntries t ON t.ForumID = @itemid
		WHERE ielm.ItemID = t.ThreadID
END
ELSE IF (@itemtype = @ArticleType)
BEGIN
	-- Get the Article and the forum that the user is subscribed to
	SELECT 'EMailListType' = @EmailListType, 'NotifyType' = @NotifyType, 'ItemType' = @itemtype, 'ItemID' = @itemid, 'MemberID' = @MemberID
	UNION ALL
	SELECT 'EMailListType' = 1, elm.NotifyType, elm.ItemType, elm.ItemID, elm.MemberID
		FROM dbo.EMailAlertListMembers elm
		INNER JOIN dbo.EMailAlertList el ON el.EMailAlertListID = elm.EMailAlertListID AND el.UserID = @userid
		INNER JOIN dbo.GuideEntries g  ON g.h2g2ID = @itemid
		INNER JOIN dbo.Forums f ON f.ForumID = g.ForumID
		WHERE elm.ItemID = f.ForumID
	UNION ALL
	SELECT 'EMailListType' = 2, ielm.NotifyType, ielm.ItemType, ielm.ItemID, ielm.MemberID
		FROM dbo.EMailAlertListMembers ielm
		INNER JOIN dbo.InstantEMailAlertList iel ON iel.InstantEMailAlertListID = ielm.EMailAlertListID AND iel.UserID = @userid
		INNER JOIN dbo.GuideEntries g ON g.h2g2ID = @itemid
		INNER JOIN dbo.Forums f ON f.ForumID = g.ForumID
		WHERE ielm.ItemID = f.ForumID
END
ELSE IF (@itemtype = @ClubType)
BEGIN
	-- Get the club and the forum that the user is subscribed to.
	SELECT 'EMailListType' = @EmailListType, 'NotifyType' = @NotifyType, 'ItemType' = @itemtype, 'ItemID' = @itemid, 'MemberID' = @MemberID
	UNION ALL
	SELECT 'EMailListType' = 1, elm.NotifyType, elm.ItemType, elm.ItemID, elm.MemberID
		FROM dbo.EMailAlertListMembers elm
		INNER JOIN dbo.EMailAlertList el ON el.EMailAlertListID = elm.EMailAlertListID AND el.UserID = @userid
		INNER JOIN dbo.Clubs c ON c.ClubID = @itemid
		INNER JOIN dbo.GuideEntries g ON g.h2g2id = c.h2g2id
		WHERE elm.ItemID = g.h2g2id
	UNION ALL
	SELECT 'EMailListType' = 2, ielm.NotifyType, ielm.ItemType, ielm.ItemID, ielm.MemberID
		FROM dbo.EMailAlertListMembers ielm
		INNER JOIN dbo.InstantEMailAlertList iel ON iel.InstantEMailAlertListID = ielm.EMailAlertListID AND iel.UserID = @userid
		INNER JOIN dbo.Clubs c ON c.ClubID = @itemid
		INNER JOIN dbo.GuideEntries g ON g.h2g2id = c.h2g2id
		WHERE ielm.ItemID = g.h2g2id
	UNION ALL
	SELECT 'EMailListType' = 1, elm.NotifyType, elm.ItemType, elm.ItemID, elm.MemberID
		FROM dbo.EMailAlertListMembers elm
		INNER JOIN dbo.EMailAlertList el ON el.EMailAlertListID = elm.EMailAlertListID AND el.UserID = @userid
		INNER JOIN Clubs c ON c.ClubID = @itemid
		INNER JOIN Forums f ON f.ForumID = c.ClubForum
		WHERE elm.ItemID = f.ForumID
	UNION ALL
	SELECT 'EMailListType' = 2, ielm.NotifyType, ielm.ItemType, ielm.ItemID, ielm.MemberID
		FROM dbo.EMailAlertListMembers ielm
		INNER JOIN dbo.InstantEMailAlertList iel ON iel.InstantEMailAlertListID = ielm.EMailAlertListID AND iel.UserID = @userid
		INNER JOIN Clubs c ON c.ClubID = @itemid
		INNER JOIN Forums f ON f.ForumID = c.ClubForum
		WHERE ielm.ItemID = f.ForumID
END
ELSE
BEGIN
	-- Just return the Member details
	SELECT 'EMailListType' = @EmailListType, 'NotifyType' = @NotifyType, 'ItemType' = @itemtype, 'ItemID' = @itemid, 'MemberID' = @MemberID
END
