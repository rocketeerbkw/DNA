CREATE Procedure getuserrecentapprovedentrieswithguidetype @userid int, @siteid int = 0, @currentsiteid int=0, @guidetype int = 0, @skip int = 0, @show int = 100000
As
IF (@siteid = 0)
BEGIN
	WITH UsersArticlesSite0 AS
	(
		SELECT
		   'h2g2ID' = g.h2g2ID,
		   'Subject' = CASE
					WHEN g.Hidden IS NOT NULL THEN '' ELSE 
					CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END
					END,
		   'Status' = g.Status,
		   'DateCreated' = g.DateCreated,
		   g.LastUpdated,
		   g.SiteID,
		   g.Editor,
		   g.Type,
		   u.UserID,
		   u.UserName,
		   u.Area,
		   P.Title,
		   P.SiteSuffix,
		   u.FirstNames as UserFirstNames, 
		   u.LastName as UserLastName, 
		   u.Status as UserStatus, 
		   u.TaxonomyNode as UserTaxonomyNode, 
		   J.ForumID as UserJournal, 
		   u.Active as UserActive,
		   Editor.Username as EditorName, 
		   Editor.FirstNames as EditorFirstNames, 
		   Editor.LastName as EditorLastName, 
		   Editor.Area as EditorArea, 
		   Editor.Status as EditorStatus, 
		   Editor.TaxonomyNode as EditorTaxonomyNode, 
		   J2.ForumID as EditorJournal, 
		   Editor.Active as EditorActive, 
		   EditorPreferences.SiteSuffix as EditorSiteSuffix, 
		   EditorPreferences.Title as EditorTitle,
		   g.ExtraInfo,
		   f.ForumPostCount,
		   ar.StartDate,
		   ar.EndDate,
		   ar.TimeInterval
		FROM GuideEntries g WITH(NOLOCK)
		INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = g.ForumID
		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		left join Preferences P WITH(NOLOCK) on (u.UserID = P.UserID) AND (P.SiteID = g.siteid)
		inner join Users Editor on Editor.UserID = g.Editor
		left join Preferences EditorPreferences on EditorPreferences.UserID = Editor.UserID AND EditorPreferences.SiteID = @currentsiteid
		INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
		INNER JOIN Journals J2 WITH(NOLOCK) on J2.UserID = Editor.UserID and J2.SiteID = @currentsiteid
		LEFT JOIN ArticleDateRange AR WITH(NOLOCK) on G.EntryID = AR.EntryID
		WHERE ((g.EntryID IN (SELECT EntryID FROM Researchers WITH(NOLOCK) WHERE UserID = @userid
								UNION
								SELECT EntryID FROM GuideEntries WITH(NOLOCK) WHERE Editor = @userid)))
			AND g.Status = 1 AND g.type = @guidetype
	)
	,
	UserArticlesPaginationSite0 AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY DateCreated DESC) AS 'n', ua0.*
		FROM UsersArticlesSite0 ua0
	)
	SELECT  'Total' = (select count(*) FROM UsersArticlesSite0), 
		uap0.*
		FROM UserArticlesPaginationSite0 uap0
		WHERE uap0.n > @skip AND uap0.n <= @skip + @show
		ORDER BY n
END
ELSE
BEGIN
	WITH UsersArticlesSiteX AS
	(
		SELECT
		   'h2g2ID' = g.h2g2ID,
		   'Subject' = CASE
					WHEN g.Hidden IS NOT NULL THEN '' ELSE 
					CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END
					END,
		   'Status' = g.Status,
		   'DateCreated' = g.DateCreated,
		   g.LastUpdated,
		   g.SiteID,
		   g.Editor,
		   g.Type,
		   u.UserID,
		   u.UserName,
		   u.Area,
		   P.Title,
		   P.SiteSuffix,
		   u.FirstNames as UserFirstNames, 
		   u.LastName as UserLastName, 
		   u.Status as UserStatus, 
		   u.TaxonomyNode as UserTaxonomyNode, 
		   J.ForumID as UserJournal, 
		   u.Active as UserActive,
		   Editor.Username as EditorName, 
		   Editor.FirstNames as EditorFirstNames, 
		   Editor.LastName as EditorLastName, 
		   Editor.Area as EditorArea, 
		   Editor.Status as EditorStatus, 
		   Editor.TaxonomyNode as EditorTaxonomyNode, 
		   J2.ForumID as EditorJournal, 
		   Editor.Active as EditorActive, 
		   EditorPreferences.SiteSuffix as EditorSiteSuffix, 
		   EditorPreferences.Title as EditorTitle,
		   g.ExtraInfo,
		   f.ForumPostCount,
		   ar.StartDate,
		   ar.EndDate,
		   ar.TimeInterval
		FROM GuideEntries g WITH(NOLOCK)
		INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = g.ForumID
		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		left join Preferences P WITH(NOLOCK) on (u.UserID = P.UserID) AND (P.SiteID = g.siteid)
		inner join Users Editor on Editor.UserID = g.Editor
		left join Preferences EditorPreferences on EditorPreferences.UserID = Editor.UserID AND EditorPreferences.SiteID = @currentsiteid
		INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
		INNER JOIN Journals J2 WITH(NOLOCK) on J2.UserID = Editor.UserID and J2.SiteID = @currentsiteid
		LEFT JOIN ArticleDateRange AR WITH(NOLOCK) on G.EntryID = AR.EntryID
		WHERE  (g.EntryID IN 
					(
					 SELECT EntryID FROM Researchers  WITH(NOLOCK) WHERE UserID = @userid
					 UNION
					 SELECT EntryID FROM GuideEntries WITH(NOLOCK) WHERE Editor = @userid
					)
			   ) AND g.Status = 1 AND g.type = @guidetype
	)
	,
	UserArticlesPaginationSiteX AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY DateCreated DESC) AS 'n', uaX.*
		FROM UsersArticlesSiteX uaX
	)
	SELECT  'Total' = (select count(*) FROM UsersArticlesSiteX), 
		uapX.*
		FROM UserArticlesPaginationSiteX uapX
		WHERE uapX.n > @skip AND uapX.n <= @skip + @show
		ORDER BY n
END
