CREATE PROCEDURE getimagemoderationbatch @userid int, 
	@complaints int = 0, @referrals int = 0
As

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

DECLARE @status INT;
SELECT @status = CASE WHEN @referrals = 0 THEN 1 ELSE 2 END;

declare @alreadygot int
SELECT @alreadygot = COUNT(*)
FROM ImageMod
WHERE	Status = @status
		AND LockedBy = @userid
		AND (case when ComplainantID is null then 0 else 1 end) = @complaints

-- Don't fetch a new batch if the user currently has a batch pending
DECLARE @statusToLock INT;
SELECT @statusToLock = CASE WHEN @referrals = 0 THEN 0 ELSE 2 END;
IF @alreadygot = 0
BEGIN
	UPDATE ImageMod
	SET Status = @status, LockedBy = @userid, DateLocked = getdate()
	FROM (	SELECT TOP 20 im.*
			FROM ImageMod im
				INNER JOIN ImageLibrary il on im.ImageID = il.ImageID
				INNER JOIN GroupMembers m ON m.UserID = @userid AND im.SiteID = m.SiteID AND m.GroupID = @modgroupid
			WHERE	im.Status = @statusToLock
					AND (im.LockedBy IS NULL OR @statusToLock = 0)
					AND (case when im.ComplainantID is null then 0 else 1 end) = @complaints
			ORDER BY im.DateQueued asc, im.ModID asc) as im1
	WHERE im1.ModID = ImageMod.ModID
END

SELECT	top 20
		im.ModID,
		im.Notes,
		im.ComplainantID,
		im.CorrespondenceEmail,
		im.ComplaintText,
		im.SiteID,
		il.ImageId,
		il.Description,
		il.Mime
FROM ImageMod im INNER JOIN ImageLibrary il ON il.ImageID = im.ImageID
WHERE	im.Status = @status
		AND (case when im.ComplainantID is null then 0 else 1 end) = @complaints
		AND im.LockedBy = @userid
ORDER BY im.DateQueued asc, im.ModID asc
