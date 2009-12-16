CREATE PROCEDURE fetchwatchedjournals @userid int
as
select fo.*,
	u.UserID,
	u.Cookie,
	u.email,
	u.UserName,
	u.Password,
	u.FirstNames,
	u.LastName,
	u.Active,
	--u.Masthead, - not required
	u.DateJoined,
	u.Status,
	u.Anonymous,
	'Journal' = J.ForumID,
	u.Latitude,
	u.Longitude,
	u.SinBin,
	u.DateReleased,
	u.Prefs1,
	u.Recommended,
	u.Friends,
	u.LoginName,
	u.BBCUID,
	u.TeamID,
	u.Postcode,
	u.Area,
	u.TaxonomyNode,
	u.UnreadPublicMessageCount,
	u.UnreadPrivateMessageCount,
	u.Region,
	u.HideLocation,
	u.HideUserName,	
	P.Title, P.SiteSuffix FROM FaveForums f WITH(NOLOCK)
	INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = f.ForumID
	INNER JOIN Users u WITH(NOLOCK) ON fo.JournalOwner = u.UserID
	LEFT JOIN Preferences P WITH(NOLOCK) ON (P.UserID = U.UserID) and (P.SiteID = fo.SiteID)
	INNER JOIN Journals J WITH(NOLOCK) ON J.UserID = U.UserID and J.SiteID = fo.SiteID
WHERE f.UserID = @userid
ORDER BY u.UserName