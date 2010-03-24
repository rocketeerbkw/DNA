CREATE PROCEDURE fetchmoderationstatisticsold @userid int
AS

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @refereegroupid int
SELECT @refereegroupid = groupid from Groups where name='Referee'

declare @assetmodgroupid int
select @assetmodgroupid = groupid from Groups WITH(NOLOCK) where name = 'AssetModerator'

declare @issuperuser int
select @issuperuser = CASE WHEN Status = 2 then 1 ELSE 0 END FROM Users where UserID = @userid

--forum-queued
(SELECT 'forum-queued' type, count(*) total FROM ThreadMod tm
	INNER JOIN GroupMembers m ON m.UserID = @userid AND tm.SiteID = m.SiteID 
	AND m.GroupID = @modgroupid
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 0 AND tm.NewPost = 1 AND tm.ComplainantID IS NULL
	and fmf.ForumID is NULL
	)
UNION ALL
--forum-locked
(SELECT 'forum-locked',count(*) FROM ThreadMod tm
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE tm.status = 1 AND tm.NewPost = 1 	
	AND tm.LockedBy = @userid AND tm.ComplainantID IS NULL 
	and fmf.ForumID is NULL
	)
UNION ALL
--forum-complaints-queued
(SELECT 'forum-complaints-queued',count(*) FROM ThreadMod tm
	INNER JOIN GroupMembers m ON m.UserID = @userid 
	AND tm.SiteID = m.SiteID AND m.GroupID = @modgroupid
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE  tm.Status = 0 
	AND tm.ComplainantID IS NOT NULL AND tm.LockedBy IS NULL
	and fmf.ForumID is NULL
	)
UNION ALL
--forum-complaints-locked
(SELECT 'forum-complaints-locked',count(*) FROM ThreadMod tm
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 1 AND tm.ComplainantID IS NOT NULL 
	AND tm.LockedBy = @userid
	and fmf.ForumID is NULL
	)
UNION ALL
--forum-referrals-queued
(SELECT 'forum-referrals-queued',count(*) FROM ThreadMod tm
	INNER JOIN GroupMembers m ON m.UserID = @userid AND tm.SiteID = m.SiteID 
	AND m.GroupID = @refereegroupid
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.NewPost = 1 
	AND tm.LockedBy IS NULL AND tm.ComplainantID IS NULL 
	and fmf.ForumID is NULL
	)
UNION ALL
--forum-referrals-locked
(SELECT 'forum-referrals-locked',count(*) FROM ThreadMod tm
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.NewPost = 1 AND tm.LockedBy = @userid 
	AND tm.ComplainantID IS NULL
	and fmf.ForumID is NULL
	)
UNION ALL
--forum-complaints-referrals-queued
(SELECT 'forum-complaints-referrals-queued',count(*) FROM ThreadMod tm
	INNER JOIN GroupMembers m ON m.UserID = @userid AND tm.SiteID = m.SiteID 
	AND m.GroupID = @refereegroupid
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.ComplainantID IS NOT NULL 
	AND tm.LockedBy IS NULL
	and fmf.ForumID is NULL
	)
UNION ALL
--forum-complaints-referrals-locked
(SELECT 'forum-complaints-referrals-locked',count(*) FROM ThreadMod tm
	LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.ComplainantID IS NOT NULL 
	AND tm.LockedBy = @userid
	and fmf.ForumID is NULL
	)
