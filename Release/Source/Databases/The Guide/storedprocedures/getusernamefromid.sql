CREATE PROCEDURE getusernamefromid @iuserid int, @siteid int
AS
SELECT u.UserID,
	   u.Cookie,
	   u.email,
	   u.UserName,
	   u.Password,
	   u.FirstNames,
	   u.LastName,
	   u.Active,
	   --u.Masthead,
	   'Masthead' = dbo.udf_generateh2g2id(m.EntryID),
	   u.DateJoined,
	   u.Status,
	   u.Anonymous,
	   --u.Journal,
	   'Journal' = j.ForumID,
	   u.Latitude,
	   u.Longitude,
	   u.SinBin,
	   u.DateReleased,
	   u.Prefs1,
	   u.Recommended,
	   u.Friends,
	   u.LoginName,
	   u.BBCUID,
	   ut.TeamID,
	   u.Postcode,
	   u.Area,
	   u.TaxonomyNode,
	   u.UnreadPublicMessageCount,
	   u.UnreadPrivateMessageCount,
	   u.Region,
	   u.HideLocation,
	   u.HideUserName,
	   P.Title,
	   P.SiteSuffix
FROM Users U 
INNER JOIN MastHeads m WITH(NOLOCK) ON U.UserID = m.UserID AND m.SiteID = @siteid
INNER JOIN Journals j WITH(NOLOCK) ON U.UserID = j.UserID and j.SiteID = @siteid
INNER JOIN UserTeams ut WITH(NOLOCK) ON ut.UserID = u.UserID AND ut.SiteID = @siteid
LEFT JOIN Preferences P ON (P.UserID = U.UserID) and (P.SiteID = @siteid)
WHERE U.UserID = @iuserid