CREATE PROCEDURE getmoderationexlinks @modclassid INT, @referrals BIT, @alerts BIT, @locked BIT, @userid int
As

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @refgroupid int
SELECT @refgroupid = groupid from Groups where name='Referee'

declare @issuperuser BIT
SELECT @issuperuser = CASE WHEN Status = 2 THEN 1 ELSE 0 END
FROM Users WHERE userid = @userid

-- Lock Item if none already locked.
IF NOT EXISTS (
	SELECT *
	FROM ExLinkMod
	WHERE	
	@locked = 0 AND datecompleted IS NULL
	AND LockedBy = @userid 
	AND CASE WHEN complainttext IS NULL THEN 0 ELSE 1 END = @alerts 
	AND CASE WHEN status = 2 THEN 1 ELSE 0 END = @referrals ) 
BEGIN
	IF @referrals = 0
	BEGIN
		UPDATE ExLinkMod
		SET LockedBy = @userid, DateLocked = getdate()
		FROM (	SELECT TOP 1 g.* FROM ExLinkMod g 
				LEFT JOIN GroupMembers m ON m.UserID = @UserID AND g.SiteID = m.SiteID AND m.GroupID = @modgroupid
				WHERE	
				(m.GroupID is not null or @issuperuser = 1) 
				AND g.Status = 0
				AND CASE WHEN complainttext IS NULL THEN 0 ELSE 1 END = @alerts
				ORDER BY g.ModID asc) as t1
		WHERE t1.ModID = ExLinkMod.ModID
	END
	ELSE 
	BEGIN
		UPDATE ExLinkMod
		SET LockedBy = @userid, DateLocked = getdate()
		FROM (	SELECT TOP 1 g.* FROM ExLinkMod g 
				LEFT JOIN GroupMembers m ON m.UserID = @UserID AND g.SiteID = m.SiteID AND m.GroupID = @refgroupid
				WHERE	
				(m.GroupID is not null or @issuperuser = 1) 
				AND g.Status = 2
				AND CASE WHEN complainttext IS NULL THEN 0 ELSE 1 END = @alerts
				ORDER BY g.ModID asc) as t1
		WHERE t1.ModID = ExLinkMod.ModID
	END
END


SELECT	Ex.*, 
	locked.username 'lockedname', locked.firstnames 'lockedfirstnames', locked.lastname 'lockedlastname',
	refer.userid 'referrerid', refer.username 'referrername', refer.firstnames 'referrerfirstnames', refer.lastname 'referrerlastname', refer.status 'referrerstatus'
FROM ExLinkMod Ex
INNER JOIN Users locked ON locked.userid = Ex.lockedby 
LEFT JOIN Users refer ON refer.userid = Ex.referredby 
WHERE	Ex.Status = CASE WHEN @referrals = 1 THEN 2 ELSE 0 END
		AND Ex.LockedBy = @userid
		AND CASE WHEN complainttext IS NULL THEN 0 ELSE 1 END = @alerts
		AND CASE WHEN Ex.status = 2 THEN 1 ELSE 0 END = @referrals
ORDER BY Ex.ModID
