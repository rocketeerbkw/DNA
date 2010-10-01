/*
TODO: TOP can't be given a variable value so need a hack to get round this, such
as building the entire query as a string. For the time being always return TOP 10
*/
CREATE Procedure getuserrecentandapprovedentrieswithguidetype @userid int, @siteid int = 0, @currentsiteid int=0,  @guidetype int = 0, @show int = 1000000  
As
IF @siteid = 0
BEGIN
SELECT TOP (@show )
   'h2g2ID' = g.h2g2ID,
   g.EntryID,
   'IsMainArticle' = 1,
   'Subject' = CASE
			WHEN g.Hidden IS NOT NULL THEN '' ELSE 
			CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END
			END,
   'Text' = CASE
			WHEN g.Hidden IS NOT NULL THEN '' ELSE 
			CASE g.Text WHEN '' THEN 'No Text' ELSE g.Text END
			END,
   'Status' = g.Status,
   g.ModerationStatus,
   'DateCreated' = g.DateCreated,
   g.LastUpdated,
   g.ForumID,
   g.SiteID,
   g.Editor,
   g.PreProcessed,
   g.Submittable,
   g.Style,
   g.Type,
   g.CanRead,
   g.CanWrite,
   g.CanChangePermissions,
   g.Hidden,
   u.UserID,
   u.UserName,
   u.Area,
   P.Title,
   P.SiteSuffix,
   u.FirstNames as UserFirstNames, u.LastName as UserLastName, u.Status as UserStatus, u.TaxonomyNode as UserTaxonomyNode, J.ForumID as UserJournal, u.Active as UserActive,
   Editor.Username as EditorName, Editor.FirstNames as EditorFirstNames, Editor.LastName as EditorLastName, Editor.Area as EditorArea, Editor.Status as EditorStatus, Editor.TaxonomyNode as EditorTaxonomyNode, J2.ForumID as EditorJournal, Editor.Active as EditorActive, EditorPreferences.SiteSuffix as EditorSiteSuffix, EditorPreferences.Title as EditorTitle,
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
WHERE	g.EntryID IN
(
	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.Editor = @userid 
			AND g.Status IN (1,3,5,6,11,12,13)
		) 
		OR (g.Editor = @userid AND g.Status = 4)

	UNION

	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.EntryiD IN (SELECT EntryID FROM Researchers WITH(NOLOCK) WHERE UserID = @userid )
			AND g.Status IN (1,3,5,6,11,12,13)
		)
)
AND g.type = @guidetype
ORDER BY DateCreated DESC
END
ELSE
BEGIN
SELECT TOP (@show )
	'h2g2ID' = g.h2g2ID,
	g.EntryID,
	'IsMainArticle' = 1,
    'Subject' = CASE
			WHEN g.Hidden IS NOT NULL THEN '' ELSE 
			CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END
			END,
    'Text' = CASE
			WHEN g.Hidden IS NOT NULL THEN '' ELSE 
			CASE g.Text WHEN '' THEN 'No Text' ELSE g.Text END
			END,
   'Status' = g.Status,
   g.ModerationStatus,
   'DateCreated' = g.DateCreated,
   g.LastUpdated,
   g.ForumID,
   g.SiteID,
   g.Editor,
   g.PreProcessed,
   g.Submittable,
   g.Style,
   g.Type,
   g.CanRead,
   g.CanWrite,
   g.CanChangePermissions,
   g.Hidden,
   u.UserID,
   u.UserName,
   u.Area,
   P.Title,
   P.SiteSuffix,
   u.FirstNames as UserFirstNames, u.LastName as UserLastName, u.Status as UserStatus, u.TaxonomyNode as UserTaxonomyNode, J.ForumID as UserJournal, u.Active as UserActive,
   Editor.Username as EditorName, Editor.FirstNames as EditorFirstNames, Editor.LastName as EditorLastName, Editor.Area as EditorArea, Editor.Status as EditorStatus, Editor.TaxonomyNode as EditorTaxonomyNode, J2.ForumID as EditorJournal, Editor.Active as EditorActive, EditorPreferences.SiteSuffix as EditorSiteSuffix, EditorPreferences.Title as EditorTitle,
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
WHERE	g.EntryID IN
(
	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.Editor = @userid 
			AND g.Status IN (1,3,5,6,11,12,13)
		) 
		OR (g.Editor = @userid AND g.Status = 4)

	UNION

	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.EntryiD IN (SELECT EntryID FROM Researchers WITH(NOLOCK) WHERE UserID = @userid )
			AND g.Status IN (1,3,5,6,11,12,13)
		)
)
AND g.siteid = @siteid AND g.type = @guidetype
ORDER BY DateCreated DESC
END
