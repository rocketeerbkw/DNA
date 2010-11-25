CREATE PROCEDURE watchingusers @userid int, @siteid int, @skip int = 0, @show int = 100000
as

WITH WatchingUsers AS
(
	select 
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
		P.Title, P.SiteSuffix, fo.ForumID, fo.SiteID 
		FROM Users u1
		INNER JOIN Journals J1 ON J1.UserID = u1.UserID and J1.SiteID = @siteid
		INNER JOIN FaveForums f ON f.ForumID = J1.ForumID
		INNER JOIN Users u ON f.UserID = u.UserID
		INNER JOIN Journals J on J.UserID = u.UserID and J.SiteID = @siteid	
		INNER JOIN Forums fo ON fo.ForumID = J.ForumID
		LEFT JOIN Preferences P ON (P.UserID = u1.UserID) and (P.SiteID = fo.SiteID)
	WHERE u1.UserID = @userid
),
WatchingUsersPagination AS
(
	SELECT ROW_NUMBER() OVER(ORDER BY wu.UserName) AS 'n', wu.*
	FROM WatchingUsers wu
)
SELECT  'Total' = (select count(*) FROM WatchingUsers), 
	wup.*
	FROM WatchingUsersPagination wup
	WHERE wup.n > @skip AND wup.n <= @skip + @show
	ORDER BY n
