CREATE VIEW VUsersComments
AS
SELECT     dbo.ThreadEntries.EntryID AS Id, dbo.ThreadEntries.Subject AS Title, CAST(dbo.ThreadEntries.text AS nvarchar(256)) AS Summary, 
                      '/dna/' + dbo.Sites.URLName + '/F' + CAST(dbo.Threads.ForumID AS nvarchar) + '?thread=' + CAST(dbo.Threads.ThreadID AS nvarchar) AS Uri, 
                      dbo.ThreadEntries.DatePosted AS Created, dbo.Sites.SiteID AS HostId, '/dna/' + dbo.Sites.URLName AS HostUri, dbo.Sites.URLName AS HostUrlName, 
                      dbo.Sites.URLName AS HostShortName, dbo.Sites.Description AS HostDescription, dbo.ThreadEntries.UserID, 0 AS TotalResults, 0 AS startindex, 
                      0 AS itemsperpage, dbo.CommentForums.ForumID, dbo.ThreadEntries.text, dbo.ThreadEntries.Hidden, dbo.ThreadEntries.PostStyle, 
                      dbo.CommentForums.UID AS forumuid, dbo.Users.Journal AS userJournal, dbo.Users.UserName, dbo.Users.Status AS userstatus, 
                      CASE WHEN groups.UserID IS NULL THEN 0 ELSE 1 END AS userIsEditor, dbo.ThreadEntries.lastupdated as lastupdated
FROM         dbo.Threads INNER JOIN
                      dbo.ThreadEntries ON dbo.Threads.ThreadID = dbo.ThreadEntries.ThreadID INNER JOIN
                      dbo.CommentForums ON dbo.CommentForums.ForumID = dbo.ThreadEntries.ForumID INNER JOIN
                      dbo.Sites ON dbo.CommentForums.SiteID = dbo.Sites.SiteID INNER JOIN
                      dbo.Users ON dbo.Users.UserID = dbo.ThreadEntries.UserID left outer join
					(SELECT     
						dbo.GroupMembers.UserID, 
						dbo.GroupMembers.siteid
                    FROM          
					dbo.Groups AS Groups_1 inner JOIN
					dbo.GroupMembers ON dbo.GroupMembers.GroupID = Groups_1.GroupID
					WHERE  Groups_1.Name = 'EDITOR'					) 
					AS groups ON groups.UserID = dbo.Users.UserID and dbo.Sites.siteid= groups.siteid
                   