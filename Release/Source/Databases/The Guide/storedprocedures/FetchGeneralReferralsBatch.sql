CREATE PROCEDURE fetchgeneralreferralsbatch @userid int
As

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @alreadygot int
SELECT @alreadygot = COUNT(*)
FROM GeneralMod
WHERE	Status = 2
		AND LockedBy = @userid

IF @alreadygot = 0
BEGIN
UPDATE GeneralMod
SET LockedBy = @userid, DateLocked = getdate()
FROM (	SELECT TOP 1 g.*
		FROM GeneralMod g
		INNER JOIN GroupMembers m ON m.UserID = @userid AND g.SiteID = m.SiteID AND m.GroupID = @modgroupid
		WHERE	g.Status = 2
				AND g.LockedBy IS NULL
		ORDER BY g.DateQueued asc, g.ModID asc) as t1
WHERE t1.ModID = GeneralMod.ModID
END

SELECT	*
FROM	GeneralMod
WHERE	Status = 2
		AND LockedBy = @userid
ORDER BY DateQueued asc, ModID asc
