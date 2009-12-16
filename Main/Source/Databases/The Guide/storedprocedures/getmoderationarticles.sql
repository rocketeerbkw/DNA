CREATE PROCEDURE getmoderationarticles @userid int, @issuperuser bit = 0, @status int = 0, @alerts bit = 0, @lockeditems bit = 0, @modclassid int = NULL 
As

declare @ErrorCode int
declare @ExecError int

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name = 'Moderator'

declare @assetmodgroupid int
select @assetmodgroupid = groupid from Groups where name = 'AssetModerator'

declare @refereegroupid int
select @refereegroupid = groupid from Groups where name = 'Referee'

		
-- Don't fetch a new batch if the user currently has a batch pending

declare @ModId int

BEGIN TRANSACTION

SELECT	@ModId = a.ModID
FROM ArticleMod a WITH(UPDLOCK)
INNER JOIN Sites s ON s.SiteId = a.SiteId

-- Check Group Membership
LEFT JOIN GroupMembers m WITH(NOLOCK) ON m.UserID = @userid AND m.SiteID = a.SiteID AND m.GroupID = @modgroupid
LEFT JOIN GroupMembers rm WITH(NOLOCK) ON rm.UserID = @userid AND rm.SiteID = a.SiteID AND rm.GroupID = @refereegroupid
LEFT JOIN GroupMembers am WITH (NOLOCK) ON am.UserId = @userid AND am.SiteId = a.SiteId AND  am.GroupID = @assetmodgroupid

-- Associated Media Asset Check
INNER JOIN GuideEntries g On g.h2g2id = a.h2g2id
LEFT JOIN ArticleMediaAsset ama WITH(NOLOCK) on ama.entryid =  g.entryid

WHERE	a.Status = @status AND a.NewArticle = 1
	--Grant access to moderators/referees/superusers or  assetmoderators if there is a corresponding asset for this article.
        AND ( ((m.GroupId IS NOT NULL OR rm.GroupId IS NOT NULL OR @issuperuser = 1) ) OR ( ama.entryId IS NOT NULL AND am.GroupId = @assetmodgroupid ) )
		AND ( a.Status <> 2 OR rm.GroupId = @refereegroupid OR @issuperuser = 1 ) -- only referees/superusers get referred items.
        AND s.ModClassId = ISNULL( @modclassid , s.ModClassId )
        AND (case when a.ComplainantID is null then 0 else 1 end) = @alerts
        AND ( (@lockeditems = 0 AND a.LockedBy IS NULL) OR a.LockedBy = @userid)	-- only get unlocked / users own locked items
ORDER BY a.DateQueued asc

--Lock Item If umlocked.
IF ( @ModId > 0 AND @lockeditems = 0 ) 
BEGIN
		UPDATE ArticleMod SET LockedBy = @userid, DateLocked = getdate() 
		WHERE ArticleMod.ModID = @ModId
		select @ErrorCode = @@ERROR; if @ErrorCode <> 0 goto HandleError
		
		exec @ExecError = addarticlemodhistory @ModId, 1, 
			NULL, NULL, 1, @userid, 0, @userid, NULL;
		select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
		if @ErrorCode <> 0 goto HandleError
END

COMMIT TRANSACTION


SELECT	a.ModID,
 		g.h2g2ID,
		g.Subject,
		a.Notes,
		a.ComplainantID,
		a.CorrespondenceEmail,
		a.ComplaintText,
		a.ReferredBy as ReferrerID,
		u.UserName as ReferrerName,
		g.text,
		g.SiteID
 FROM ArticleMod a
 INNER JOIN GuideEntries g ON g.h2g2Id = a.h2g2Id
 LEFT JOIN Users u ON u.UserId = a.ReferredBy
 WHERE a.ModId = @ModId
 
return 0
 
HandleError:
rollback transaction
return @ErrorCode

