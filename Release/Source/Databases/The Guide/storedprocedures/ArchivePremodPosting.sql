CREATE PROCEDURE archivepremodposting @modid int, @reason char(1)
AS

IF (SELECT IsPreModPosting FROM dbo.ThreadMod WHERE ModId=@ModId) <> 1
BEGIN
	RAISERROR('archivepremodposting only works on PreModPosting moderation items',16,1)
	RETURN
END

BEGIN TRANSACTION
BEGIN TRY
	
	DELETE FROM tm
		OUTPUT	deleted.ModID,deleted.ForumID,deleted.ThreadID,deleted.PostID,deleted.DateQueued,deleted.DateLocked,deleted.LockedBy,deleted.NewPost,
				deleted.Status,deleted.Notes,deleted.DateReferred,deleted.DateCompleted,deleted.ReferredBy,deleted.ComplainantID,
				deleted.CorrespondenceEmail,deleted.SiteID,deleted.IsPreModPosting,deleted.ComplaintText,deleted.EncryptedCorrespondenceEmail,
				@reason
		INTO dbo.ThreadModDeleted(ModID,ForumID,ThreadID,PostID,DateQueued,DateLocked,LockedBy,NewPost,
								Status,Notes,DateReferred,DateCompleted,ReferredBy,ComplainantID,
								CorrespondenceEmail,SiteID,IsPreModPosting,ComplaintText,EncryptedCorrespondenceEmail,
								Reason)
		FROM dbo.ThreadMod tm
		WHERE tm.ModId=@modid


	DELETE FROM pp
		OUTPUT	deleted.ModID,deleted.UserID,deleted.ForumID,deleted.ThreadID,deleted.InReplyTo,deleted.Subject,deleted.Body,deleted.PostStyle,deleted.Hash,
				deleted.Keywords,deleted.Nickname,deleted.Type,deleted.EventDate,deleted.ClubID,deleted.NodeID,deleted.IPAddress,deleted.DatePosted,
				deleted.ThreadRead,deleted.ThreadWrite,deleted.SiteID,deleted.AllowEventEntries,deleted.BBCUID,deleted.IsComment,
				deleted.RiskModThreadEntryQueueId,deleted.ApplyExpiryTime,@reason
		INTO dbo.PremodPostingsDeleted(ModID,UserID,ForumID,ThreadID,InReplyTo,Subject,Body,PostStyle,Hash,
									Keywords,Nickname,Type,EventDate,ClubID,NodeID,IPAddress,DatePosted,
									ThreadRead,ThreadWrite,SiteID,AllowEventEntries,BBCUID,IsComment,
									RiskModThreadEntryQueueId,ApplyExpiryTime,Reason)
		FROM dbo.PremodPostings pp
		WHERE pp.ModId=@modid
		
	DELETE FROM pmpti
		OUTPUT deleted.ModId, deleted.TweetId,@reason
		INTO dbo.PreModPostingsTweetInfoDeleted(ModId, TweetId, Reason)
		FROM dbo.PreModPostingsTweetInfo pmpti
		WHERE pmpti.ModId=@modid

    IF XACT_STATE() = 1
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION
	RETURN
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
	EXEC rethrowerror
END CATCH