UNION ALL
--entries-queued
(	
	SELECT 'entries-queued', sum (eq.total)
	FROM
	(
		(
			SELECT 'entries-queued' type, count(*) total 
			FROM ArticleMod a
			INNER JOIN GroupMembers m ON m.UserID = @userid AND a.SiteID = m.SiteID AND m.GroupID = @modgroupid 
			INNER JOIN GuideEntries ge on ge.h2g2id = a.h2g2id
			LEFT JOIN ArticleMediaAsset ama on ama.entryid = ge.entryid
			WHERE a.Status = 0 AND a.NewArticle = 1 AND a.ComplainantID IS NULL AND ama.EntryID IS NULL
		)
		UNION ALL
		(
			SELECT 'entries-queued' type, count(*) total 
			FROM ArticleMod a
			INNER JOIN GroupMembers m ON m.UserID = @userid AND a.SiteID = m.SiteID AND m.GroupID = @assetmodgroupid
			INNER JOIN GuideEntries ge on ge.h2g2id = a.h2g2id
			LEFT JOIN ArticleMediaAsset ama on ama.entryid = ge.entryid
			WHERE a.Status = 0 AND a.NewArticle = 1 AND a.ComplainantID IS NULL AND ama.EntryID IS NOT NULL
		)
	) as eq
)
UNION ALL
--entries-locked
(SELECT 'entries-locked',count(*) FROM ArticleMod 
	WHERE Status = 1 AND NewArticle = 1 AND LockedBy = @userid AND ComplainantID IS NULL)
UNION ALL
--entries-complaints-queued
(
	SELECT 'entries-complaints-queued', sum(eq.total)
	FROM
	(
		(
			SELECT 'entries-complaints-queued' type, count(*) total
			FROM ArticleMod a
			INNER JOIN GroupMembers m ON m.UserID = @userid AND a.SiteID = m.SiteID AND m.GroupID = @modgroupid
			INNER JOIN GuideEntries ge on ge.h2g2id = a.h2g2id
			LEFT JOIN ArticleMediaAsset ama on ama.entryid = ge.entryid
			WHERE a.Status = 0 AND a.ComplainantID IS NOT NULL AND a.LockedBy IS NULL AND ama.entryid IS NULL
		)
		UNION ALL
		(
			SELECT 'entries-complaints-queued' type, count(*) total
			FROM ArticleMod a
			INNER JOIN GroupMembers m ON m.UserID = @userid AND a.SiteID = m.SiteID AND m.GroupID = @assetmodgroupid
			INNER JOIN GuideEntries ge on ge.h2g2id = a.h2g2id
			LEFT JOIN ArticleMediaAsset ama on ama.entryid = ge.entryid
			WHERE a.Status = 0 AND a.ComplainantID IS NOT NULL AND a.LockedBy IS NULL AND ama.entryid IS NOT NULL
		)
	) as eq
)
UNION ALL
--entries-complaints-locked
(SELECT 'entries-complaints-locked',count(*) FROM ArticleMod 
	WHERE Status = 1 AND ComplainantID IS NOT NULL AND LockedBy = @userid)
UNION ALL
--entries-referrals-queued
(SELECT 'entries-referrals-queued',count(*) FROM ArticleMod a
		INNER JOIN GroupMembers m ON m.UserID = @userid AND a.SiteID = m.SiteID AND m.GroupID = @refereegroupid  
	WHERE a.Status = 2 AND a.NewArticle = 1 AND a.LockedBy IS NULL AND a.ComplainantID IS NULL)
UNION ALL
--entries-referrals-locked
(SELECT 'entries-referrals-locked',count(*) FROM ArticleMod 
	WHERE Status = 2 AND NewArticle = 1 AND LockedBy = @userid AND ComplainantID IS NULL)
UNION ALL
--entries-complaints-referrals-queued
(SELECT 'entries-complaints-referrals-queued',count(*) FROM ArticleMod a
		INNER JOIN GroupMembers m ON m.UserID = @userid AND a.SiteID = m.SiteID AND m.GroupID = @refereegroupid 
	WHERE a.Status = 2 AND a.ComplainantID IS NOT NULL AND a.LockedBy IS NULL)
UNION ALL
--entries-complaints-referrals-locked
(SELECT 'entries-complaints-referrals-locked',count(*) FROM ArticleMod 
	WHERE Status = 2 AND ComplainantID IS NOT NULL AND LockedBy = @userid)
UNION ALL

