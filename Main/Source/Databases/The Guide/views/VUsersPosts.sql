CREATE VIEW VUsersPosts
AS
SELECT     TOP (100) PERCENT dbo.ThreadEntries.EntryID AS Id, dbo.ThreadEntries.Subject AS Title, CAST(dbo.ThreadEntries.text AS nvarchar(256)) AS Summary, 
                      '/dna/' + dbo.Sites.URLName + '/F' + CAST(dbo.Threads.ForumID AS nvarchar) + '?thread=' + CAST(dbo.Threads.ThreadID AS nvarchar) AS Uri, 
                      dbo.ThreadEntries.DatePosted AS Created, dbo.Sites.SiteID AS HostId, '/dna/' + dbo.Sites.URLName AS HostUri, dbo.Sites.URLName AS HostUrlName, 
                      dbo.Sites.ShortName AS HostShortName, dbo.Sites.Description AS HostDescription, dbo.ThreadEntries.UserID, 0 AS TotalResults
FROM         dbo.Threads INNER JOIN
                      dbo.ThreadEntries ON dbo.Threads.ThreadID = dbo.ThreadEntries.ThreadID INNER JOIN
                      dbo.Sites ON dbo.Sites.SiteID = dbo.Threads.SiteID
WHERE     (dbo.ThreadEntries.Hidden IS NULL) AND (dbo.Threads.ForumID NOT IN
                          (SELECT     ForumID
                            FROM          dbo.CommentForums))
ORDER BY Created DESC
