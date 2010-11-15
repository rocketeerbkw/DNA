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
		dbo.udf_isusermemberofgroup(dbo.ThreadEntries.UserID, dbo.CommentForums.siteid, 'EDITOR') AS userIsEditor, 
		dbo.udf_isusermemberofgroup(dbo.ThreadEntries.UserID, dbo.CommentForums.siteid, 'NOTABLES') AS userIsNotable, 
		dbo.ThreadEntries.lastupdated as lastupdated,
		dbo.SignInUserIDMapping.IdentityUserID,
		dbo.Users.LoginName As IdentityUserName,
		dbo.Preferences.sitesuffix as 'SiteSpecificDisplayName',
		case when threadentryeditorpicks.entryid is not null then 1 else 0 end as 'IsEditorPick',
		ThreadEntries.PostIndex
	FROM         dbo.ThreadEntries 
	INNER JOIN dbo.CommentForums ON dbo.CommentForums.ForumID = dbo.ThreadEntries.ForumID 
	INNER JOIN dbo.Users ON dbo.Users.UserID = dbo.ThreadEntries.UserID 
	INNER JOIN dbo.Preferences on dbo.Preferences.userid = dbo.Users.UserID and  dbo.Preferences.siteid = dbo.CommentForums.siteid
  	INNER JOIN dbo.SignInUserIDMapping ON dbo.Users.UserID = dbo.SignInUserIDMapping.DnaUserID 
  	left join threadentryeditorpicks  on ThreadEntries.entryid = threadentryeditorpicks.entryid
                    
                     