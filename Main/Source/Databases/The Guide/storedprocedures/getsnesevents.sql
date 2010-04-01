CREATE PROCEDURE getsnesevents @batchsize int = 100
AS


set transaction isolation level read uncommitted;

SELECT TOP(@batchSize)
	SAQ.EventID,
	SAQ.EventType as ActivityType,
	uidm.IdentityUserId,
	u.LoginName as Username,
	u.Username as DisplayName,	
	samd.ApplicationId as AppId,
	samd.ApplicationName as AppName,
	TE.DatePosted as ActivityTime,
	cf.Url as BlogUrl,
	te.EntryID as PostID,
	s.urlname as DnaUrl,
	f.ForumID as ForumID,
	te.ThreadId as ThreadID,
	ObjectUri = case when cf.UID is null then '' else cf.UID end,
	ObjectTitle = f.Title,
	te.text as Body,
	fr.Rating as Rating,
	case when fr.Rating is not null then dbo.udf_GetSiteOptionSetting(S.SiteID, 'CommentForum', 'MaxForumRatingScore') end as MaxRating
FROM SNesActivityQueue SAQ
INNER JOIN Users U on U.UserID = SAQ.EventUserID
INNER JOIN SignInUserIDMapping uidm on uidm.DnaUserID = U.UserID
INNER JOIN ThreadEntries TE on TE.EntryID = SAQ.ItemID2
INNER JOIN Forums F on F.ForumID = TE.ForumID
INNER JOIN Sites S on S.SiteID = F.SiteID
INNER JOIN SNeSApplicationMetadata samd on samd.SiteID = S.SiteID
LEFT JOIN CommentForums CF on CF.ForumID = F.ForumID
LEFT JOIN ForumReview FR on FR.EntryId = TE.EntryId

