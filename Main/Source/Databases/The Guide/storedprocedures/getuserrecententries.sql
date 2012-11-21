/*
TODO: TOP can't be given a variable value so need a hack to get round this, such
as building the entire query as a string. For the time being always return TOP 10
*/
CREATE Procedure getuserrecententries @userid int, @siteid int = 0, @currentsiteid int=0
As

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

if @currentsiteid = 67
begin
	return 0
end

IF @siteid = 0
BEGIN
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
   u.FirstNames,
   u.LastName,
   u.Area,
   P.Title,
   P.SiteSuffix,
   u.Status as UserStatus, u.TaxonomyNode as UserTaxonomyNode, J.ForumID as UserJournal, u.Active as UserActive,
   Editor.Username as EditorName, Editor.FirstNames as EditorFirstNames, Editor.LastName as EditorLastName, Editor.Area as EditorArea, Editor.Status as EditorStatus, Editor.TaxonomyNode as EditorTaxonomyNode, J2.ForumID as EditorJournal, Editor.Active as EditorActive, EditorPreferences.SiteSuffix as EditorSiteSuffix, EditorPreferences.Title as EditorTitle,
    g.ExtraInfo,
   f.ForumPostCount,
   ar.startdate,
   ar.enddate,
   ar.timeinterval
FROM GuideEntries g WITH(NOLOCK)
INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = g.ForumID
INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
left join Preferences P WITH(NOLOCK) on (u.UserID = P.UserID) AND (P.SiteID = g.siteid)
inner join Users Editor WITH(NOLOCK) on Editor.UserID = g.Editor
left join Preferences EditorPreferences WITH(NOLOCK) on EditorPreferences.UserID = Editor.UserID AND EditorPreferences.SiteID = @currentsiteid
INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
INNER JOIN Journals J2 WITH(NOLOCK) on J2.UserID = Editor.UserID and J2.SiteID = @currentsiteid
LEFT JOIN ArticleDateRange AR WITH(NOLOCK) on G.EntryID = AR.EntryID
WHERE	g.EntryID IN
(
	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.Editor = @userid 
			AND g.Status IN (3,5,6,11,12,13)
		) 
		OR (g.Editor = @userid AND g.Status = 4)

	UNION

	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.EntryiD IN (SELECT EntryID FROM Researchers WITH(NOLOCK) WHERE UserID = @userid )
			AND g.Status IN (3,5,6,11,12,13)
		)
)
ORDER BY DateCreated DESC
END
ELSE
BEGIN
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
   u.FirstNames,
   u.LastName,
   u.Area,
   P.Title,
   P.SiteSuffix,
   u.Status as UserStatus, u.TaxonomyNode as UserTaxonomyNode, J.ForumID as UserJournal, u.Active as UserActive,
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
inner join Users Editor WITH(NOLOCK) on Editor.UserID = g.Editor
left join Preferences EditorPreferences WITH(NOLOCK) on EditorPreferences.UserID = Editor.UserID AND EditorPreferences.SiteID = @currentsiteid
INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
INNER JOIN Journals J2 WITH(NOLOCK) on J2.UserID = Editor.UserID and J2.SiteID = @currentsiteid
LEFT JOIN ArticleDateRange AR WITH(NOLOCK) on G.EntryID = AR.EntryID
WHERE	g.EntryID IN
(
	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.Editor = @userid 
			AND g.Status IN (3,5,6,11,12,13)
		) 
		OR (g.Editor = @userid AND g.Status = 4)

	UNION

	Select g.EntryID From guideEntries g WITH(NOLOCK) where 
		(
			g.EntryiD IN (SELECT EntryID FROM Researchers WITH(NOLOCK) WHERE UserID = @userid )
			AND g.Status IN (3,5,6,11,12,13)
		)
)
AND g.siteid = @siteid
ORDER BY DateCreated DESC
OPTION(OPTIMIZE FOR (@userid=0))
END
