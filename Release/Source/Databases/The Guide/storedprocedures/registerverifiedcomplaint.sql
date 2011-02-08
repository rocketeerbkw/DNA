

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
	

	--Add New Moderation item to queue.
	insert into ThreadMod 
	(PostID, ThreadID, ForumID, DateQueued, Status, NewPost, ComplainantID, CorrespondenceEmail, ComplaintText, SiteID )
	select postid, threadid, forumid, getdate(), 0, 1, 0 , CorrespondenceEmail, ComplaintText, SiteID
	from ThreadModAwaitingEmailVerification
	where id = @verificationCode
	
	if @@rowcount = 0
	BEGIN
		return(-1)
	END
	-- capture the key value
	set @ModID = @@identity

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
			NewPost, ComplainantID, CorrespondenceEmail, 
			ComplaintText, SiteID 
	from ThreadMod
	where modid = @ModID

	return (0)
