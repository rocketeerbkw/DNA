CREATE VIEW VComments
AS
SELECT     
	dbo.ThreadEntries.EntryID AS Id, 
	dbo.ThreadEntries.DatePosted AS Created, 
	dbo.ThreadEntries.UserID, 
	dbo.CommentForums.ForumID, 
	dbo.CommentForums.Url as parentUri,
	dbo.ThreadEntries.text, 
	dbo.ThreadEntries.Hidden, 
	dbo.ThreadEntries.PostStyle, 
	dbo.CommentForums.UID AS forumuid, 
	dbo.Users.Journal AS userJournal, 
	dbo.Users.UserName, 
	dbo.Users.Status AS userstatus, 
	CASE WHEN groups.UserID IS NULL THEN 0 ELSE 1 END AS userIsEditor, 
	dbo.ThreadEntries.lastupdated as lastupdated
FROM         dbo.ThreadEntries 
                      INNER JOIN dbo.CommentForums ON dbo.CommentForums.ForumID = dbo.ThreadEntries.ForumID 
                      INNER JOIN dbo.Users ON dbo.Users.UserID = dbo.ThreadEntries.UserID 
                      left outer join
							(SELECT     
								dbo.GroupMembers.UserID, 
								dbo.GroupMembers.siteid
							FROM          
							dbo.Groups AS Groups_1 inner JOIN
							dbo.GroupMembers ON dbo.GroupMembers.GroupID = Groups_1.GroupID
							WHERE  Groups_1.Name = 'EDITOR'					) 
							AS groups ON groups.UserID = dbo.Users.UserID and dbo.CommentForums.siteid= groups.siteid
                      