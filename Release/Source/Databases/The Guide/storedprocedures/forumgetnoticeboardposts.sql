/*
	inputs: @forumid = ID of journal forum
*/
Create Procedure forumgetnoticeboardposts @forumid int
As
DECLARE @threadcount int
SELECT top 200 @threadcount = COUNT(*) FROM ThreadEntries WHERE ForumID = @forumid AND Hidden IS NULL AND PostIndex = 0
IF (@threadcount > 0)
BEGIN
	SELECT	Subject, 
			DatePosted, 
			EntryID, 
			t.ThreadID,
			t.ForumID,
			t.UserID,
			u.UserName,
			u.TaxonomyNode,
			h.DisplayName,
			t.Hidden,
			'ThreadCount' = @threadcount,
			t.PostStyle,
			t.text,
			d.Type,
			d.EventDate,
			u.Area,
			p.Title,
			u.FirstNames,
			u.LastName,
			u.Status,
			'Journal'  = J.ForumID,
			u.Active,
			p.SiteSuffix,
			d.ThreadPostCount
		FROM ThreadEntries t
		INNER JOIN Threads d ON t.ThreadID = d.ThreadID
		INNER JOIN Users u ON u.UserID = t.UserID
		INNER JOIN Forums f on t.ForumID = f.ForumID
		LEFT JOIN Hierarchy h ON u.TaxonomyNode = h.NodeID
		LEFT JOIN Preferences p ON (p.UserID = u.UserID) and (p.SiteID = f.SiteID) 
		INNER JOIN Journals J ON J.UserID = u.UserID and J.SiteID = f.SiteID
		WHERE	t.ForumID = @forumid
				AND t.PostIndex = 0
				AND t.Hidden IS NULL
		ORDER BY t.DatePosted DESC
END
