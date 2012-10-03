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
		ThreadEntries.PostIndex,
		dbo.ThreadEntries.username as 'AnonymousUserName',
		-- If retweet get the original tweet id, if not get the tweet id
		case
			when isnull(dbo.ThreadEntriesTweetInfo.OriginalTweetId, 0) = 0
			then isnull(dbo.ThreadEntriesTweetInfo.tweetid, 0) 
			else isnull(dbo.ThreadEntriesTweetInfo.OriginalTweetId, 0)
		end as 'TweetId',	
		
		case
			when dbo.ThreadEntries.PostStyle = 4 
			then
				case
					when ISNULL(dbo.ThreadEntriesTweetInfo.OriginalTweetId, 0) <> 0
					then (select u.loginname from dbo.ThreadEntriesTweetInfo tt
						inner join dbo.ThreadEntries te on tt.ThreadEntryId = te.EntryID
						inner join dbo.Users u on te.UserID = u.UserID
						where tt.TweetId = ThreadEntriesTweetInfo.TweetId)
					else dbo.users.loginname
				end
			else '' 
		end as 'TwitterScreenName'
		
		
		--case when dbo.ThreadEntries.PostStyle = 4 then dbo.users.loginname else '' end as 'TwitterScreenName' -- only return loginname for a tweet this is the @username
	FROM         dbo.ThreadEntries 
	INNER JOIN dbo.CommentForums ON dbo.CommentForums.ForumID = dbo.ThreadEntries.ForumID 
	INNER JOIN dbo.Users ON dbo.Users.UserID = dbo.ThreadEntries.UserID 
	INNER JOIN dbo.Preferences on dbo.Preferences.userid = dbo.Users.UserID and  dbo.Preferences.siteid = dbo.CommentForums.siteid
  	INNER JOIN dbo.SignInUserIDMapping ON dbo.Users.UserID = dbo.SignInUserIDMapping.DnaUserID 
  	left join threadentryeditorpicks  on ThreadEntries.entryid = threadentryeditorpicks.entryid
  	left join ThreadEntriesTweetInfo  on ThreadEntries.entryid = ThreadEntriesTweetInfo.threadentryid
                    
                     