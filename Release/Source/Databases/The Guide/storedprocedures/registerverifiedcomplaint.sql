

create procedure registerverifiedcomplaint
	@verificationcode uniqueidentifier
as
	declare @ModID int
	
	DECLARE @lockedby INT
	
	select @ModID = tm.ModId
	FROM ThreadMod tm
	inner join ThreadModAwaitingEmailVerification tmv on tm.postid = tmv.postid
	where tmv.id = @verificationCode AND tm.status=0 AND tm.complainantid IS NULL AND tm.lockedby IS NULL
	
	IF @ModID IS NOT NULL
	BEGIN
		--Remove unprocessed item due to complaint.
		update ThreadMod SET DateLocked = getdate(), DateCompleted = getdate(), Status = 3, Notes = 'Automatically processed - item has a complaint.', LockedBy = 6
		where ModId = @ModID
	END
	
	--if post already failed then remove complaint and return -1
	declare @failedpostid int
	select @failedpostid = tm.postid
	FROM ThreadMod tm
	inner join ThreadModAwaitingEmailVerification tmv on tm.postid = tmv.postid
	where tmv.id = @verificationCode AND tm.status=4
	if @failedpostid is not null
	BEGIN
		delete from ThreadModAwaitingEmailVerification
		where id = @verificationCode
	
		return(-2)
	END
	EXEC openemailaddresskey
	
	DECLARE @correspondenceemail varchar(255)
	SELECT @correspondenceemail=dbo.udf_decryptemailaddress(EncryptedCorrespondenceEmail,PostId)
		from ThreadModAwaitingEmailVerification
		where id = @verificationCode
	
	
	--Add New Moderation item to queue.
	insert into ThreadMod 
	(PostID, ThreadID, ForumID, DateQueued, Status, NewPost, ComplainantID, ComplaintText, SiteID )
	select postid, threadid, forumid, getdate(), 0, 1, 0, ComplaintText, SiteID
	from ThreadModAwaitingEmailVerification
	where id = @verificationCode
	
	if @@rowcount = 0
	BEGIN
		return(-1)
	END
	-- capture the key value
	set @ModID = SCOPE_IDENTITY()

	-- Now we have the ModId, we can encrypt the correspondence email address
	UPDATE dbo.ThreadMod 
		SET EncryptedCorrespondenceEmail = dbo.udf_encryptemailaddress(@correspondenceemail,ModID)
		WHERE ModId = @ModID

	--update threadmodipaddress
	insert into ThreadModIPAddress 
	(ThreadModID, IPAddress, BBCUID) 
	select @ModID, IPAddress, BBCUID
	from ThreadModAwaitingEmailVerification
	where id = @verificationCode
	
	declare @postid int
	select @postid = postid from threadmod where modid=@modid

	-- add event 
	EXEC addtoeventqueueinternal 'ET_COMPLAINTRECIEVED', @ModID, 'IT_MODID', @postid, 'IT_POST', 0
	
	--clear awaiting table
	delete from ThreadModAwaitingEmailVerification
	where id = @verificationCode


	-- return the moderation ID of the column inserted
	select modid, PostID, ThreadID, ForumID, DateQueued, Status, 
			NewPost, ComplainantID, dbo.udf_decryptemailaddress(EncryptedCorrespondenceEmail,modid) as CorrespondenceEmail, 
			ComplaintText, SiteID 
	from ThreadMod
	where modid = @ModID

	return (0)
