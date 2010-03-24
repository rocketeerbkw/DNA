/*
	This stored procedure fetches items from the assetmod moderation queue.
	Locked Items may be requested - only locked items will be pulled out.
	Otherwise a users locked items and non-locked items will be pulled out. 
	Locked Items require editor/ superuser status.
	Referred Items require referee / superuser status.
	Moderator / Editor / Superuser status is otherwise required.
*/
CREATE PROCEDURE getmoderationmediaassets @userid int, @status int = 0, @alerts int = 0,  @lockeditems int = 0, @issuperuser bit = 0, @ishow int = 10
As

--declare @modgroupid int
--SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @editgroup int
select @editgroup = GroupID FROM Groups WHERE Name = 'Editor'

declare @moderatorgroup int
select @moderatorgroup = GroupID FROM Groups WHERE Name = 'Moderator'

declare @refereegroup int
select @refereegroup = GroupID FROM Groups WHERE Name = 'Referee'

declare @Error INT

BEGIN TRANSACTION


--Create a temporary table of entries from the threadmod queue that are going to be displayed
--Priority is given to items that the viewing user has already locked, then date queued
DECLARE @modqueue TABLE( id INT IDENTITY, modid INT, locked BIT, userlocked BIT, editor BIT )
/*IF ( @lockeditems = 1 )
BEGIN
	--Get Locked Items for all Users - Editors Only.
	INSERT @modqueue(modid,locked, userlocked, editor )
	SELECT	am.ModID, 
			CASE WHEN am.LockedBy IS NULL THEN 0 ELSE 1 END 'locked',
			CASE WHEN am.LockedBy = @userid THEN 1 ELSE 0 END 'userlocked',
			1 'editor'
	FROM MediaAssetMod am WITH (NOLOCK)
	INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = am.SiteId
	--INNER JOIN Forums f ON f.ForumId = am.ForumId 
	--LEFT JOIN FastModForums fmf ON fmf.ForumID = f.ForumID
	LEFT JOIN GroupMembers gm WITH (NOLOCK) ON gm.UserId = @userid AND gm.SiteId = s.SiteId
	WHERE am.Status = @status
		AND (case when am.ComplainantID IS null then 0 ELSE 1 END = @alerts)
		AND (gm.groupid = @editgroup OR @issuperuser = 1)
		--AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = @fastmod
	ORDER BY userlocked DESC,  am.DateQueued asc
END
ELSE*/
BEGIN
	--Get Users Items 
	--First get any items locked to current user or non-locked items. 
	--Only Moderators and editors and referees will be able to access items from the queue.
	INSERT @modqueue(modid, locked, userlocked, editor )
	SELECT	am.ModID, 
			CASE WHEN am.LockedBy IS NULL THEN 0 ELSE 1 END 'locked',
			CASE WHEN am.LockedBy = @userid THEN 1 ELSE 0 END 'userlocked',
			CASE WHEN gm.GroupId = @editgroup OR @issuperuser=1 THEN 1 ELSE 0 END 'editor'
	FROM MediaAssetMod am WITH (UPDLOCK)
	INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = am.SiteId
	--INNER JOIN Forums f ON f.ForumId = am.ForumId 
	LEFT JOIN ModerationClassMembers mcm  WITH (NOLOCK) ON mcm.UserId = @userid AND mcm.ModClassId = s.ModClassId			-- check moderator class
	LEFT JOIN GroupMembers gm WITH (NOLOCK) ON gm.UserId = @userid AND gm.SiteId = s.SiteId AND gm.groupid = @editgroup		--check user is editor
	LEFT JOIN GroupMembers gm1 WITH (NOLOCK) ON gm1.UserId = @userid AND gm1.SiteId = s.SiteId AND gm1.groupid = @moderatorgroup -- Check user is moderator (direct access)
	LEFT JOIN GroupMembers gm2 WITH (NOLOCK) ON gm2.UserId = @userid AND gm2.SiteId = s.SiteId AND gm2.groupid = @refereegroup --check referee
	--LEFT JOIN FastModForums fmf ON fmf.ForumID = f.ForumID

	WHERE  am.Status = @status
		AND ( (@lockeditems = 0 AND am.LockedBy IS NULL) OR am.LockedBy = @userid)	-- only get users own locked items if @lockeditems <> 0 
		AND ( NOT mcm.ModClassId IS NULL OR gm.GroupId = @editgroup OR gm1.GroupId = @moderatorgroup OR gm2.GroupId = @refereegroup OR @issuperuser=1 )
		AND ( @status <> 2 OR @issuperuser = 1 OR gm2.GroupId = @refereegroup OR gm.groupid = @editgroup ) -- only fetch refererred items for referees/editors/superusers.. 
		AND (case when am.ComplainantID IS null then 0 ELSE 1 END ) = @alerts
		--AND (CASE WHEN fmf.ForumID IS NOT NULL THEN 1 ELSE 0 END) = @fastmod
	ORDER BY userlocked DESC,  am.DateQueued asc
