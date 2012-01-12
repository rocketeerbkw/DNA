CREATE PROCEDURE getforumreferralbatch @userid int, @newposts int = 0, 
										@complaints int = 0--, @fastmod bit, @notfastmod bit
As

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'


declare @alreadygot int
SELECT @alreadygot = COUNT(*)
FROM ThreadMod tm
LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
WHERE	tm.Status = 2
		AND tm.NewPost = @newposts
		AND tm.LockedBy = @userid
		AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
		AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0
		

IF @alreadygot = 0
BEGIN
UPDATE ThreadMod
SET LockedBy = @userid, DateLocked = getdate()
FROM (	SELECT TOP 20 tm.*
		FROM ThreadMod tm
				INNER JOIN GroupMembers m ON m.UserID = @userid AND tm.SiteID = m.SiteID AND m.GroupID = @modgroupid
				LEFT JOIN FastModForums fmf on fmf.ForumID = tm.ForumID
		WHERE	tm.Status = 2
				AND tm.NewPost = @newposts
				AND tm.LockedBy IS NULL
				AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
				AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0
		ORDER BY tm.DateQueued asc, tm.ModID asc) as t1
WHERE t1.ModID = ThreadMod.ModID
END

EXEC openemailaddresskey

SELECT TOP 20 * FROM
(
	SELECT	top 20
			th.ModID,
			t.ForumID,
			t.ThreadID,
			t.EntryID,
			t.Subject,
			th.Notes,
			th.ComplainantID,
			dbo.udf_decryptemailaddress(th.EncryptedCorrespondenceEmail,th.ModID) as CorrespondenceEmail, 
			th.ComplaintText,
			th.ReferredBy as ReferrerID,
			u.UserName as ReferrerName,
			t.PostStyle,
			t.text,
			th.SiteID,
			th.IsPreModPosting,
			th.DateQueued
	FROM ThreadEntries t WITH(NOLOCK)
	INNER JOIN ThreadMod th WITH(NOLOCK) ON th.PostID = t.EntryID
	INNER JOIN Users u WITH(NOLOCK) on u.UserID = th.ReferredBy
	INNER JOIN Threads ths WITH(NOLOCK) ON ths.ThreadID = t.ThreadID
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = t.ForumID
	WHERE	th.Status = 2
			AND th.NewPost = @newposts
			AND (case when ComplainantID is null then 0 else 1 end) = @complaints
			AND th.LockedBy = @userid
			AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0
			AND th.IsPreModPOsting = 0
			
	UNION ALL
	
	SELECT	top 20
			th.ModID,
			pmp.ForumID,
			pmp.ThreadID,
			'EntryID' = 0,
			pmp.Subject,
			th.Notes,
			th.ComplainantID,
			dbo.udf_decryptemailaddress(th.EncryptedCorrespondenceEmail,th.ModID) as CorrespondenceEmail, 
			th.ComplaintText,
			th.ReferredBy as ReferrerID,
			u.UserName as ReferrerName,
			pmp.PostStyle,
			pmp.Body,
			th.SiteID,
			th.IsPreModPosting,
			th.DateQueued
	FROM dbo.ThreadMod th WITH(NOLOCK)
	INNER JOIN dbo.PreModPostings pmp WITH(NOLOCK) ON pmp.ModID = th.ModID
	INNER JOIN Users u WITH(NOLOCK) on u.UserID = th.ReferredBy
	LEFT JOIN FastModForums fmf WITH(NOLOCK) on fmf.ForumID = pmp.ForumID
	WHERE	th.Status = 2
			AND th.NewPost = @newposts
			AND (case when ComplainantID is null then 0 else 1 end) = @complaints
			AND th.LockedBy = @userid
			AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = 0
			AND th.IsPreModPOsting = 1
) AS ModPosts
ORDER BY ModPosts.DateQueued asc, ModPosts.ModID asc