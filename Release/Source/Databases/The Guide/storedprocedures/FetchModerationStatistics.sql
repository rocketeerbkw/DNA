CREATE PROCEDURE fetchmoderationstatistics @userid int
AS

declare @modgroupid int
SELECT @modgroupid = groupid from Groups WITH(NOLOCK) where name='Moderator'

declare @refereegroupid int
SELECT @refereegroupid = groupid from Groups WITH(NOLOCK) where name='Referee'

declare @hostgroupid int
select @hostgroupid = groupid from Groups WITH(NOLOCK) where name = 'Host'

declare @editorgroupid int
select @editorgroupid = groupid from Groups WITH(NOLOCK) where name = 'Editor'

declare @assetmodgroupid int
select @assetmodgroupid = groupid from Groups WITH(NOLOCK) where name = 'AssetModerator'

declare @issuperuser int
select @issuperuser = CASE WHEN Status = 2 then 1 ELSE 0 END FROM Users WITH(NOLOCK) where UserID = @userid

--forum-queued -- performance checked
(	
	SELECT  'forum' type, 
		'queued' state, 
		count(*) total, 
		s1.modclassid modclassid, 
		min(tm.datequeued) mindatequeued, 
		fastmod = ISNULL(fmf.forumid,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate()) timeleft
	FROM (  --No primary key or on group members - this sub-query causes a better plan
			--to be generated by SQL Server
			SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @modgroupid
		) as s1
	INNER JOIN ThreadMod tm WITH(NOLOCK) on tm.SiteID = s1.SiteID and tm.Status = 0 and tm.lockedby IS NULL and tm.NewPost = 1 and tm.ComplainantID is NULL
	INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.ModClassID = s1.ModClassID
	LEFT JOIN FastModForums fmf WITH(NOLOCK)on fmf.ForumID = tm.ForumID
	GROUP BY s1.modclassid,
		mc.maxage,
		ISNULL(fmf.forumid,0)
)
UNION ALL
--forum-locked -- performance checked
(
	SELECT 'forum', 
		'locked',
		count(*), 
		s.modclassid, 
		min(tm.datequeued),
		fastmod = ISNULL(fmf.forumid,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate())
	FROM ThreadMod tm WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = tm.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = tm.ForumID
	WHERE tm.status = 0 AND tm.NewPost = 1 AND tm.LockedBy = @userid AND tm.ComplainantID IS NULL
	GROUP BY s.modclassid, 
		mc.maxage, 
		ISNULL(fmf.forumid,0)
)
UNION ALL
--forum-complaints-queued -- performance checked
(
	SELECT  'forumcomplaint' type, 
		'queued' state, 
		count(*) total, 
		s1.modclassid modclassid, 
		min(tm.datequeued) mindatequeued, 
		fastmod = ISNULL(fmf.forumid,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate()) timeleft
	FROM (  --No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
			SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @modgroupid
		) as s1
	INNER JOIN ThreadMod tm WITH(NOLOCK) on tm.SiteID = s1.SiteID and tm.Status = 0 and tm.LockedBy IS NULL and tm.ComplainantID is NOT NULL and tm.NewPost = 1 
	INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.ModClassID = s1.ModClassID
	LEFT JOIN FastModForums fmf WITH(NOLOCK)on fmf.ForumID = tm.ForumID
	--INNER JOIN ( 
	--	SELECT tt.PostId, MIN(tt.datequeued) 'datequeued' from ThreadMod tt 
	--	WHERE tt.Status = 0 AND tt.LockedBy IS NULL AND tt.ComplainantID IS NOT NULL AND tt.NewPost = 1
	--	GROUP BY tt.PostId
	--) AS FirstComplaintOnly ON FirstComplaintOnly.PostId = tm.PostId AND FirstComplaintOnly.datequeued = tm.DateQueued
	GROUP BY s1.modclassid,
		mc.maxage,
		ISNULL(fmf.forumid,0)
)
UNION ALL
--forum-complaints-locked -- performance checked
(
	SELECT 'forumcomplaint', 
		'locked',
		count(*), 
		s.modclassid, 
		min(tm.datequeued), 
		ISNULL(fmf.forumid,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate())
	FROM ThreadMod tm WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = tm.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 0 AND tm.ComplainantID IS NOT NULL AND tm.LockedBy = @userid
	GROUP BY s.modclassid, 
		mc.maxage, 
		ISNULL(fmf.forumid,0)
)
UNION ALL
--forum-referrals-queued -- performance checked
(
	SELECT 'forum', 
		'queuedreffered',
		count(*),
		s1.modclassid,
		min(tm.datequeued),
		fastmod = ISNULL(fmf.forumid,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate())
    FROM (	--No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
            SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @refereegroupid
		) as s1
    INNER JOIN ThreadMod tm WITH(NOLOCK) on tm.SiteID = s1.SiteID AND tm.Status = 2 AND tm.NewPost = 1 
        and tm.LockedBy IS NULL and tm.ComplainantID IS NULL
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = tm.ForumID
	group by s1.modclassid, 
		mc.maxage, 
		ISNULL(fmf.forumid,0)
)
UNION ALL
--forum-referrals-locked -- performance checked
(
	SELECT 'forum', 
		'lockedreffered',
		count(*), 
		s.modclassid, 
		min(tm.datequeued), 
		fastmod = ISNULL(fmf.ForumID,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate())
	FROM ThreadMod tm WITH(NOLOCK) 
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = tm.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.NewPost = 1 AND tm.LockedBy = @userid AND tm.ComplainantID IS NULL
	GROUP BY s.modclassid,
		mc.maxage,
        ISNULL(fmf.ForumID,0)
)
UNION ALL
--forum-complaints-referrals-queued -- performance checked
(
	SELECT 'forumcomplaint',
		'queuedreffered',
		count(*),
		s1.modclassid,
		min(tm.datequeued),
		fastmod = ISNULL(fmf.ForumID,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate())
    FROM (  --No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
            SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @refereegroupid  
         ) as s1
	INNER JOIN ThreadMod tm WITH(NOLOCK) on tm.SiteID = s1.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
    --INNER JOIN ( 
	--	SELECT tt.PostId, MIN(tt.datequeued) 'datequeued' from ThreadMod tt 
	--	WHERE tt.Status = 2 AND tt.LockedBy IS NULL AND tt.ComplainantID IS NOT NULL AND tt.NewPost = 1
	--	GROUP BY tt.PostId
	--) AS FirstComplaintOnly ON FirstComplaintOnly.PostId = tm.PostId AND FirstComplaintOnly.datequeued = tm.datequeued
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.ComplainantID IS NOT NULL AND tm.LockedBy IS NULL 
	group by s1.modclassid,
		mc.maxage,
		ISNULL(fmf.ForumID,0)
)
UNION ALL
--forum-complaints-referrals-locked -- performance checked
(
	SELECT 'forumcomplaint',
		'lockedreffered',
		count(*),
		s.modclassid,
		min(tm.datequeued),
		fastmod = ISNULL(fmf.ForumID,0),
		mc.maxage - datediff(minute, min(tm.datequeued), getdate())
	FROM ThreadMod tm WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = tm.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = tm.ForumID
	WHERE tm.Status = 2 AND tm.ComplainantID IS NOT NULL AND tm.LockedBy = @userid 
	group by s.modclassid, 
		mc.maxage, 
		ISNULL(fmf.ForumID,0)
)
UNION ALL
--entries-queued -- performance checked
(
	select 'entry' type,
		'queued' state,
		sum(eq.total) total,
		eq.modclassid modclassid,
		min(eq.mindatequeued) mindataqueued,
		0 fastmod,
		min(eq.maxage) maxage
	from
	(
		(
			SELECT 'entry' type, 
        		'queued' state,
        		count(*) total,
        		s1.modclassid modclassid,
        		min(a.datequeued) mindatequeued,
        		0 fastmod,
        		mc.maxage - datediff(minute, min(a.datequeued), getdate()) maxage 
			FROM (	--No primary key on group members - this sub-query causes a better plan
        			--to be generated by SQL Server
        			SELECT DISTINCT s.siteid,s.modclassid 
					FROM Sites s WITH(NOLOCK)
					LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND  gm.UserID = @userid
					WHERE @issuperuser = 1 OR gm.GroupID = @modgroupid	
        		) as s1
			INNER JOIN ArticleMod a WITH(NOLOCK) on a.SiteID = s1.SiteID
			INNER JOIN GuideEntries ge WITH(NOLOCK) on ge.h2g2id = a.h2g2id
			INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
			left join ArticleMediaAsset ama WITH(NOLOCK) on ama.entryid = ge.entryid
			WHERE a.Status = 0 AND a.LockedBy IS NULL AND a.NewArticle = 1 AND a.ComplainantID IS NULL AND ama.entryid IS NULL
			group by s1.modclassid, 
        		mc.maxage
		)
		union all
		(
			SELECT 'entry' type, 
        		'queued' state,
        		count(*) total,
        		s1.modclassid modclassid,
        		min(am.datequeued) mindatequeued,
        		0 fastmod,
        		mc.maxage - datediff(minute, min(am.datequeued), getdate()) maxage
			FROM (	--No primary key on group members - this sub-query causes a better plan
        			--to be generated by SQL Server
        			SELECT DISTINCT s.siteid,s.modclassid 
        			FROM GroupMembers gm WITH(NOLOCK)
        			INNER JOIN Sites s WITH(NOLOCK) on s.siteid=gm.siteid
        			WHERE gm.UserID = @userid AND gm.GroupID = @assetmodgroupid
        		) as s1
			inner join articlemod am WITH(NOLOCK) on am.siteid = s1.siteid
			inner join guideentries ge WITH(NOLOCK) on ge.h2g2id = am.h2g2id
			INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
			left join articlemediaasset ama WITH(NOLOCK) on ama.entryid = ge.entryid
			WHERE am.Status = 0 AND am.LockedBy IS NULL AND am.NewArticle = 1 AND am.ComplainantID IS NULL AND ama.entryid IS NOT NULL
			group by s1.modclassid, 
        		mc.maxage
		)
	) as eq
		group by 
			eq.modclassid
)
UNION ALL
--entries-locked -- performance checked
(	
	SELECT 'entry', 
		'locked',
		count(*), 
		s.modclassid,
		min(am.datequeued),
		0,
		mc.maxage - datediff(minute, min(am.datequeued), getdate())
	FROM ArticleMod am WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = am.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE am.Status = 0 AND am.NewArticle = 1 AND am.LockedBy = @userid 
		AND am.ComplainantID IS NULL
	group by s.modclassid, 
		mc.maxage
)
UNION ALL
--entries-complaints-queued -- performance checked
(
	select 'entrycomplaint' type,
		'queued' state,
		sum(eq.total) total,
		eq.modclassid modclassid,
		min(eq.mindatequeued) mindataqueued,
		0 fastmod,
		min(eq.maxage) maxage
	from
	(
		(
			SELECT 'entrycomplaint' type, 
        		'queued' state,
        		count(*) total,
        		s1.modclassid modclassid,
        		min(a.datequeued) mindatequeued,
        		0 fastmod,
        		mc.maxage - datediff(minute, min(a.datequeued), getdate()) maxage 
			FROM (	--No primary key on group members - this sub-query causes a better plan
        			SELECT DISTINCT s.siteid,s.modclassid 
					FROM Sites s WITH(NOLOCK)
					LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
					WHERE @issuperuser = 1 OR gm.GroupID = @modgroupid
        		) as s1
			INNER JOIN ArticleMod a WITH(NOLOCK) on a.SiteID = s1.SiteID
			INNER JOIN GuideEntries ge WITH(NOLOCK) on ge.h2g2id = a.h2g2id
			INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
			LEFT join ArticleMediaAsset ama WITH(NOLOCK) on ama.entryid = ge.entryid
			WHERE a.Status = 0 AND a.LockedBy IS NULL AND a.ComplainantID IS NOT NULL AND ama.entryid IS NULL
			group by s1.modclassid, 
        		mc.maxage
		)
		union all
		(
			SELECT 'entrycomplaint' type, 
        		'queued' state,
        		count(*) total,
        		s1.modclassid modclassid,
        		min(am.datequeued) mindatequeued,
        		0 fastmod,
        		mc.maxage - datediff(minute, min(am.datequeued), getdate()) maxage
			FROM (	--No primary key on group members - this sub-query causes a better plan
        			--to be generated by SQL Server
        			SELECT DISTINCT s.siteid,s.modclassid 
        			FROM GroupMembers gm WITH(NOLOCK)
        			INNER JOIN Sites s WITH(NOLOCK) on s.siteid=gm.siteid AND gm.UserID = @userid
        			WHERE gm.GroupID = @assetmodgroupid
        		) as s1
			inner join articlemod am WITH(NOLOCK) on am.siteid = s1.siteid
			inner join guideentries ge WITH(NOLOCK) on ge.h2g2id = am.h2g2id
			INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
			LEFT join articlemediaasset ama WITH(NOLOCK) on ama.entryid = ge.entryid
			WHERE am.Status = 0 AND am.LockedBy IS NULL AND am.ComplainantID IS NOT NULL AND ama.entryid IS NOT NULL
			group by s1.modclassid, 
        		mc.maxage
		)
	) as eq
		group by 
			eq.modclassid
)
UNION ALL
--entries-complaints-locked -- performance checked
(
	SELECT 'entrycomplaint',
		'locked',
		count(*),
		s.modclassid,
		min(am.datequeued),
		0,
		mc.maxage - datediff(minute, min(am.datequeued), getdate())
	FROM ArticleMod am WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = am.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
    WHERE am.Status = 0 AND am.ComplainantID IS NOT NULL AND am.LockedBy = @userid
	group by s.modclassid, 
		mc.maxage
)
UNION ALL
--entries-referrals-queued -- performance checked
(
	SELECT 'entry',
		'queuedreffered',
		count(*),
		s1.modclassid,
		min(a.datequeued),
		0,
		mc.maxage - datediff(minute, min(a.datequeued),	getdate())
	FROM (	--No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
			SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @refereegroupid 
		) as s1
	INNER JOIN ArticleMod a WITH(NOLOCK) on a.SiteID = s1.SiteID
	INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
	WHERE a.Status = 2 AND a.NewArticle = 1 AND a.LockedBy IS NULL AND a.ComplainantID IS NULL
	group by s1.modclassid,
	    mc.maxage

)
UNION ALL
--entries-referrals-locked -- performance checked
(
	SELECT 'entry', 
		'lockedreffered',
		count(*), 
		s.modclassid, 
		min(am.datequeued), 
		0,
		mc.maxage - datediff(minute, min(am.datequeued), getdate())
	FROM ArticleMod am WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = am.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE am.Status = 2 AND am.NewArticle = 1 AND am.LockedBy = @userid AND am.ComplainantID IS NULL
	group by s.modclassid, 
		mc.maxage
)
UNION ALL
--entries-complaints-referrals-queued -- performance checked
(
	SELECT 'entrycomplaint',
		'queuedreffered',
		count(*),
		s1.modclassid,
		min(a.datequeued),
		0,
		mc.maxage - datediff(minute, min(a.datequeued), getdate())
    FROM (  --No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
            SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @refereegroupid  
         ) as s1
	INNER JOIN ArticleMod a WITH(NOLOCK) on a.SiteID = s1.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
	WHERE a.Status = 2 AND a.ComplainantID IS NOT NULL AND a.LockedBy IS NULL
	group by s1.modclassid,
		mc.maxage
)
UNION ALL
--entries-complaints-referrals-locked -- performance checked
(
	SELECT 'entrycomplaint', 
		'lockedreffered',
		count(*),
		s.modclassid,
		min(am.datequeued),
		0,
		mc.maxage - datediff(minute, min(am.datequeued), getdate())
	FROM ArticleMod am WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = am.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE am.Status = 2 AND am.ComplainantID IS NOT NULL AND am.LockedBy = @userid
	group by s.modclassid,
	    mc.maxage
)
UNION ALL
--nicknames-queued -- performance checked
(
	SELECT 'nickname',
		'queued',
		count(*),
		s1.modclassid, 
		min(nm.datequeued),
		0,
		mc.maxage - datediff(minute, min(nm.datequeued), getdate())
    FROM (
            SELECT DISTINCT s.SiteID, s.ModClassID
            FROM Sites s WITH(NOLOCK)
            LEFT JOIN GroupMembers gm WITH(NOLOCK) on s.SiteID = gm.SiteID AND gm.UserID = @userid
            WHERE (@issuperuser = 1 OR gm.GroupID = @hostgroupid or gm.GroupID = @editorgroupid)
         ) as s1
    INNER JOIN NicknameMod nm WITH(NOLOCK) on nm.SiteID = s1.SiteID AND nm.LockedBy IS NULL AND nm.Status = 0
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
    GROUP BY s1.modclassid,
        mc.maxage
)
UNION ALL
--nicknames-locked -- performance checked
(
	SELECT 'nickname',
		'locked',
		count(*),
		s.modclassid, 
		min(nm.datequeued), 
		0,
		mc.maxage - datediff(minute, min(nm.datequeued), getdate())
	FROM NicknameMod nm WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = nm.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE nm.status = 0 AND nm.LockedBy = @userid
	group by s.modclassid,
		mc.maxage
)
UNION ALL
--general-complaints-queued -- performance checked
(
	SELECT 'generalcomplaint',
		'queued',
		count(*),
		s1.modclassid,
		min(g.datequeued),
		0,
		mc.maxage - datediff(minute, min(g.datequeued), getdate())
    FROM (	--No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
            SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @modgroupid
        ) as s1
	INNER JOIN GeneralMod g WITH(NOLOCK) on g.SiteID = s1.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
	WHERE g.status = 0 AND g.LockedBy IS NULL
	group by s1.modclassid, 
		mc.maxage
)
UNION ALL
--general-complaints-locked -- performance checked - still usees status=1 to indicate locked.
(
	SELECT 'generalcomplaint',
		'locked',
		count(*), 
		s.modclassid,
		min(gm.datequeued),
		0,
		mc.maxage - datediff(minute, min(gm.datequeued), getdate())
	FROM GeneralMod gm WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = gm.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
    WHERE gm.status = 1 AND gm.LockedBy = @userid
	group by s.modclassid, 
		mc.maxage
)
UNION ALL
--general-complaints-referrals-queued -- performance checked
(
	SELECT 'generalcomplaint',
		'queuedreffered',
		count(*), 
		s1.modclassid, 
		min(g.datequeued), 
		0,
		mc.maxage - datediff(minute, min(g.datequeued), getdate())
    FROM (  --No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
            SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @refereegroupid
        ) as s1
	INNER JOIN GeneralMod g WITH(NOLOCK) on g.SiteID = s1.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
	WHERE g.status = 2 AND g.LockedBy IS NULL
	group by s1.modclassid,
		mc.maxage

)
UNION ALL
--general-complaints-referrals-locked -- performance checked
(
	SELECT 'generalcomplaint',
		'lockedreffered',
		count(*),
		s.modclassid,
		min(gm.datequeued),
		0,
		mc.maxage - datediff(minute, min(gm.datequeued), getdate())
	FROM GeneralMod gm WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = gm.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE gm.status = 2 AND gm.LockedBy = @userid
	group by s.modclassid,
		mc.maxage
)
UNION ALL
(	
	SELECT  'exlink' type, 
		'queued' state, 
		count(*) total, 
		s1.modclassid modclassid, 
		min(ex.datequeued) mindatequeued, 
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate()) timeleft
	FROM (  --No primary key or on group members - this sub-query causes a better plan
			--to be generated by SQL Server
			SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @modgroupid
		) as s1
	INNER JOIN ExLinkMod ex WITH(NOLOCK) on ex.SiteID = s1.SiteID and ex.Status = 0 and ex.lockedby IS NULL  and ex.complainttext is NULL
	INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.ModClassID = s1.ModClassID
	GROUP BY s1.modclassid,mc.maxage
)

