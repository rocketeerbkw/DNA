CREATE PROCEDURE getauthorsfromh2g2id @h2g2id int
AS

SELECT DISTINCT u.UserName, u.UserID, u.Area, P.Title, u.FirstNames, u.LastName, p.SiteSuffix, 'GroupName' = gr.Name, u.TaxonomyNode, csu.score, u.Status, u.Active, 'journal' = j.forumid
FROM GuideEntries g WITH(NOLOCK) LEFT JOIN Researchers r WITH(NOLOCK) ON r.EntryID = g.EntryID
LEFT JOIN Users u WITH(NOLOCK) ON u.UserID = r.UserID OR u.UserID = g.Editor 
LEFT JOIN GroupMembers m WITH(NOLOCK) ON g.SiteID = m.SiteID AND u.UserID = m.UserID
LEFT JOIN Groups gr WITH(NOLOCK) ON m.GroupID = gr.GroupID
LEFT JOIN Preferences P WITH(NOLOCK) ON (P.UserID = u.UserID) and (P.SiteID = g.SiteID)
LEFT JOIN ContentSignifUser csu WITH(NOLOCK) ON (csu.UserID = u.UserID) and (csu.SiteID = g.SiteID)
LEFT JOIN dbo.Journals j WITH(NOLOCK) ON j.SiteID = g.siteid AND j.UserID = u.UserID
WHERE g.EntryID = @h2g2id/10