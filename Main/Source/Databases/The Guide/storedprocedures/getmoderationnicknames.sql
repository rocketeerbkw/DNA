CREATE PROCEDURE getmoderationnicknames @userid int, @status int = 0, @alerts bit = 0, @lockeditems bit = 0, @issuperuser bit = 0, @modclassid int = NULL, @show int = 10
AS

declare @Error INT

-- Editors, Hosts and superusers get nicknames.
declare @editorgroup INT
SELECT @editorgroup = groupId FROM Groups WITH(NOLOCK) WHERE Name = 'editor'

--declare @moderatorgroup INT
--SELECT @moderatorgroup = groupId FROM Groups WHERE Name = 'moderator'

declare @hostgroup INT
SELECT @hostgroup = groupId FROM Groups WITH(NOLOCK) WHERE Name='host' 

--declare @refereegroup INT
--select @refereegroup = GroupID FROM Groups WHERE Name = 'referee'

BEGIN TRANSACTION 

DECLARE @modqueue TABLE( id INT IDENTITY(1,1), modid INT, locked BIT, userlocked BIT, editor BIT )
INSERT INTO @modqueue( modid, locked, userlocked, editor )
SELECT		ModID, 
			CASE WHEN nm.LockedBy IS NULL THEN 0 ELSE 1 END 'locked',
			CASE WHEN nm.LockedBy = @userid THEN 1 ELSE 0 END 'userlocked',
			CASE WHEN gm.GroupId = @editorgroup THEN 1 ELSE 0 END
			FROM NicknameMod nm WITH(UPDLOCK)
			
			--Filter on Mod Class of site where user changed their nickname/joined. 
			INNER JOIN Sites s WITH (NOLOCK) ON s.SiteId = NM.SiteId AND s.ModClassId = ISNULL(@modclassid,s.ModclassId)
			
			--Filter on Moderation Class of users masthead.
			--INNER JOIN Users u ON u.UserId = nm.UserId 
			--INNER JOIN GuideEntries g ON g.h2g2Id = u.Masthead
			--INNER JOIN Sites us ON us.SiteId = g.SiteId AND ISNULL(@modclassid,us.ModClassId) = us.ModClassId
			
			--Filter on Mod Classes of moderator 
			--LEFT JOIN ModerationClassMembers mcm  WITH (NOLOCK) ON mcm.UserId = @userid AND mcm.ModClassId = s.ModClassId
			
			LEFT JOIN GroupMembers gm WITH (NOLOCK) ON gm.UserId = @userid AND gm.SiteId = nm.SiteId AND gm.groupid = @editorgroup
			LEFT JOIN GroupMembers gmhosts WITH (NOLOCK) ON gmhosts.UserId = @userid AND gmhosts.SiteId = nm.SiteId AND gmhosts.groupid = @hostgroup
			--LEFT JOIN GroupMembers gmreferees WITH (NOLOCK) ON gmreferees.UserId = @userid AND gmreferees.SiteId = s.SiteId AND gmreferees.groupid = @refereegroup
			WHERE nm.Status = @Status AND ( case when nm.ComplainantID IS null then 0 ELSE 1 END = @alerts ) 
			
			--Filter on locked items - if lockeditems=1 users locked items only fetched.
			AND ( (@lockeditems = 0 AND LockedBy IS NULL) OR LockedBy = @userId )
			
			--Filter on moderators permissions
			AND (   gmhosts.GroupId = @hostgroup OR gm.GroupId = @editorgroup OR @issuperuser = 1 )
			ORDER BY userlocked DESC, DateQueued ASC

SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError

--Get Total count of items in queue.
declare @count INT
select @count = count(*) from @modqueue 

--Delete unwanted entries.
delete from @modqueue where id > @show
SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
		
--Lock unlocked entries.	
IF EXISTS ( SELECT * FROM @modqueue WHERE locked = 0 )
BEGIN
	UPDATE NicknameMod SET LockedBy = @userid,  DateLocked = getdate() 
	WHERE ModId IN ( SELECT ModId FROM @modqueue WHERE locked = 0 )
	SELECT @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
END

COMMIT TRANSACTION


SELECT 	NM.ModID,
	u.UserID,
	ISNULL(NM.NickName,u.UserName) 'UserName', -- Premoderated NickName support - Get desired nickname if it exists.
	u.FirstNames,
	u.LastName,
	tags.UserTagDescription 'UserMemberTag',
	alternate.UserId 'AltUserId',
	alternate.Username 'AltUserName',
	p.PrefStatus,
	p.PrefStatusChangedDate,
	p.PrefStatusDuration,
	NM.Status,
	NM.DateQueued,
	NM.DateLocked,
	NM.LockedBy,
	NM.SiteID,
	NM.DateCompleted,
	NM.ComplaintText,
	complainant.UserID		'ComplainantUserID',
	complainant.UserName	'ComplainantUserName',
	complainant.FirstNames	'ComplainantFirstNames',
	complainant.Lastname	'ComplainantLastName',
	pcomplainant.PrefStatus				'ComplainantPrefStatus',
	pcomplainant.PrefStatusChangedDate	'ComplainantPrefStatusChangedDate',
	pcomplainant.PrefStatusDuration		'ComplainantPrefStatusDuration',
	mq.editor 'IsEditor',	
	@count 'Count'
	
	FROM @modqueue mq
	INNER JOIN NickNameMod NM WITH(NOLOCK) ON NM.ModID = mq.ModID
	INNER JOIN Users u WITH(NOLOCK) ON U.UserID = NM.UserID
	LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteId = NM.SiteId
	LEFT JOIN UsersTags ut WITH(NOLOCK) ON ut.UserID = NM.UserID AND ut.SiteID = NM.SiteId 
	LEFT JOIN UserTags tags WITH(NOLOCK) ON tags.UserTagID = ut.UserTagId
	LEFT JOIN Users alternate WITH(NOLOCK) ON alternate.email = u.email AND alternate.UserId <> NM.UserID AND u.email like '%@%'
	LEFT JOIN Users complainant WITH(NOLOCK) ON complainant.UserID = NM.ComplainantID
	LEFT JOIN Preferences pcomplainant WITH(NOLOCK) ON pcomplainant.UserID = complainant.UserID AND pcomplainant.SiteId = NM.SiteId
ORDER BY mq.id ASC

RETURN 0

HandleError:
EXEC Error @Error
IF @@TRANCOUNT > 0 
BEGIN
	ROLLBACK TRANSACTION
END
RETURN @Error