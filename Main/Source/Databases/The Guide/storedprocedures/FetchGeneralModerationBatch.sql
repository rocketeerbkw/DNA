CREATE PROCEDURE fetchgeneralmoderationbatch @userid int
As

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @alreadygot int
SELECT @alreadygot = COUNT(*)
FROM GeneralMod
WHERE	Status = 1
		AND LockedBy = @userid

-- Don't fetch a new batch if the user currently has a batch pending
IF @alreadygot = 0
BEGIN
	UPDATE GeneralMod
	SET Status = 1, LockedBy = @userid, DateLocked = getdate()
	FROM (	SELECT TOP 1 g.* FROM GeneralMod g 
			INNER JOIN GroupMembers m ON m.UserID = @UserID AND g.SiteID = m.SiteID AND m.GroupID = @modgroupid
			WHERE	g.Status = 0 
			ORDER BY g.DateQueued asc, g.ModID asc) as t1
	WHERE t1.ModID = GeneralMod.ModID
END

EXEC openemailaddresskey

SELECT	[ModID]
      ,[URL]
      ,[ComplainantID]
      ,dbo.udf_decryptemailaddress(GM.EncryptedCorrespondenceEmail,GM.ModID) as CorrespondenceEmail
      ,[ComplaintText]
      ,[DateQueued]
      ,[DateLocked]
      ,[LockedBy]
      ,[Status]
      ,[Notes]
      ,[ReferredBy]
      ,[DateReferred]
      ,[DateCompleted]
      ,[SiteID]
from GeneralMod GM
WHERE	GM.Status = 1
		AND GM.LockedBy = @userid
ORDER BY GM.DateQueued asc, GM.ModID asc
