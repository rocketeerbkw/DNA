CREATE PROCEDURE getfastreferralbatch @userid int, @newposts int = 0, 
										@complaints int = 0--, @fastmod bit, @notfastmod bit
As

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'


declare @alreadygot int
SELECT @alreadygot = COUNT(*)
FROM ThreadMod tm--, forums f
WHERE	tm.Status = 2
		AND tm.NewPost = @newposts
		AND tm.LockedBy = @userid
		AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
		--and tm.forumid = f.forumid
		--and ((@fastmod = 1 and f.fastmod = 1) or (@notfastmod = 1 and f.fastmod = 0))

IF @alreadygot = 0
BEGIN
UPDATE ThreadMod
SET LockedBy = @userid, DateLocked = getdate()
FROM (	SELECT TOP 20 tm.*
		FROM ThreadMod tm
				INNER JOIN Forums f on tm.forumid = f.forumid
				INNER JOIN GroupMembers m ON m.UserID = @userid AND f.SiteID = m.SiteID AND m.GroupID = @modgroupid
		WHERE	tm.Status = 2
				AND tm.NewPost = @newposts
				AND tm.LockedBy IS NULL
				AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
				--and ((@fastmod = 1 and f.fastmod = 1) or (@notfastmod = 1 and f.fastmod = 0))
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
			th.ReferredBy as ReferrerID,
			u.UserName as ReferrerName,
			t.PostStyle,
			t.text,
			th.SiteID,
			'IsPreModPosting' = 0
	FROM ThreadEntries t WITH(NOLOCK)
	INNER JOIN ThreadMod th WITH(NOLOCK) ON th.PostID = t.EntryID
	INNER JOIN Users u WITH(NOLOCK) on u.UserID = th.ReferredBy
	INNER JOIN Threads ths WITH(NOLOCK) ON ths.ThreadID = t.ThreadID
--	INNER JOIN Forums f WITH(NOLOCK) ON t.ForumID = f.ForumID
	WHERE	th.Status = 2
			AND th.NewPost = @newposts
			AND (case when ComplainantID is null then 0 else 1 end) = @complaints
			AND th.LockedBy = @userid
			AND th.IsPreModPosting = 0
			--and ((@fastmod = 1 and f.fastmod = 1) or (@notfastmod = 1 and f.fastmod = 0))
	UNION ALL
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
			th.ReferredBy as ReferrerID,
			u.UserName as ReferrerName,
			pmp.PostStyle,
			pmp.Body,
			th.SiteID,
			'IsPreModPosting' = 1
	FROM ThreadMod th WITH(NOLOCK)
	INNER JOIN dbo.PreModPostings pmp WITH(NOLOCK) ON pmp.ModID = th.ModID
	INNER JOIN Users u WITH(NOLOCK) on u.UserID = th.ReferredBy
	WHERE	th.Status = 2
			AND th.NewPost = @newposts
			AND (case when ComplainantID is null then 0 else 1 end) = @complaints
			AND th.LockedBy = @userid
			AND th.IsPreModPosting = 1
) AS ModPosts
ORDER BY ModPosts.DateQueued asc, ModPosts.ModID asc
