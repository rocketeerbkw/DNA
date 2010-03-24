Create Procedure forumgetnoticeinfo @forumid int, @threadid int
As
SELECT	Subject, 
	DatePosted, 
	EntryID,
	t.forumid,
	t.ThreadID, 
	t.UserID,
	u.UserName,
	u.FirstNames,
	u.LastName,
	u.TaxonomyNode,
	u.Area,
	p.Title,
	p.SiteSuffix,
	h.DisplayName,
	t.Hidden,
	t.PostStyle,
	t.text,
	d.Type,
	d.EventDate,
	d.ThreadPostCount,
	u.Status,
	'Journal' = J.ForumID,
	u.Active
FROM ThreadEntries t
INNER JOIN Threads d ON t.ThreadID = d.ThreadID
INNER JOIN Users u ON u.UserID = t.UserID
LEFT JOIN Hierarchy h ON u.TaxonomyNode = h.NodeID
INNER JOIN Forums f ON f.ForumID = t.ForumID
LEFT JOIN Preferences P ON (P.SiteID = f.SiteID) and (P.UserID = u.UserID) 
INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = f.SiteID
WHERE t.ForumID = @forumid AND d.ThreadID = @threadid AND t.PostIndex = 0 AND t.Hidden IS NULL
ORDER BY t.DatePosted DESC
