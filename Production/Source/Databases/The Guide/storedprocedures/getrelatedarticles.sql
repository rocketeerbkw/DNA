CREATE PROCEDURE getrelatedarticles @h2g2id int, @currentsiteid int = 0
AS

DECLARE @EntryID int
SET @EntryID = @h2g2id/10

-- All the articles in all the nodes this club is in
SELECT TOP 100 g.h2g2ID, g.Subject, g.ExtraInfo, g.type, g.status, g.editor, 
	g.DateCreated, g.LastUpdated, u.UserName editorName,
	U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
	P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle
	FROM GuideEntries g WITH(NOLOCK)
	LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor 
	LEFT JOIN Preferences p WITH(NOLOCK) on p.UserID = u.UserID AND p.SiteID = @currentsiteid
	LEFT JOIN dbo.Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
	WHERE g.EntryID IN
	(
		-- Use a subquery and "IN" clause to remove duplicate entryids
		SELECT ham.EntryID FROM HierarchyArticleMembers ham WITH(NOLOCK)
			INNER JOIN HierarchyArticleMembers ham2 WITH(NOLOCK) ON ham2.NodeID = ham.NodeID
			WHERE ham2.EntryID = @EntryID
	)
	ORDER BY g.LastUpdated
