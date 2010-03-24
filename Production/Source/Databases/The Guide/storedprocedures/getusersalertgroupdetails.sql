CREATE PROCEDURE getusersalertgroupdetails @userid int, @siteid int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT

SELECT alerts.GroupID, alerts.ItemID, alerts.ItemType, alerts.Name, alerts.IsOwner, em.NotifyType,
'AlertType' = CASE WHEN el.EmailAlertListID IS NULL THEN 2 ELSE 1 END
FROM
(
	-- Get the clubs
	SELECT al.GroupID, al.ItemID, al.ItemType, c.Name, al.IsOwner
	FROM dbo.AlertGroups al
	INNER JOIN dbo.Clubs c ON c.ClubID = al.ItemID
	WHERE al.ItemType = @ClubType AND al.SiteID = @SiteID AND al.UserID = @UserID
	UNION ALL
	(
		-- now the nodes
		SELECT al.GroupID, al.ItemID, al.ItemType, h.DisplayName, al.IsOwner
		FROM dbo.AlertGroups al
		INNER JOIN dbo.Hierarchy h ON h.NodeID = al.ItemID
		WHERE al.ItemType = @NodeType AND al.SiteID = @SiteID AND al.UserID = @UserID
	)
	UNION ALL
	(
		-- now the articles
		SELECT al.GroupID, al.ItemID, al.ItemType, g.Subject, al.IsOwner
		FROM dbo.AlertGroups al
		INNER JOIN dbo.GuideEntries g ON g.h2g2ID = al.ItemID
		WHERE al.ItemType = @ArticleType AND al.SiteID = @SiteID AND al.UserID = @UserID
	)
	UNION ALL
	(
		-- now the threads
		SELECT al.GroupID, al.ItemID, al.ItemType, t.FirstSubject, al.IsOwner
		FROM dbo.AlertGroups al
		INNER JOIN dbo.Threads t ON t.ThreadID = al.ItemID
		WHERE al.ItemType = @ThreadType AND al.SiteID = @SiteID AND al.UserID = @UserID
	)
	UNION ALL
	(
		-- now the forums
		SELECT al.GroupID, al.ItemID, al.ItemType, f.Title, al.IsOwner
		FROM dbo.AlertGroups al
		INNER JOIN dbo.Forums f ON f.ForumID = al.ItemID
		WHERE al.ItemType = @ForumType AND al.SiteID = @SiteID AND al.UserID = @UserID
	)
) alerts
INNER JOIN dbo.EMailAlertListMembers em ON em.ItemID = alerts.ItemID AND em.ItemType = alerts.ItemType AND em.AlertGroupID = alerts.GroupID
LEFT JOIN dbo.EmailAlertList el ON el.EmailAlertListID = em.EmailAlertListID
ORDER BY alerts.IsOwner, alerts.GroupID DESC