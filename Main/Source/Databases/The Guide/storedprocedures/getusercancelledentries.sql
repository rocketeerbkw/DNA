CREATE Procedure getusercancelledentries @userid int, @siteid int = 0, @currentsiteid int=0
As
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
   u.UserID,
   u.UserName,
   u.Area,
   P.Title,
   P.SiteSuffix,
   u.FirstNames as UserFirstNames, u.LastName as UserLastName, u.Status as UserStatus, u.TaxonomyNode as UserTaxonomyNode, J.ForumID as UserJournal, u.Active as UserActive,
   Editor.Username as EditorName, Editor.FirstNames as EditorFirstNames, Editor.LastName as EditorLastName, Editor.Area as EditorArea, Editor.Status as EditorStatus, Editor.TaxonomyNode as EditorTaxonomyNode, Editor.Journal as EditorJournal, Editor.Active as EditorActive, EditorPreferences.SiteSuffix as EditorSiteSuffix, EditorPreferences.Title as EditorTitle,
   g.ExtraInfo,
   f.ForumPostCount
FROM GuideEntries g
INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = g.ForumID
INNER JOIN Researchers r ON r.EntryID = g.EntryID
INNER JOIN Users u ON u.UserID = @userid
left join Preferences P WITH(NOLOCK) on (u.UserID = P.UserID) AND (P.SiteID = g.siteid)
inner join Users Editor on Editor.UserID = g.Editor
left join Preferences EditorPreferences on EditorPreferences.UserID = Editor.UserID AND EditorPreferences.SiteID = @currentsiteid
INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
WHERE Editor = @userid
	AND g.Status = 7
	AND (g.SiteID = @siteid OR @siteid = 0)
ORDER BY DateCreated DESC
