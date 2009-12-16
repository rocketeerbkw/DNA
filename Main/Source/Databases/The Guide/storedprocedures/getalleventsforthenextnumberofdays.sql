Create Procedure getalleventsforthenextnumberofdays @forumid int, @days int = 356 -- Default to 1 year!
As
DECLARE @threadcount int
SELECT @threadcount = COUNT(*) FROM ThreadEntries WHERE ForumID = @forumid AND Hidden IS NULL AND PostIndex = 0
IF (@threadcount > 0)
BEGIN
	SELECT	Subject, 
			DatePosted, 
			EntryID, 
			t.ThreadID, 
			t.UserID,
			u.UserName,
			u.FirstNames,
			u.LastName,
			u.TaxonomyNode,
			u.Postcode,
			u.Area,
			u.Status,
			u.Active,
			'Journal' = J.ForumID,
			p.Title,
			p.SiteSuffix,
			h.DisplayName,
			t.Hidden,
			'ThreadCount' = @threadcount,
			t.PostStyle,
			t.text,
			d.Type,
			d.EventDate
		FROM ThreadEntries t
		INNER JOIN Threads d ON t.ThreadID = d.ThreadID
		INNER JOIN  Users u ON u.UserID = t.UserID
		LEFT JOIN  Hierarchy h ON u.TaxonomyNode = h.NodeID
		INNER JOIN Forums F ON F.ForumID = t.ForumID
		LEFT JOIN Preferences P ON (P.UserID = U.UserID) and (P.SiteID = F.SiteID)
		INNER JOIN Journals J ON J.UserID = U.UserID and J.SiteID = F.SiteID
		WHERE	t.ForumID = @forumid
				AND t.PostIndex = 0
				AND t.Hidden IS NULL AND
				(d.Type = 'Event' OR d.Type = 'Alert') AND
				(d.EventDate < (GetDate() + @days)) AND
				(d.EventDate > GetDate())
		ORDER BY d.EventDate ASC
END