UNION ALL
(
	SELECT 'exlink', 
		'locked',
		count(*), 
		s.modclassid, 
		min(ex.datequeued) mindatequeued,
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate())
	FROM ExLinkMod ex WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = ex.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE ex.status = 0 AND ex.LockedBy = @userid AND ex.complainttext IS NULL
	GROUP BY s.modclassid, mc.maxage
)
UNION ALL
(
	SELECT  'exlinkcomplaint' type, 
		'queued' state, 
		count(*) total, 
		s1.modclassid modclassid, 
		min(ex.datequeued) mindatequeued, 
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate()) timeleft
	FROM (  --No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
			SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @modgroupid
		) as s1
	INNER JOIN ExLinkMod ex WITH(NOLOCK) on ex.SiteID = s1.SiteID and ex.Status = 0 and ex.LockedBy IS NULL and ex.complainttext is NOT NULL
	INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.ModClassID = s1.ModClassID
	GROUP BY s1.modclassid,mc.maxage
)

UNION ALL
(
	SELECT 'exlinkcomplaint', 
		'locked',
		count(*), 
		s.modclassid, 
		min(ex.datequeued), 
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate())
	FROM ExLinkMod ex WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = ex.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE ex.Status = 0 AND ex.complainttext IS NOT NULL AND ex.LockedBy = @userid
	GROUP BY s.modclassid, mc.maxage
)
UNION ALL
(
	SELECT 'exlink', 
		'queuedreffered',
		count(*),
		s1.modclassid,
		min(ex.datequeued) mindatequeued,
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate())
    FROM (	--No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
            SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @refereegroupid
		) as s1
    INNER JOIN ExLinkMod ex WITH(NOLOCK) on ex.SiteID = s1.SiteID AND ex.Status = 2
        and ex.LockedBy IS NULL and ex.complainttext IS NULL
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
	group by s1.modclassid, mc.maxage 
)
UNION ALL
(
	SELECT 'exlink', 
		'lockedreffered',
		count(*), 
		s.modclassid, 
		min(ex.datequeued), 
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate())
	FROM ExLinkMod ex WITH(NOLOCK) 
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = ex.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE ex.Status = 2 AND ex.LockedBy = @userid AND ex.ComplaintText IS NULL
	GROUP BY s.modclassid,mc.maxage
)
UNION ALL
(
	SELECT 'exlinkcomplaint',
		'queuedreffered',
		count(*),
		s1.modclassid,
		min(ex.datequeued) mindatequeued,
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate())
    FROM (  --No primary key on group members - this sub-query causes a better plan
			--to be generated by SQL Server
            SELECT DISTINCT s.siteid,s.modclassid 
			FROM Sites s WITH(NOLOCK)
			LEFT JOIN GroupMembers gm WITH(NOLOCK) on gm.siteid=s.siteid AND gm.UserID = @userid
			WHERE @issuperuser = 1 OR gm.GroupID = @refereegroupid  
         ) as s1
	INNER JOIN ExlinkMod ex WITH(NOLOCK) on ex.SiteID = s1.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s1.modclassid
	WHERE ex.Status = 2 AND ex.complainttext IS NOT NULL AND ex.LockedBy IS NULL 
	group by s1.modclassid, mc.maxage
)
UNION ALL
(
	SELECT 'exlinkcomplaint',
		'lockedreffered',
		count(*),
		s.modclassid,
		min(ex.datequeued) mindatequeued,
		fastmod = 0,
		mc.maxage - datediff(minute, min(ex.datequeued), getdate())
	FROM ExLinkMod ex WITH(NOLOCK)
    INNER JOIN Sites s WITH(NOLOCK) on s.SiteID = ex.SiteID
    INNER JOIN ModerationClass mc WITH(NOLOCK) on mc.modclassid = s.modclassid
	WHERE ex.Status = 2 AND ex.complainttext IS NOT NULL AND ex.LockedBy = @userid 
	group by s.modclassid, mc.maxage
)

OPTION (OPTIMIZE FOR (@userid=6))