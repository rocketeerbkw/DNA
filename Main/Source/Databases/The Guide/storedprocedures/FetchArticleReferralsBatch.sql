CREATE PROCEDURE fetcharticlereferralsbatch @userid int, @newentries int = 0, @complaints int = 0
As

declare @ErrorCode int
declare @ExecError int
	
declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

declare @alreadygot int
SELECT @alreadygot = COUNT(*)
FROM ArticleMod
WHERE	Status = 2
		AND NewArticle = @newentries
		AND (case when ComplainantID is null then 0 else 1 end) = @complaints
		AND LockedBy = @userid

IF @alreadygot = 0
BEGIN
	DECLARE @ModId int
	SELECT TOP 1 @ModId = a.ModID
		FROM ArticleMod a
		INNER JOIN GuideEntries g ON g.h2g2ID = a.h2g2ID
		INNER JOIN GroupMembers m ON m.UserID = @userid AND g.SiteID = m.SiteID 
			AND m.GroupID = @modgroupid
		WHERE	a.Status = 2
				AND a.NewArticle = @newentries
				AND (case when a.ComplainantID is null then 0 else 1 end) = @complaints
				AND a.LockedBy IS NULL
		ORDER BY a.DateQueued asc, a.ModID asc

	if (@ModID is not null)	
	BEGIN
	--is this transaction in the wrong place?
		BEGIN TRANSACTION		
			UPDATE ArticleMod SET LockedBy = @userid, DateLocked = getdate()
				WHERE ModID = @ModId
			select @ErrorCode = @@ERROR; if @ErrorCode <> 0 goto HandleError
			
			exec @ExecError = addarticlemodhistory @ModId, NULL, 
				NULL, NULL, 1, @userid, 0, @userid, NULL;
			select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
			if @ErrorCode <> 0 goto HandleError
		COMMIT TRANSACTION
	END
END

SELECT	AM.ModID,
		AM.h2g2ID,
		G.EntryID,
		G.Subject,
		AM.Notes,
		AM.ComplainantID,
		AM.CorrespondenceEmail,
		AM.ComplaintText,
		AM.ReferredBy as ReferrerID,
		U.UserName as ReferrerName,
		G.text
FROM ArticleMod AM
INNER JOIN GuideEntries G on G.h2g2ID = AM.h2g2ID
LEFT OUTER JOIN Users U on U.UserID = AM.ReferredBy
WHERE	AM.Status = 2
		AND NewArticle = @newentries
		AND (case when AM.ComplainantID is null then 0 else 1 end) = @complaints
		AND AM.LockedBy = @userid
ORDER BY am.DateQueued asc, am.ModID asc

return 0

HandleError:
rollback transaction
return @ErrorCode
