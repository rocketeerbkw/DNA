/*
	This stored procedure fetches items from the threadmod moderation queue.
	@alerts =1 will pull out alerts / complaints only.
	@lockeditems=1 - only locked items will be pulled out editor/superuser only.
	@fastmod filter - filter on forums fastmod
	@modclassid - filter on sites modclass - eg fetch posts only for sites of a specific mod class.
	@show - allows number of items retrieved ( and locked ) to be varied.
	
	Unles a superuser/editor is viewing locked items items will b elocked to the viewing user.
	Referred Items require referee / superuser /editor status.
	Otherwise user must be a member of appropriate modclass or Moderator / Editor / Superuser / Host
*/
create PROCEDURE getmoderationposts @userid int, @status int = 0, @alerts int = 0,  @lockeditems int = 0, @fastmod int = 0, @issuperuser bit = 0, @modclassid int = NULL, @postid int = NULL, @duplicatecomplaints bit = 0, @show int = 10
As

DECLARE @ErrorCode INT

EXEC openemailaddresskey

--declare @modgroupid int
--SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @editorgroup int
select @editorgroup = GroupID FROM Groups WHERE Name = 'Editor'

declare @moderatorgroup int
select @moderatorgroup = GroupID FROM Groups WHERE Name = 'Moderator'

declare @refereegroup int
select @refereegroup = GroupID FROM Groups WHERE Name = 'Referee'

declare @hostgroup INT
select @hostgroup = GroupID FROM Groups WHERE name = 'Host'

declare @moderateSiteAccess table(siteid INT)
if isnull(@modclassid, 0) > 0
BEGIN
	insert into @moderateSiteAccess
	select siteid from sites where modclassid=@modclassid
END
ELSE
BEGIN
-- only include the ones that the moderator can moderate
	insert into @moderateSiteAccess
	select distinct s.siteid from 
	dbo.sites s
	inner join dbo.groupmembers gm on gm.siteid = s.siteid
	where (@issuperuser =1 or (gm.groupid = @moderatorgroup or gm.groupid = @refereegroup) and gm.userid =@userid)
END


--Create a temporary table of entries from the threadmod queue that are going to be displayed
--Priority is given to items that the viewing user has already locked, then date queued
DECLARE @modqueue TABLE( id INT IDENTITY, modid INT, postid INT, locked BIT, userlocked BIT, editor BIT, referee BIT, host BIT )

BEGIN TRAN

-- Functionality to view other users locked items not currently used.
-- This functionality was intended to allow a superuser to view other users locked items.
/*IF ( @lockeditems = 1  )
BEGIN
	--Get Locked Items for all Users - Superusers / Editors Only.
	INSERT @modqueue(modid,locked, userlocked, editor, referee,host )
	SELECT	tm.ModID, 
			CASE WHEN tm.LockedBy IS NULL THEN 0 ELSE 1 END 'locked',
			CASE WHEN tm.LockedBy = @userid THEN 1 ELSE 0 END 'userlocked',
			1 'editor',
			CASE WHEN gmreferees.GroupId = @refereegroup THEN 1 ELSE 0 END 'referee',
			CASE WHEN gmhosts.GroupId = @hostgroup THEN 1 ELSE 0 END 'host' 
			
	FROM ThreadMod tm WITH (NOLOCK)
	INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = tm.SiteId AND s.ModClassId = ISNULL(@modclassid,s.ModclassId)
	INNER JOIN Forums f ON f.ForumId = tm.ForumId 
	LEFT JOIN FastModForums fmf ON fmf.ForumID = f.ForumID
	LEFT JOIN GroupMembers gmeditors WITH (NOLOCK) ON gmeditors.UserId = @userid AND gmeditors.SiteId = s.SiteId AND gmeditors.GroupId = @editorgroup
	LEFT JOIN GroupMembers gmreferees WITH (NOLOCK) ON gmreferees.UserId = @userid AND gmreferees.SiteId = s.SiteId AND gmreferees.GroupId = @refereegroup
	LEFT JOIN GroupMembers gmhosts WITH (NOLOCK) ON gmhosts.UserId = @userid AND gmhosts.SiteId = s.SiteId AND gmhosts.GroupId = @hostgroup
	WHERE tm.NewPost=1 AND tm.Status = @status  
		AND (case when tm.ComplainantID IS null then 0 ELSE 1 END = @alerts)
		AND (gmeditors.GroupId = @editorgroup OR @issuperuser = 1)
		AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = @fastmod
	ORDER BY userlocked DESC,  tm.DateQueued asc
END*/