END

SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError

--get count of items in queue.
declare @count int
select @count = count(*) from @modqueue

--Delete unwanted entries.
delete from @modqueue where id > @ishow
SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError

--Lock any entries that aren't already locked.
IF EXISTS( SELECT * FROM @modqueue mq WHERE mq.locked = 0 )
BEGIN 
	UPDATE MediaAssetMod SET LockedBy = @userid, DateLocked = getdate() 
	WHERE MediaAssetMod.ModId IN ( select ModId FROM @modqueue p WHERE p.locked = 0 )
	SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
END

COMMIT TRANSACTION

-- Return the details. 
SELECT	am.ModID,
		am.MediaAssetID,
		am.SiteID,
		--ge.Subject 'TopicTitle',
		s.ModClassID,
		--ISNULL(th.ModerationStatus,0) 'ThreadModerationStatus',
		ma.Caption,
		ma.filename,
		ma.mimetype,
		ma.contenttype,
		ma.description,
		ma.hidden,
		u.UserId,
		u.UserName,
		u.Status,
		u.FirstNames,
		u.LastName,
		uts.UserTagDescription as 'UserMemberTag',
		am.Notes,
		am.ComplainantID,
		cu.UserId 'ComplainantUserID',
		cu.Username 'ComplainantName',
		cu.Status 'ComplainantStatus',
		cu.FirstNames 'ComplainantFirstNames',
		cu.Lastname 'ComplainantLastName',
		cuts.UserTagDescription as 'ComplainantMemberTag',
		am.Email,
		am.ComplaintText,
		'IsEditor' = mq.editor,
		am.DateQueued,
		am.LockedBy,
		lu.UserId	'LockedUserId',
		lu.UserName 'LockedName',
		lu.FirstNames 'LockedFirstNames',
		lu.Lastname 'LockedLastName',
		lu.Status	'LocedStatus',
		am.DateLocked,
		ru.UserId as ReferrerID,
		ru.UserName as ReferrerName,
		ru.Status as ReferrerStatus,
		ru.FirstNames as 'ReferrerFirstNames',
		ru.LastName as 'ReferrerLastName',
		am.DateReferred,
		@count 'count'
FROM @modqueue mq
INNER JOIN MediaAssetMod am WITH (NOLOCK) ON am.ModID = mq.ModID
INNER JOIN MediaAsset ma ON ma.[ID] = am.MediaAssetId
INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = ma.SiteId
INNER JOIN Users u ON u.UserId = ma.OwnerId

--Author User Tags.
LEFT JOIN UsersTags ut ON ut.UserId = u.UserID AND ut.SiteId = s.SiteId
LEFT JOIN UserTags  uts ON uts.UserTagId = ut.UserTagId

--Complainant User details.
LEFT JOIN Users cu ON cu.UserId = am.ComplainantID
LEFT JOIN UsersTags cut ON cut.UserId = cu.UserID AND cut.SiteId = s.SiteId
LEFT JOIN UserTags  cuts ON cuts.UserTagId = cut.UserTagId

--Referrer User details.
LEFT JOIN Users ru ON ru.UserId = am.ReferredBy

LEFT JOIN Users lu ON lu.UserId = am.LockedBy
--LEFT JOIN GuideEntries ge WITH (NOLOCK) ON ge.ForumId = am.ForumId
ORDER BY mq.id asc

RETURN 0

HandleError:
EXEC Error @Error
	ROLLBACK TRANSACTION
RETURN @Error