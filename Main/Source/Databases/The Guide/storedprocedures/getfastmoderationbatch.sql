/*
getforummoderationbatch
@userid - id if the user fetching the batch
@newposts - 0 if old posts are wanted, 1 if a batch of new posts are wanted
*/

CREATE PROCEDURE getfastmoderationbatch @userid int, @newposts int = 0, 
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
FROM ThreadMod tm , forums f
INNER JOIN FastModForums fmf on fmf.ForumID = f.ForumID
WHERE	tm.Status = 1
		AND tm.LockedBy = @userid
		AND tm.NewPost = @tnewposts
		AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
			

-- Don't fetch a new batch if the user currently has a batch pending
IF @alreadygot IS NULL
BEGIN
	UPDATE ThreadMod
	SET Status = 1, LockedBy = @userid, DateLocked = getdate()
	FROM (	SELECT TOP 20 tm.ModID
			FROM ThreadMod tm WITH(UPDLOCK)
				INNER JOIN Forums f WITH(NOLOCK) on tm.forumid = f.forumid
				INNER JOIN GroupMembers m WITH(NOLOCK) ON m.UserID = @userid AND f.SiteID = m.SiteID AND m.GroupID = @modgroupid
				INNER JOIN FastModForums fmf ON fmf.ForumID = f.ForumID
			WHERE	tm.Status = 0
					AND tm.NewPost = @tnewposts
					AND (case when tm.ComplainantID is null then 0 else 1 end) = @complaints
					ORDER BY tm.DateQueued asc, tm.ModID asc) as t1
	WHERE t1.ModID = ThreadMod.ModID
END

EXEC openemailaddresskey

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
			dbo.udf_decryptemailaddress(th.EncryptedCorrespondenceEmail,th.ModID) as CorrespondenceEmail, 
			th.ComplaintText,
			t.PostStyle,
			t.text,
			th.SiteID,
			'Public' = f.CanRead,
			'IsEditor' = CASE WHEN g.GroupId is null THEN 0 ELSE 1 END,
			'IsPreModPosting' = 0
	FROM ThreadEntries t WITH(NOLOCK) 
	INNER JOIN ThreadMod th WITH(NOLOCK) ON th.PostID = t.EntryID
	INNER JOIN Forums f WITH(NOLOCK) ON t.ForumID = f.ForumID
	INNER JOIN Threads ths WITH(NOLOCK) ON ths.ThreadID = t.ThreadID
	INNER JOIN FastModForums fmf WITH(NOLOCK) ON fmf.ForumID = f.ForumID
	LEFT JOIN GroupMembers g  WITH(NOLOCK) ON g.UserID = th.ComplainantID AND g.SiteID = th.SiteID AND g.GroupID = @editgroup
	WHERE	th.Status = 1
			AND th.NewPost = @tnewposts
			AND (case when th.ComplainantID is null then 0 else 1 end) = @complaints
			AND th.LockedBy = @userid AND th.IsPreModPosting = 0

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
			dbo.udf_decryptemailaddress(th.EncryptedCorrespondenceEmail,th.ModID) as CorrespondenceEmail, 
			th.ComplaintText,
			pmp.PostStyle,
			pmp.Body,
			th.SiteID,
			'Public' = f.CanRead,
			'IsEditor' = CASE WHEN g.GroupId is null THEN 0 ELSE 1 END,
			'IsPreModPosting' = 1
	FROM ThreadMod th WITH(NOLOCK) 
	INNER JOIN PreModPostings pmp WITH(NOLOCK) ON pmp.ModID = th.ModID
	INNER JOIN FastModForums fmf WITH(NOLOCK) ON fmf.ForumID = pmp.ForumID
	INNER JOIN Forums f WITH(NOLOCK) ON f.ForumID = th.ForumID
	LEFT JOIN GroupMembers g WITH(NOLOCK) ON g.UserID = th.ComplainantID AND g.SiteID = th.SiteID AND g.GroupID = @editgroup
	WHERE	th.Status = 1
			AND th.NewPost = @tnewposts
			AND (case when th.ComplainantID is null then 0 else 1 end) = @complaints
			AND th.LockedBy = @userid AND th.IsPreModPosting = 1
) As ModPosts
ORDER BY ModPosts.DateQueued asc, ModPosts.ModID asc