--Get Users Items provided viewer is superuser/moderator/referee/editor.
--First get any items locked to current user then non-locked items. 
INSERT @modqueue(modid, postid,  locked, userlocked, editor, referee, host )
SELECT	tm.ModID,
		tm.PostID, 
		CASE WHEN tm.LockedBy IS NULL THEN 0 ELSE 1 END 'locked',
		CASE WHEN tm.LockedBy = @userid THEN 1 ELSE 0 END 'userlocked',
		CASE WHEN gmeditors.GroupId = @editorgroup OR @issuperuser=1 THEN 1 ELSE 0 END 'editor',
		CASE WHEN gmreferees.GroupId = @refereegroup THEN 1 ELSE 0 END 'referee',
		CASE WHEN gmhosts.GroupId = @hostgroup THEN 1 ELSE 0 END 'host'
		
FROM ThreadMod tm WITH (UPDLOCK)
INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = tm.SiteId AND s.SiteId in (select siteid from @moderateSiteAccess)
INNER JOIN Forums f WITH(NOLOCK) ON f.ForumId = tm.ForumId 

LEFT JOIN GroupMembers gmeditors WITH (NOLOCK) ON gmeditors.UserId = @userid AND gmeditors.SiteId = s.SiteId AND gmeditors.groupid = @editorgroup		--check user is editor
LEFT JOIN GroupMembers gmmoderators WITH (NOLOCK) ON gmmoderators.UserId = @userid AND gmmoderators.SiteId = s.SiteId AND gmmoderators.groupid = @moderatorgroup -- Check user is moderator (direct access)
LEFT JOIN GroupMembers gmreferees WITH (NOLOCK) ON gmreferees.UserId = @userid AND gmreferees.SiteId = s.SiteId AND gmreferees.groupid = @refereegroup --check referee
LEFT JOIN GroupMembers gmhosts WITH (NOLOCK) ON gmhosts.UserId = @userid AND gmhosts.SiteId = s.SiteId AND gmhosts.groupid = @hostgroup --check host
LEFT JOIN FastModForums fmf WITH (NOLOCK) ON fmf.ForumID = f.ForumID
WHERE tm.NewPost=1 AND tm.Status = @status 
	AND ( (@lockeditems = 0 AND tm.LockedBy IS NULL) OR tm.LockedBy = @userid) 
	AND ( gmmoderators.GroupId = @moderatorgroup OR @issuperuser=1 OR ( @status = 2 AND gmreferees.GroupId = @refereegroup) )
	AND (case when tm.ComplainantID IS null then 0 ELSE 1 END ) = @alerts
	AND tm.PostId = ISNULL(@postId,tm.PostId)	-- Apply postId filter if specified.
	AND (@alerts <> 1 OR @duplicatecomplaints <> 0 OR 
				tm.modid = (SELECT TOP 1 tt.modid from ThreadMod tt 
									WHERE tt.Status = @status AND tt.PostID = tm.PostID
									AND ( (@lockeditems = 0 AND tt.LockedBy IS NULL) OR tt.LockedBy = @userid)
									AND (case when tt.ComplainantID IS null then 0 ELSE 1 END ) = @alerts
									AND tt.NewPost = 1
									ORDER BY tt.modid)
		) -- Apply duplicate complaint filter if requested - only valid if alerts <> 0. 
	AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = @fastmod
ORDER BY userlocked DESC,  tm.DateQueued asc

SET @ErrorCode = @@ERROR
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN @ErrorCode
END

--get count of items in queue.
declare @count int
select @count = count(*) from @modqueue

--Delete unwanted entries.
delete from @modqueue where id > @show

--Lock any entries that aren't already locked.
IF EXISTS( SELECT * FROM @modqueue mq WHERE mq.locked = 0 )
BEGIN 
	UPDATE ThreadMod SET LockedBy = @userid, DateLocked = getdate() 
	WHERE ThreadMod.ModId IN ( select ModId FROM @modqueue p WHERE p.locked = 0 )
