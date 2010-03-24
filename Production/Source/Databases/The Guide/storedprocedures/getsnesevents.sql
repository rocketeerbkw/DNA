CREATE procedure getsnesevents @batchsize int = 100
as
SELECT TOP(@batchSize)
	SAQ.EventID,
	SAQ.EventType as ActivityType,
	--S.Description as Title,  -- a string of the form 'posted a <a href="">new article</a> on the <a href="">@ApplicationName</a>'
	Body = case cf.ForumId when null then te.Subject else f.Title end, -- more detail - don't include the actual user content - e.g. blog name, thread name etc
	uidm.IdentityUserId,
	u.LoginName as Username,
	u.Username as DisplayName,	
	samd.ApplicationId as AppId,		-- 'radio1'
	samd.ApplicationName as AppName,    -- 'Radio 1 Messageboard'
	TE.DatePosted as ActivityTime,
	cf.Url as BlogUrl,
	te.EntryID as PostID,
	s.urlname as DnaUrl,
	f.ForumID as ForumID,
	te.ThreadId as ThreadID,
	ObjectUri = case when cf.UID is null then '' else cf.UID end,
	ObjectTitle = f.Title,
	te.text as Body
FROM SNesActivityQueue SAQ
INNER JOIN Users U on U.UserID = SAQ.EventUserID
INNER JOIN SignInUserIDMapping uidm on uidm.DnaUserID = U.UserID
INNER JOIN ThreadEntries TE on TE.EntryID = SAQ.ItemID2
INNER JOIN Forums F on F.ForumID = TE.ForumID
INNER JOIN Sites S on S.SiteID = F.SiteID
INNER JOIN SNeSApplicationMetadata samd on samd.SiteID = S.SiteID
LEFT JOIN CommentForums CF on CF.ForumID = F.ForumID