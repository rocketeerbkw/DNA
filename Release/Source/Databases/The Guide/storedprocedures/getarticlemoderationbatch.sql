CREATE PROCEDURE getarticlemoderationbatch @userid int, @newentries int = 0, @complaints int = 0
As

declare @ErrorCode int
declare @ExecError int

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name = 'Moderator'

declare @assetmodgroupid int
select @assetmodgroupid = groupid from Groups where name = 'AssetModerator'

declare @alreadygot int

SELECT @alreadygot = COUNT(*)
FROM ArticleMod
WHERE	Status = 1
		AND NewArticle = @newentries
		AND LockedBy = @userid
		AND (case when ComplainantID is null then 0 else 1 end) = @complaints
		
-- Don't fetch a new batch if the user currently has a batch pending
IF @alreadygot = 0
BEGIN
	declare @ModId int
	SELECT TOP 1 @ModID = aml.ModID
    FROM
    (   
        ( 
        	SELECT	TOP 1 a.ModID, a.DateQueued
            FROM ArticleMod a WITH(NOLOCK)
        	INNER JOIN GuideEntries g WITH(NOLOCK) ON g.h2g2ID = a.h2g2ID
        	INNER JOIN GroupMembers m WITH(NOLOCK) ON m.UserID = @userid AND g.SiteID = m.SiteID AND m.GroupID = @modgroupid
            LEFT JOIN ArticleMediaAsset ama WITH(NOLOCK) ON ama.entryid = g.entryid
        	WHERE	a.Status = 0 AND a.LockedBy IS NULL
        			AND a.NewArticle = @newentries
        			AND (case when a.ComplainantID is null then 0 else 1 end) = @complaints
                    AND ama.MediaAssetID IS NULL
        	ORDER BY a.DateQueued asc, a.ModID asc
        )
        UNION ALL
        (
            SELECT TOP 1 a.ModID, a.DateQueued
            FROM ArticleMod a WITH(NOLOCK)
            INNER JOIN GuideEntries g WITH(NOLOCK) on g.h2g2ID = a.h2g2ID
            INNER JOIN GroupMembers gm WITH(NOLOCK) on gm.UserID = @userid AND g.SiteID = gm.SiteID AND gm.GroupID = @assetmodgroupid
            LEFT JOIN ArticleMediaAsset ama WITH(NOLOCK) on ama.entryid =  g.entryid
        	WHERE	a.Status = 0 AND a.LockedBy IS NULL
        			AND a.NewArticle = @newentries
        			AND (case when a.ComplainantID is null then 0 else 1 end) = @complaints
                    AND ama.MediaAssetID IS NOT NULL
        	ORDER BY a.DateQueued asc, a.ModID asc
        ) 
    )as aml
        order by aml.DateQueued asc,
            aml.ModID asc
	
	if (@ModId is not null)
	begin
		-- wrong place for trans?
		begin transaction
			UPDATE ArticleMod SET Status = 1, LockedBy = @userid, 
				DateLocked = getdate() WHERE @ModId = ArticleMod.ModID
			select @ErrorCode = @@ERROR; if @ErrorCode <> 0 goto HandleError
			
			exec @ExecError = addarticlemodhistory @ModId, 1, 
				NULL, NULL, 1, @userid, 0, @userid, NULL;
			select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
			if @ErrorCode <> 0 goto HandleError
		commit transaction
	end
END

EXEC openemailaddresskey

SELECT	a.ModID,
 		g.h2g2ID,
		g.Subject,
		a.Notes,
		a.ComplainantID,
		dbo.udf_decryptemailaddress(a.EncryptedCorrespondenceEmail,a.ModID) as CorrespondenceEmail, 
		a.ComplaintText,
		g.text
 FROM GuideEntries g
 INNER JOIN ArticleMod a ON a.h2g2ID = g.h2g2ID
 WHERE	a.Status = 1
		AND a.NewArticle = @newentries
		AND (case when ComplainantID is null then 0 else 1 end) = @complaints
		AND a.LockedBy = @userid
 ORDER BY a.DateQueued asc, a.ModID asc
 
return 0
 
HandleError:
rollback transaction
return @ErrorCode