END

SET @ErrorCode = @@ERROR
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN @ErrorCode
END

-- Lock any unlocked duplicate complaints ( complaints for the same post ).
IF @alerts=1 AND @lockeditems = 0
BEGIN
	UPDATE ThreadMod SET LockedBy = @userid, DateLocked = getdate()
	FROM ThreadMod tm
	INNER JOIN @modqueue m ON tm.PostId = m.postId AND tm.LockedBy IS NULL AND tm.Status = @status AND tm.ComplainantId IS NOT NULL
END 

SET @ErrorCode = @@ERROR
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN @ErrorCode
END

COMMIT TRAN

EXEC openemailaddresskey
-- Return the details. 
SELECT		tm.ModID,
		ge.Subject 'TopicTitle',
		s.ModClassID,
		ISNULL(th.ModerationStatus,0) 'ThreadModerationStatus',
		te.ForumID,
		te.ThreadID,
		te.EntryID,
		te.Parent,
		u.UserId,
		CASE WHEN te.UserName IS NOT NULL AND te.forumid = cf.forumid AND cf.NotSignedinUserID = u.UserID THEN te.UserName ELSE u.UserName END as username,
		u.Status,
		u.FirstNames,
		u.LastName,
		p.PrefStatus,
		p.PrefStatusChangedDate,
		p.PrefStatusDuration,
		p.SiteSuffix,
		--uts.UserTagDescription as 'UserMemberTag',
		te.Subject,
		tm.Notes,
		tm.ComplainantID,
		cu.UserId		'ComplainantUserID',
		cu.Username		'ComplainantName',
		cu.Status		'ComplainantStatus',
		cu.FirstNames	'ComplainantFirstNames',
		cu.Lastname		'ComplainantLastName',
		cp.PrefStatus				'ComplainantPrefStatus',
		cp.PrefStatusChangedDate	'ComplainantPrefStatusChangedDate',
		cp.PrefStatusDuration		'ComplainantPrefStatusDuration',
		--cuts.UserTagDescription		'ComplainantMemberTag',
		dbo.udf_decryptemailaddress(tm.EncryptedCorrespondenceEmail,tm.ModID) as CorrespondenceEmail, 
		tm.ComplaintText,
		te.PostStyle,
		te.text,
		tm.SiteID,
		--'Public' = f.CanRead,
		'IsEditor' = mq.editor,
		'IsReferee' = mq.referee,
		'IsHost'	= mq.host,
		tm.DateQueued,
		tm.LockedBy,
		lu.UserId	'LockedUserId',
		lu.UserName 'LockedName',
		lu.FirstNames 'LockedFirstNames',
		lu.Lastname 'LockedLastName',
		lu.Status	'LocedStatus',
		tm.DateLocked,
		ru.UserId as ReferrerID,
		ru.UserName as ReferrerName,
		ru.Status as ReferrerStatus,
		ru.FirstNames as 'ReferrerFirstNames',
		ru.LastName as 'ReferrerLastName',
		tm.DateReferred,
		@count 'count',
		postcounts.postcount 'complaintcount',
		0 as 'IsPreModPosting', 
		mq.id, 
		CASE 
			WHEN users_emails.UserID > 0 THEN users_emails.UserID
			ELSE -1
		END as 'ComplainantIDViaEmail', 
		cf.Url as 'CommentForumUrl', 
		te.PostIndex,
		case when fmf.forumid is null then 0 else 1 end as 'priority'
FROM @modqueue mq
INNER JOIN ThreadMod tm WITH (NOLOCK) ON tm.ModID = mq.ModID AND tm.IsPreModPosting = 0 
INNER JOIN Threads th WITH (NOLOCK) ON th.ThreadId = tm.ThreadId
INNER JOIN ThreadEntries te WITH (NOLOCK) ON te.EntryId =  tm.PostID
INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = tm.SiteId
INNER JOIN Users u WITH (NOLOCK) ON u.UserId = te.UserId

