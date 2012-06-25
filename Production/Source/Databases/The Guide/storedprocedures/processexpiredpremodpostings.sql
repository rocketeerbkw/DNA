CREATE PROCEDURE processexpiredpremodpostings
AS
BEGIN TRANSACTION

	;WITH ExpiryContenders AS
	(
		-- Find the rows that need their Expiry Time checking
		-- NB It's important to use UPDLOCK within a transaction to prevent moderators picking up expired posts
		SELECT pp.ModId
			  ,DATEADD(minute,CAST(dbo.udf_getsiteoptionsetting(pp.SiteId, 'Moderation', 'ExternalCommentQueuedExpiryTime') AS INT),DatePosted) ExpiryDate
			FROM dbo.PremodPostings pp WITH(UPDLOCK) 
			INNER JOIN ThreadMod tm WITH(UPDLOCK) ON tm.ModId = pp.ModId
			WHERE pp.ApplyExpiryTime=1 AND tm.Status=0 AND tm.LockedBy IS NULL AND
				CAST(dbo.udf_getsiteoptionsetting(pp.SiteId, 'Moderation', 'ExternalCommentQueuedExpiryTime') AS INT) >= 0
	)
	-- Now select the rows that have expired
	SELECT ModId INTO #ExpiryRows
		FROM ExpiryContenders ec
		WHERE DATEDIFF(second,ec.ExpiryDate,GETDATE()) >= 0

	-- Move the expired ThreadMod rows into the Deleted table with the 'E'xpired reason code
	DELETE FROM tm
		OUTPUT	deleted.ModID,deleted.ForumID,deleted.ThreadID,deleted.PostID,deleted.DateQueued,deleted.DateLocked,deleted.LockedBy,deleted.NewPost,
				deleted.Status,deleted.Notes,deleted.DateReferred,deleted.DateCompleted,deleted.ReferredBy,deleted.ComplainantID,
				deleted.CorrespondenceEmail,deleted.SiteID,deleted.IsPreModPosting,deleted.ComplaintText,deleted.EncryptedCorrespondenceEmail,
				'E'
		INTO dbo.ThreadModDeleted(ModID,ForumID,ThreadID,PostID,DateQueued,DateLocked,LockedBy,NewPost,
								Status,Notes,DateReferred,DateCompleted,ReferredBy,ComplainantID,
								CorrespondenceEmail,SiteID,IsPreModPosting,ComplaintText,EncryptedCorrespondenceEmail,
								Reason)
		FROM dbo.ThreadMod tm
		INNER JOIN #ExpiryRows er ON er.ModId = tm.ModId

	-- Move the expired PremodPostings rows into the Deleted table with the 'E'xpired reason code
	DELETE FROM pp
		OUTPUT	deleted.ModID,deleted.UserID,deleted.ForumID,deleted.ThreadID,deleted.InReplyTo,deleted.Subject,deleted.Body,deleted.PostStyle,deleted.Hash,
				deleted.Keywords,deleted.Nickname,deleted.Type,deleted.EventDate,deleted.ClubID,deleted.NodeID,deleted.IPAddress,deleted.DatePosted,
				deleted.ThreadRead,deleted.ThreadWrite,deleted.SiteID,deleted.AllowEventEntries,deleted.BBCUID,deleted.IsComment,
				deleted.RiskModThreadEntryQueueId,deleted.ApplyExpiryTime,'E'
		INTO dbo.PremodPostingsDeleted(ModID,UserID,ForumID,ThreadID,InReplyTo,Subject,Body,PostStyle,Hash,
									Keywords,Nickname,Type,EventDate,ClubID,NodeID,IPAddress,DatePosted,
									ThreadRead,ThreadWrite,SiteID,AllowEventEntries,BBCUID,IsComment,
									RiskModThreadEntryQueueId,ApplyExpiryTime,Reason)
		FROM dbo.PremodPostings pp
		INNER JOIN #ExpiryRows er ON er.ModId = pp.ModId
		
	-- Move the expired Premod posting tweet info into the Deleted table with the 'E'xpired reason code
	DELETE FROM pmpti
		OUTPUT deleted.ModId, deleted.TweetId, 'E'
		INTO dbo.PreModPostingsTweetInfoDeleted(ModId, TweetId, Reason)
		FROM dbo.PreModPostingsTweetInfo pmpti
		INNER JOIN #ExpiryRows er ON er.ModId = pmpti.ModId

COMMIT TRANSACTION
