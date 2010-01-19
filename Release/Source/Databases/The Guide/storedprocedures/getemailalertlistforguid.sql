CREATE PROCEDURE getemailalertlistforguid @emailalertlistid uniqueidentifier, @emaillisttype int
AS
DECLARE @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int, @PostType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT
EXEC SetItemTypeValInternal 'IT_POST', @PostType OUTPUT

IF (@emaillisttype = 1)
BEGIN
	SELECT	'ItemListLastUpdated' = el.LastUpdated, elm.*,
			'ItemDescription' = CASE WHEN elm.ItemType = @NodeType THEN h.DisplayName
									WHEN elm.ItemType = @ArticleType THEN g.Subject
									WHEN elm.ItemType = @ClubType THEN c.Name
									WHEN elm.ItemType = @ForumType THEN f.Title
									WHEN elm.ItemType = @ThreadType THEN t.FirstSubject
									WHEN elm.ItemType = @PostType THEN t2.Subject
									ELSE 'No Description!'
									END,
			'ItemExtraInfo' = CASE WHEN elm.ItemType IN (@ThreadType,@PostType) THEN f2.ForumID ELSE 0 END
			FROM dbo.EmailAlertListMembers elm 
			INNER JOIN dbo.EMailAlertList el	ON el.EMailAlertListID = @emailalertlistid
			LEFT JOIN dbo.Hierarchy h			ON h.NodeID = elm.ItemID AND elm.ItemType = @NodeType
			LEFT JOIN dbo.GuideEntries g		ON g.h2g2ID = elm.ItemID AND elm.ItemType = @ArticleType
			LEFT JOIN dbo.Clubs c				ON c.ClubID = elm.itemID AND elm.ItemType = @ClubType
			LEFT JOIN dbo.Forums f				ON f.forumID = elm.itemID AND elm.ItemType = @ForumType
			LEFT JOIN dbo.Threads t				ON t.ThreadID = elm.itemID AND elm.ItemType = @ThreadType
			LEFT JOIN dbo.ThreadEntries t2		ON t2.EntryID = elm.itemID AND elm.ItemType = @PostType
			LEFT JOIN dbo.Forums f2				ON f2.forumID = t.ForumID OR f2.forumID = t2.ForumID
			WHERE elm.EMailAlertListID = @emailalertlistid AND elm.AlertGroupID = 0
END
ELSE
BEGIN
	SELECT	'ItemListLastUpdated' = iel.LastUpdated, ielm.*,
			'ItemDescription' = CASE WHEN ielm.ItemType = @NodeType THEN h.DisplayName
									WHEN ielm.ItemType = @ArticleType THEN g.Subject
									WHEN ielm.ItemType = @ClubType THEN c.Name
									WHEN ielm.ItemType = @ForumType THEN f.Title
									WHEN ielm.ItemType = @ThreadType THEN t.FirstSubject
									WHEN ielm.ItemType = @PostType THEN t2.Subject
									ElSE 'No Description!'
									END,
			'ItemExtraInfo' = CASE WHEN ielm.ItemType IN (@ThreadType,@PostType) THEN f2.ForumID ELSE 0 END
			FROM dbo.EmailAlertListMembers ielm 
			INNER JOIN dbo.InstantEMailAlertList iel	ON iel.InstantEMailAlertListID = @emailalertlistid
			LEFT JOIN dbo.Hierarchy h			ON h.NodeID = ielm.ItemID AND ielm.ItemType = @NodeType
			LEFT JOIN dbo.GuideEntries g		ON g.h2g2ID = ielm.ItemID AND ielm.ItemType = @ArticleType
			LEFT JOIN dbo.Clubs c				ON c.ClubID = ielm.itemID AND ielm.ItemType = @ClubType
			LEFT JOIN dbo.Forums f				ON f.forumID = ielm.itemID AND ielm.ItemType = @ForumType
			LEFT JOIN dbo.Threads t				ON t.ThreadID = ielm.itemID AND ielm.ItemType = @ThreadType
			LEFT JOIN dbo.ThreadEntries t2		ON t2.EntryID = ielm.itemID AND ielm.ItemType = @PostType
			LEFT JOIN dbo.Forums f2				ON f2.forumID = t.ForumID OR f2.forumID = t2.ForumID
			WHERE ielm.EMailAlertListID = @emailalertlistid AND ielm.AlertGroupID = 0
END