--Author
--LEFT JOIN UsersTags ut WITH (NOLOCK) ON ut.UserId = u.UserID AND ut.SiteId = s.SiteId
--LEFT JOIN UserTags  uts WITH (NOLOCK) ON uts.UserTagId = ut.UserTagId
LEFT JOIN Preferences p WITH (NOLOCK) ON p.UserID = u.UserID AND p.SiteId = tm.SiteId 

--Complainant User details.
LEFT JOIN Users cu WITH (NOLOCK) ON cu.UserId = tm.ComplainantID
--LEFT JOIN UsersTags cut WITH (NOLOCK) ON cut.UserId = cu.UserID AND cut.SiteId = s.SiteId
--LEFT JOIN UserTags  cuts WITH (NOLOCK) ON cuts.UserTagId = cut.UserTagId
LEFT JOIN Preferences cp WITH (NOLOCK) ON cp.UserID = cu.UserID AND cp.SiteID = s.SiteId 

--Referrer User details.
LEFT JOIN Users ru WITH (NOLOCK) ON ru.UserId = tm.ReferredBy

-- Duplicate complaint count.
LEFT JOIN ( SELECT PostId, COUNT(PostId) 'PostCount' FROM ThreadMod WHERE @alerts = 1 AND Status = @status AND LockedBy = @userid AND ComplainantId IS NOT NULL GROUP BY PostId ) AS PostCounts ON PostCounts.PostId = mq.PostId

LEFT JOIN Users lu WITH (NOLOCK) ON lu.UserId = tm.LockedBy
LEFT JOIN GuideEntries ge WITH (NOLOCK) ON ge.ForumId = tm.ForumId

-- Annonymous complainants: see if we can get a user record for the complainant from the email address. Only do it if we don't have a ComplaintantID and the email address is neither null nor blank. 
LEFT JOIN Users users_emails WITH (NOLOCK) ON ISNULL(tm.ComplainantID,0) = 0 AND dbo.udf_hashemailaddress(dbo.udf_decryptemailaddress(tm.EncryptedCorrespondenceEmail,tm.ModID)) = users_emails.hashedemail AND users_emails.hashedemail is not null 
		AND users_emails.userid = (select min(userid) from users WITH (NOLOCK) where hashedemail = users_emails.hashedemail)

-- Get the UID & URL if it's a comment forum. 
LEFT JOIN CommentForums cf WITH (NOLOCK) ON te.ForumID = cf.ForumID
LEFT JOIN FastModForums fmf WITH (NOLOCK) ON fmf.ForumID = te.ForumID

UNION ALL

SELECT	tm.ModID,
		ge.Subject 'TopicTitle',
		s.ModClassID,
		0 'ThreadModerationStatus',
		pmp.ForumID,
		pmp.ThreadID,
		0, -- EntryID,
		pmp.InReplyTo 'Parent',
		u.UserId,
		CASE WHEN pmp.nickname IS NOT NULL AND pmp.forumid = cf.forumid AND cf.NotSignedinUserID = u.UserID THEN pmp.nickname ELSE u.UserName END as username,
		u.Status,
		u.FirstNames,
		u.LastName,
		p.PrefStatus,
		p.PrefStatusChangedDate,
		p.PrefStatusDuration,
		p.SiteSuffix,
		--uts.UserTagDescription as 'UserMemberTag',
		pmp.Subject,
		tm.Notes,
		tm.ComplainantID,
		cu.UserId		'ComplainantUserID',
		cu.Username		'ComplainantName',
		cu.Status		'ComplainantStatus',
		cu.FirstNames	'ComplainantFirstNames',
		cu.Lastname		'ComplainantLastName',
		cp.PrefStatus				'ComplainantPrefStatus',
		cp.PrefStatusChangedDate	'ComplainantPrefStatusChangedDate',
		cp.PrefStatusDuration		'ComplainantPrefStatusDuration',
		--cuts.UserTagDescription		'ComplainantMemberTag',
		dbo.udf_decryptemailaddress(tm.EncryptedCorrespondenceEmail,tm.ModID) as CorrespondenceEmail,
		tm.ComplaintText,
		pmp.PostStyle,
		pmp.body as 'text',
		tm.SiteID,
		--'Public' = f.CanRead,
		'IsEditor' = mq.editor,
		'IsReferee' = mq.referee,
		'IsHost'	= mq.host,
		tm.DateQueued,
		tm.LockedBy,
		lu.UserId	'LockedUserId',
		lu.UserName 'LockedName',
		lu.FirstNames 'LockedFirstNames',
		lu.Lastname 'LockedLastName',
		lu.Status	'LocedStatus',
		tm.DateLocked,
		ru.UserId as ReferrerID,
		ru.UserName as ReferrerName,
		ru.Status as ReferrerStatus,
		ru.FirstNames as 'ReferrerFirstNames',
		ru.LastName as 'ReferrerLastName',
		tm.DateReferred,
		@count 'count',
		postcounts.postcount 'complaintcount',
		1 as 'IsPreModPosting', -- signals the post needs to be treated differently in moderation flow i.e. ThreadEntry and ThreadPosting records need to be created. 
		mq.id, 
		CASE 
			WHEN users_emails.UserID > 0 THEN users_emails.UserID
			ELSE -1
		END as 'ComplainantIDViaEmail', 
		cf.Url as 'CommentForumUrl', 
		-1 as 'PostIndex' -- PreModPostings are only created after moderation so they don't have a ThreadEntries record let alone a PostIndex.
		, case when fmf.forumid is null then 0 else 1 end as 'priority'
