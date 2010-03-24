/*
getforummoderationbatch
@userid - id if the user fetching the batch
@newposts - 0 if old posts are wanted, 1 if a batch of new posts are wanted
*/

CREATE PROCEDURE getforummoderationbatch @userid int, @newposts int = 0, 
	@complaints int = 0--, @fastmod bit--, @notfastmod bit
As

declare @tnewposts tinyint
set @tnewposts = @newposts
declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @editgroup int
select @editgroup = GroupID FROM Groups WHERE Name = 'Editor'

declare @alreadygot int
SELECT TOP 1 @alreadygot = ModID
FROM ThreadMod tm 
LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
WHERE	tm.Status = 1
		AND tm.LockedBy = @userid
		AND tm.NewPost = @tnewposts
		AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
		AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0

-- Don't fetch a new batch if the user currently has a batch pending
IF @alreadygot IS NULL
BEGIN
	UPDATE ThreadMod
	SET Status = 1, LockedBy = @userid, DateLocked = getdate()
	FROM (	SELECT TOP 20 tm.ModID
			FROM ThreadMod tm WITH(UPDLOCK)
				INNER JOIN GroupMembers m WITH(NOLOCK) ON m.UserID = @userid AND tm.SiteID = m.SiteID AND m.GroupID = @modgroupid
				LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = tm.ForumID
			WHERE	tm.Status = 0 AND tm.LockedBy IS NULL
					AND tm.NewPost = @tnewposts
					AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
					AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0
			ORDER BY tm.DateQueued asc, tm.ModID asc) as t1
	WHERE t1.ModID = ThreadMod.ModID
END

SELECT TOP 20 * FROM
(
	SELECT TOP 20
			th.ModID,
			th.DateQueued,
			t.ForumID,
			t.ThreadID,
			t.EntryID,
			t.Subject,
			th.Notes,
			th.ComplainantID,
			th.CorrespondenceEmail,
			th.ComplaintText,
			t.PostStyle,
			t.text,
			th.SiteID,
			'Public' = f.CanRead,
			'IsEditor' = CASE WHEN g.GroupId is null THEN 0 ELSE 1 END,
			'IsPreModPosting' = 0
	FROM dbo.ThreadEntries t WITH(NOLOCK)
	INNER JOIN dbo.ThreadMod th WITH(NOLOCK) ON th.PostID = t.EntryID
	INNER JOIN dbo.Forums f WITH(NOLOCK) ON t.ForumID = f.ForumID
	INNER JOIN dbo.Threads ths WITH(NOLOCK) ON ths.ThreadID = t.ThreadID
	LEFT JOIN dbo.GroupMembers g  WITH(NOLOCK) ON g.UserID = th.ComplainantID AND g.SiteID = th.SiteID AND g.GroupID = @editgroup
	LEFT JOIN dbo.FastModForums fmf WITH(NOLOCK) on fmf.ForumID = t.ForumID
	WHERE	th.Status = 1
		AND th.NewPost = @tnewposts
		AND (case when th.ComplainantID is null then 0 else 1 end) = @complaints
		AND th.LockedBy = @userid
		AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0
		AND th.IsPreModPosting = 0
	UNION ALL
	(
		SELECT TOP 20
				th.ModID,
				th.DateQueued,
				pmp.ForumID,
				pmp.ThreadID,
				'EntryID' = 0,
				pmp.Subject,
				th.Notes,
				th.ComplainantID,
				th.CorrespondenceEmail,
				th.ComplaintText,
				pmp.PostStyle,
				pmp.Body,
				th.SiteID,
				'Public' = f.CanRead,
				'IsEditor' = CASE WHEN g.GroupId is null THEN 0 ELSE 1 END,
				'IsPreModPosting' = 1
		FROM ThreadMod th WITH(NOLOCK)
		INNER JOIN dbo.PreModPostings pmp WITH(NOLOCK) ON th.ModID = pmp.ModID
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = th.ForumID
		LEFT JOIN dbo.GroupMembers g  WITH(NOLOCK) ON g.UserID = th.ComplainantID AND g.SiteID = th.SiteID AND g.GroupID = @editgroup
		LEFT JOIN dbo.FastModForums fmf WITH(NOLOCK) on fmf.ForumID = pmp.ForumID
		WHERE	th.Status = 1
			AND th.NewPost = @tnewposts
			AND (case when th.ComplainantID is null then 0 else 1 end) = @complaints
			AND th.LockedBy = @userid
			AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0
			AND th.IsPreModPosting = 1
	)
) AS ModPosts
ORDER BY ModPosts.DateQueued asc, ModPosts.ModID asc
