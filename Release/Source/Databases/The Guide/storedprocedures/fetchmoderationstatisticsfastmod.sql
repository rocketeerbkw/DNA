CREATE PROCEDURE fetchmoderationstatisticsfastmod @userid int
AS

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @refereegroupid int
SELECT @refereegroupid = groupid from Groups where name='Referee'

declare @issuperuser int
select @issuperuser = CASE WHEN Status = 2 then 1 ELSE 0 END FROM Users where UserID = @userid

--forum-queued
(SELECT 'forum-queued' type, count(*) total 
	FROM ThreadMod tm
		INNER JOIN GroupMembers m ON m.UserID = @userid AND tm.SiteID = m.SiteID AND m.GroupID = @modgroupid
		left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE tm.Status = 0 AND tm.NewPost = 1 AND tm.ComplainantID IS NULL
	AND fmf.ForumID is not null
	)
UNION ALL
--forum-locked
(SELECT 'forum-locked',count(*) FROM ThreadMod tm
	left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE tm.status = 1 AND tm.NewPost = 1 
	AND tm.LockedBy = @userid AND tm.ComplainantID IS NULL 
	AND fmf.ForumID is not null
	)
UNION ALL
--forum-complaints-queued
(SELECT 'forum-complaints-queued',count(*) FROM ThreadMod tm
	INNER JOIN GroupMembers m ON m.UserID = @userid 
	AND tm.SiteID = m.SiteID AND m.GroupID = @modgroupid
	left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE  tm.Status = 0 
	AND tm.ComplainantID IS NOT NULL AND tm.LockedBy IS NULL 
	AND fmf.ForumID is not null
	)
UNION ALL
--forum-complaints-locked
(SELECT 'forum-complaints-locked',count(*) FROM ThreadMod tm
	left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE tm.Status = 1 AND tm.ComplainantID IS NOT NULL 
	AND tm.LockedBy = @userid 
	AND fmf.ForumID is not null
	)
UNION ALL
--forum-referrals-queued
(SELECT 'forum-referrals-queued',count(*) FROM ThreadMod tm
	INNER JOIN GroupMembers m ON m.UserID = @userid AND tm.SiteID = m.SiteID 
	AND m.GroupID = @refereegroupid
	left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.NewPost = 1 
	AND tm.LockedBy IS NULL AND tm.ComplainantID IS NULL 
	AND fmf.ForumID is not null
	)
UNION ALL
--forum-referrals-locked
(SELECT 'forum-referrals-locked',count(*) FROM ThreadMod tm
left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.NewPost = 1 AND tm.LockedBy = @userid 
	AND tm.ComplainantID IS NULL 
	AND fmf.ForumID is not null
	)
UNION ALL
--forum-complaints-referrals-queued
(SELECT 'forum-complaints-referrals-queued',count(*) FROM ThreadMod tm
	INNER JOIN GroupMembers m ON m.UserID = @userid AND tm.SiteID = m.SiteID 
	AND m.GroupID = @refereegroupid
	left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.ComplainantID IS NOT NULL 
	AND tm.LockedBy IS NULL 
	AND fmf.ForumID is not null
	)
UNION ALL
--forum-complaints-referrals-locked
(SELECT 'forum-complaints-referrals-locked',count(*) FROM ThreadMod tm
	left join FastModForums fmf ON fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.ComplainantID IS NOT NULL 
	AND tm.LockedBy = @userid
	AND fmf.ForumID is not null
	)