FROM @modqueue mq
INNER JOIN ThreadMod tm WITH (NOLOCK) ON tm.ModID = mq.ModID AND tm.IsPreModPosting = 1
INNER JOIN PreModPostings pmp WITH (NOLOCK) ON pmp.ModID = mq.ModID
INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = tm.SiteId
INNER JOIN Users u WITH (NOLOCK) ON u.UserId = pmp.UserId

--Author
--LEFT JOIN UsersTags ut WITH (NOLOCK) ON ut.UserId = u.UserID AND ut.SiteId = s.SiteId
--LEFT JOIN UserTags  uts WITH (NOLOCK) ON uts.UserTagId = ut.UserTagId
LEFT JOIN Preferences p WITH (NOLOCK) ON p.UserID = u.UserID AND p.SiteId = tm.SiteId 

--Complainant User details.
LEFT JOIN Users cu WITH (NOLOCK) ON cu.UserId = tm.ComplainantID
--LEFT JOIN UsersTags cut WITH (NOLOCK) ON cut.UserId = tm.ComplainantID AND cut.SiteId = s.SiteId
--LEFT JOIN UserTags  cuts WITH (NOLOCK) ON cuts.UserTagId = cut.UserTagId
LEFT JOIN Preferences cp WITH (NOLOCK) ON cp.UserID = tm.ComplainantID AND cp.SiteID = s.SiteId 

--Referrer User details.
LEFT JOIN Users ru WITH (NOLOCK) ON ru.UserId = tm.ReferredBy

-- Duplicate complaint count.
LEFT JOIN ( SELECT PostId, COUNT(PostId) 'PostCount' FROM ThreadMod WHERE @alerts = 1 AND Status = @status AND LockedBy = @userid AND ComplainantId IS NOT NULL GROUP BY PostId ) AS PostCounts ON PostCounts.PostId = mq.PostId

LEFT JOIN Users lu WITH (NOLOCK) ON lu.UserId = tm.LockedBy
LEFT JOIN GuideEntries ge WITH (NOLOCK) ON ge.ForumId = tm.ForumId

-- Annonymous complainants: see if we can get a user record for the complainant from the email address. Only do it if we don't have a ComplaintantID and the email address is neither null nor blank. 
LEFT JOIN Users users_emails WITH (NOLOCK) ON ISNULL(tm.ComplainantID,0) = 0 AND dbo.udf_hashemailaddress(dbo.udf_decryptemailaddress(tm.EncryptedCorrespondenceEmail,tm.ModID)) = users_emails.hashedemail AND users_emails.hashedemail is not null 
		AND users_emails.userid = (select min(userid) from users WITH (NOLOCK) where hashedemail = users_emails.hashedemail)


-- Get the UID & URL if it's a comment forum. 
LEFT JOIN CommentForums cf WITH (NOLOCK) ON pmp.ForumID = cf.ForumID
LEFT JOIN FastModForums fmf WITH (NOLOCK) ON fmf.ForumID = pmp.ForumID

ORDER BY mq.id asc

RETURN @@ERROR