--nicknames-queued
(SELECT 'nicknames-queued',COUNT(*) FROM NicknameMod WHERE status = 0 AND LockedBy IS NULL AND (@issuperuser = 1 OR SiteID IN
		(SELECT gm.SiteID FROM GroupMembers gm WITH (NOLOCK)
			INNER JOIN Groups g WITH (NOLOCK) ON g.GroupID = gm.GroupID
			WHERE g.Name = 'editor' AND gm.UserID = @userid))
)UNION ALL
--nicknames-locked
(SELECT 'nicknames-locked',COUNT(*) FROM NicknameMod WHERE status = 1 AND LockedBy = @userid)
UNION ALL

--general-complaints-queued
(SELECT 'general-complaints-queued',COUNT(*) FROM GeneralMod g 
			INNER JOIN GroupMembers m ON m.UserID = @userid AND g.SiteID = m.SiteID AND m.GroupID = @modgroupid
			 WHERE g.status = 0 AND g.LockedBy IS NULL)
UNION ALL
--general-complaints-locked
(SELECT 'general-complaints-locked',COUNT(*) FROM GeneralMod WHERE status = 1 AND LockedBy = @userid)
UNION ALL

--general-complaints-referrals-queued
(SELECT 'general-complaints-referrals-queued',COUNT(*) FROM GeneralMod g 
	INNER JOIN GroupMembers m ON m.UserID = @userid AND g.SiteID = m.SiteID AND m.GroupID = @refereegroupid
	WHERE g.status = 2 AND g.LockedBy IS NULL)
UNION ALL
--general-complaints-referrals-locked
(SELECT 'general-complaints-referrals-locked',COUNT(*) FROM GeneralMod 
	WHERE status = 2 AND LockedBy = @userid)

--
-- ImageLibrary
--

--images-queued
UNION ALL
(SELECT 'images-queued', count(*)
	FROM ImageMod im INNER JOIN GroupMembers m ON m.UserID = @userid 
		AND im.SiteID = m.SiteID 
		AND m.GroupID = @modgroupid 
	WHERE im.Status = 0 AND im.ComplainantID IS NULL)
--images-locked
UNION ALL
(SELECT 'images-locked', count(*) FROM ImageMod
	WHERE Status = 1 AND LockedBy = @userid AND ComplainantID IS NULL)
--Images-complaints-queued
UNION ALL
(SELECT 'images-complaints-queued', count(*) 
	FROM ImageMod im INNER JOIN GroupMembers m ON m.UserID = @userid 
		AND im.SiteID = m.SiteID AND m.GroupID = @modgroupid 
	WHERE im.Status = 0 AND im.ComplainantID IS NOT NULL AND im.LockedBy IS NULL)
--images-complaints-locked
UNION ALL
(SELECT 'images-complaints-locked', count(*) 
	FROM ImageMod 
	WHERE Status = 1 AND ComplainantID IS NOT NULL AND LockedBy = @userid)

--
-- ImageLibrary - referrals
--

--images-referrals-queued
UNION ALL
(SELECT 'images-referrals-queued', count(*) 
	FROM ImageMod im INNER JOIN GroupMembers m ON m.UserID = @userid 
		AND im.SiteID = m.SiteID 
		AND m.GroupID = @refereegroupid 
		AND im.LockedBy IS NULL
	WHERE im.Status = 2 AND im.ComplainantID IS NULL)
--images-referrals-locked
UNION ALL
(SELECT 'images-referrals-locked', count(*) FROM ImageMod
	WHERE Status = 2 AND LockedBy = @userid AND ComplainantID IS NULL)
--images-complaints-referrals-queued
UNION ALL
(SELECT 'images-complaints-referrals-queued', count(*) 
	FROM ImageMod im INNER JOIN GroupMembers m ON m.UserID = @userid 
		AND im.SiteID = m.SiteID AND m.GroupID = @refereegroupid 
	WHERE im.Status = 2 AND im.ComplainantID IS NOT NULL AND im.LockedBy IS NULL)
--images-complaints-referrals-locked
UNION ALL
(SELECT 'images-complaints-referrals-locked', count(*) 
	FROM ImageMod 
	WHERE Status = 2 AND ComplainantID IS NOT NULL AND LockedBy = @userid)


