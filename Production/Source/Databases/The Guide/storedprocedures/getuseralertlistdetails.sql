CREATE PROCEDURE getuseralertlistdetails @userid int, @siteid int, @listtype int
AS
-- Setup all the known types so we can be sanity checks for the item
DECLARE @NodeType int, @ArticleType int, @ClubType int, @ThreadType int, @ForumType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT

-- Now get all the details
SELECT Alerts.ItemType, Alerts.ItemID, Alerts.Title, Alerts.GroupID, Alerts.IsOwner, Alerts.ThreadType FROM
(
	-- Get all the Clubs that the user has subscribed to
	SELECT ag.ItemType, ag.ItemID, 'Title' = c.Name, ag.GroupID, 'IsOwner' = CASE WHEN tm.UserID IS NULL THEN 0 ELSE 1 END, 'ThreadType' = NULL
	FROM dbo.Clubs c WITH(NOLOCK)
	INNER JOIN dbo.AlertGroups ag WITH(NOLOCK) ON ag.ItemID = c.ClubID
	LEFT JOIN dbo.TeamMembers tm WITH(NOLOCK) ON tm.TeamID = c.OwnerTeam AND tm.UserID = @UserID
	WHERE ag.UserID = @UserID AND ag.SiteID = @SiteID AND ag.ItemType = @ClubType
	UNION ALL
	(
		-- Get all the Articles the user has subscribed to
		SELECT ag.ItemType, ag.ItemID, 'Title' = g.Subject, ag.GroupID, 'IsOwner' = CASE WHEN g.Editor = @UserID THEN 1 ELSE 0 END, 'ThreadType' = NULL
		FROM dbo.GuideEntries g WITH(NOLOCK)
		INNER JOIN dbo.AlertGroups ag WITH(NOLOCK) ON ag.ItemID = g.h2g2id
		WHERE ag.UserID = @UserID AND ag.SiteID = @SiteID AND ag.ItemType = @ArticleType
	)
	UNION ALL
	(
		-- Get all the Nodes that the user has subscribed to
		SELECT ag.ItemType, ag.ItemID, 'Title' = h.DisplayName, ag.GroupID, 'IsOwner' = 0, 'ThreadType' = NULL
		FROM dbo.Hierarchy h WITH(NOLOCK)
		INNER JOIN dbo.AlertGroups ag WITH(NOLOCK) ON ag.ItemID = h.NodeID
		WHERE ag.UserID = @UserID AND ag.SiteID = @SiteID AND ag.ItemType = @NodeType
	)
	UNION ALL
	(
		-- Get all the threads the user has subscribed to
		SELECT ag.ItemType, ag.ItemID, 'Title' = t.FirstSubject, ag.GroupID, 'IsOwner' = CASE WHEN te.UserID = @UserID THEN 1 ELSE 0 END, 'ThreadType' = t.Type
		FROM dbo.Threads t WITH(NOLOCK)
		INNER JOIN dbo.AlertGroups ag WITH(NOLOCK) ON ag.ItemID = t.ThreadID
		INNER JOIN dbo.ThreadEntries te WITH(NOLOCK) ON te.ThreadId = t.ThreadID AND te.PostIndex = 0
		WHERE ag.UserID = @UserID AND ag.SiteID = @SiteID AND ag.ItemType = @ThreadType
	)
	UNION ALL
	(
		-- now the forums
		SELECT ag.ItemType, ag.ItemID, 'Title' = f.title, ag.GroupID, 'IsOwner' = 0, 'ThreadType' = NULL
		FROM dbo.AlertGroups ag WITH(NOLOCK)
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = ag.ItemID
		WHERE ag.ItemType = @ForumType AND ag.SiteID = @SiteID AND ag.UserID = @UserID
	)	
) Alerts
ORDER BY Alerts.GroupID Desc




