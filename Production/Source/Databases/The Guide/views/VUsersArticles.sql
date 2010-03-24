CREATE VIEW VUsersArticles
AS
SELECT     dbo.GuideEntries.h2g2ID AS Id, dbo.GuideEntries.Subject AS Title, dbo.GuideEntries.text AS Summary, dbo.Forums.ForumPostCount AS PostsTotal, 
                      dbo.Forums.LastUpdated AS PostsMostRecent, dbo.GuideEntries.DateCreated AS Created, dbo.GuideEntries.LastUpdated AS Updated, 
                      dbo.Sites.SiteID AS HostId, '/dna/' + dbo.Sites.URLName + '/A' + CAST(dbo.GuideEntries.h2g2ID AS nvarchar) AS Uri, 
                      dbo.Sites.URLName AS HostUrlName, dbo.Sites.ShortName AS HostShortName, dbo.Sites.Description AS HostDescription, 
                      '/dna/' + dbo.Sites.URLName AS HostUri, dbo.GuideEntries.Editor AS UserId, 0 AS TotalResults
FROM         dbo.GuideEntries INNER JOIN
                      dbo.Forums ON dbo.GuideEntries.ForumID = dbo.Forums.ForumID INNER JOIN
                      dbo.Sites ON dbo.GuideEntries.SiteID = dbo.Sites.SiteID
WHERE     (dbo.GuideEntries.Hidden IS NULL) AND (dbo.GuideEntries.Status <> 7)
