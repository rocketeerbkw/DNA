CREATE PROCEDURE moderatepost @forumid int, @threadid int, @postid int, 
	@modid int, @status int, @notes varchar(2000), @referto int, @referredby int, @moderationstatus int = 0, 
	@emailtype varchar(50)=''
As
-- if @referto is zero then this is the same as it being null
if @referto = 0 set @referto = null

declare @reasonid int
declare @realStatus int
declare @datereferred datetime
declare @datecompleted datetime
declare @DateLocked datetime

declare @processed int
set @processed = 0

select @realStatus = CASE @status WHEN 6 THEN 4 ELSE @status END
select @realStatus = CASE @status WHEN 8 THEN 3 ELSE @status END
select @reasonid = reasonid  from modreason where emailname=@emailtype


IF @realStatus = 2
BEGIN
	SELECT @datereferred = getdate()
	SELECT @datecompleted = NULL
	SELECT @DateLocked = getdate()
END
ELSE
BEGIN
	SELECT @DateLocked = NULL
	SELECT @datereferred = NULL
	SELECT @datecompleted = getdate()
END

BEGIN TRANSACTION
DECLARE @ErrorCode INT, @Success int, @authorsemail varchar(255), @complainantsemail varchar(255), @islegacy int, @authorid int, @complainantid int

EXEC openemailaddresskey

-- Update the ThreadMod line for this moderation
-- Make sure we don't overwrite any existing dates however
UPDATE ThreadMod
	SET	Status = @realStatus,
		Notes = @notes + ISNULL(NULLIF(char(13) + char(10) + Notes, char(13) + char(10)),''),
		DateLocked = isnull(@DateLocked, DateLocked),
		DateReferred = isnull(@datereferred, DateReferred),
		DateCompleted = isnull(@datecompleted, DateCompleted),
		LockedBy = CASE WHEN @realStatus = 2 THEN @referto ELSE LockedBy END,
		ReferredBy = CASE WHEN @realStatus = 2 THEN @referredby ELSE ReferredBy END
	WHERE ModID = @modid 
SET @processed = @@ROWCOUNT

--add thread mod history
insert into dbo.ThreadModHistory
           ([ModID]
           ,[LockedBy]
           ,[Status]
           ,[ReasonId]
           ,[Notes]
           ,[ReferredBy])
	 select
		 modid,
		 lockedby,
		 status,
		 @reasonid,
		 notes,
		 referredby
	from ThreadMod
	where modid=@modid
	
declare @modhistoryid int
SET @modhistoryid = SCOPE_IDENTITY()

IF ( @@ERROR <> 0 OR @processed = 0 )
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--Check to see if the post we're about to moderate is in the PreModPostings table and a moderation decision has been reached.
--If so, we need to create the new thread entry and update the ThreadMod Table with the new entry id
IF EXISTS ( SELECT * FROM dbo.ThreadMod WITH(NOLOCK) WHERE ModID = @ModID AND IsPreModPosting = 1 )
BEGIN
	--Only create a premod posting for a final moderation decision.
	IF ( @realstatus = 3 OR @realstatus = 4 )
	BEGIN
		declare @updatethreadtime int
		if @realstatus = 3
		BEGIN
			select @updatethreadtime = 1
		END
		ELSE
		BEGIN
			select @updatethreadtime = 0
		END
		EXEC @ErrorCode = createpremodpostingentry @ModID, @updatethreadtime,  @ThreadID OUTPUT, @PostID OUTPUT
		SET @ErrorCode = dbo.udf_checkerr(@@ERROR,@ErrorCode)
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			select	'AuthorsEmail' = @authorsemail,
					'AuthorID' = @authorid, 
					'ComplaintsEmail' = @complainantsemail,
					'ComplainantID' = @complainantid, 
					'IsLegacy' = @islegacy, 
					'processed' = @processed,
					'PostID' = 0,
					'ThreadID' = 0
					,'modid'=0
			RETURN @ErrorCode
		END
	END
	ELSE
	BEGIN
		-- Not a final mod decision - further processign not required.
		COMMIT TRANSACTION
		select	'AuthorsEmail' = @authorsemail,
					'AuthorID' = @authorid, 
					'ComplaintsEmail' = @complainantsemail,
					'ComplainantID' = @complainantid, 
					'IsLegacy' = @islegacy, 
					'processed' = @processed,
					'PostID' = 0,
					'ThreadID' = 0
					,'modid'=0
		RETURN
	END
END

--Validation Check - Check necessary post details are available.
IF ( @PostID = 0 OR @ThreadID = 0 OR @ForumId = 0 )
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('moderatepost- ThreadID = 0 OR PostID = 0 or forumid = 0 - Invalid post parameters.',16,1)
	SELECT	'AuthorsEmail' = @authorsemail,
			'AuthorID' = @authorid, 
			'ComplaintsEmail' = @complainantsemail,
			'ComplainantID' = @complainantid, 
			'IsLegacy' = @islegacy,
			'PostID' = 0,
			'ThreadID' = 0
			,'modid'=0
	RETURN 50000
END

-- Automatically process any additional complaints locked to this user/unlocked for this moderation item.
DECLARE @duplicatecomplaints table( MODID INT NOT NULL )
IF @PostID > 0 
BEGIN
	IF EXISTS ( SELECT * FROM ThreadMod WHERE ModId = @modid AND ComplainantID IS NOT NULL )
	BEGIN
		INSERT INTO @duplicatecomplaints ( ModId)
		SELECT ModId 
		FROM ThreadMod 
		WHERE  
			ComplainantID IS NOT NULL AND PostId = @postId AND DateCompleted IS NULL 
			AND ( LockedBy =  @referredby OR (@realstatus = 4 AND LockedBy IS NULL) )
			AND ModId <> @ModId
		
		IF (@@ERROR <> 0)
		BEGIN
			SET @ErrorCode = @@ERROR
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
		
		UPDATE ThreadMod
		SET	Status = @realStatus,
			Notes = 'Automatically processed - Duplicate Complaint for Post.',
			DateLocked = isnull(@DateLocked, isnull(DateLocked,getdate())), -- Lock Unlocked complaint.
			DateReferred = isnull(@datereferred, DateReferred),
			DateCompleted = isnull(@datecompleted, DateCompleted),
			LockedBy = CASE WHEN @realStatus = 2 THEN @referto ELSE @referredby END, -- Lock Unlocked complaint.
			ReferredBy = CASE WHEN @realStatus = 2 THEN @referredby ELSE ReferredBy END
		FROM ThreadMod th
		INNER JOIN @duplicatecomplaints dc ON dc.ModId = th.ModId
		
		SET @processed = @processed + @@ROWCOUNT
		
		IF (@@ERROR <> 0)
		BEGIN
			SET @ErrorCode = @@ERROR
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
END

declare @dummy int
select @dummy = ForumID from FOrums WITH(UPDLOCK) WHERE ForumID = @forumid
declare @threadmod int
select @dummy = ThreadID, @threadmod = ISNULL(ModerationStatus,0) from Threads WITH(UPDLOCK) WHERE ThreadID = @threadid

-- Get the parent ID - if it's NULL this is the first post in a thread
declare @parent int, @newsubject nvarchar(255)
SELECT @parent = Parent, @newsubject = Subject FROM ThreadEntries WITH(UPDLOCK) 
	WHERE EntryID = @postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--Update Threads Moderation status if specified.
IF ( @moderationstatus <> @threadmod )
BEGIN
	Update Threads SET ModerationStatus = @moderationstatus
	WHERE ThreadId = @threadid
	SET @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

-- If it's failed moderation or been referred, hide the post
-- Do not change post info if the post failed but was edited
IF (@realStatus = 4 and @status <> 6) or @realStatus = 2
BEGIN
--	UPDATE Forums SET LastUpdated = getdate() WHERE ForumID = @forumid
	INSERT INTO ForumLastUpdated (ForumID, LastUpdated) 
		VALUES(@forumid, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Threads WITH(HOLDLOCK)
		SET LastUpdated = getdate(),
			FirstSubject = CASE WHEN @parent IS NULL THEN '' ELSE FirstSubject END 
		WHERE ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ThreadEntries WITH(HOLDLOCK)
		SET Hidden = CASE WHEN @realStatus = 4 THEN 1 ELSE 2 END WHERE EntryID = @postid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

DECLARE @newpost int
DECLARE @siteid int
SELECT @newpost = NewPost,  @siteid = siteid  FROM ThreadMod WITH(NOLOCK) WHERE ModID = @modid

if (@realstatus = 4)
begin
	declare @userid int
	select @userid = userid FROM ThreadEntries WITH(NOLOCK) WHERE entryid = @postid
	 
	update Preferences set ContentFailedOrEdited = 1
	where userid =  @userid and siteid = @siteid
	
	-- failed anonymous posts should have their names removed as well as being hidden.
	IF EXISTS (SELECT * FROM VCommentForums WHERE FORUMID = @ForumID AND NotSignedinUserID = @UserID)
	BEGIN
		UPDATE ThreadEntries WITH(HOLDLOCK) SET UserName = 'Anonymous User' WHERE EntryID = @PostID
	END

	--Add an event to the queue to say that the post has been hidden
	EXEC addtoeventqueueinternal 'ET_POSTREVOKE', @threadid, 'IT_THREAD', @postid, 'IT_POST', @userid
end

-- If it has been passed however, make sure that it is NOT hidden
if (@realStatus = 3 AND @newpost = 1)
begin
--	UPDATE Forums SET LastUpdated = getdate() WHERE ForumID = @forumid
	INSERT INTO ForumLastUpdated (ForumID, LastUpdated) 
		VALUES(@forumid, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	update Threads WITH(HOLDLOCK) set LastUpdated = getdate(),
			FirstSubject = CASE WHEN @parent IS NULL THEN @newsubject ELSE FirstSubject END 
		where ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	update ThreadEntries WITH(HOLDLOCK) set hidden = null where EntryID = @postid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
end

--First Post Handling
IF ( @parent IS NULL)
BEGIN
	IF @realstatus = 4  
	BEGIN
		-- Hide the thread where there are no other posts
		IF ( NOT EXISTS (SELECT * FROM ThreadEntries WITH(UPDLOCK) 
					WHERE threadid = @threadid AND Hidden IS NULL) )
		BEGIN
			-- Dont hide thread where only 1 thread per forum.
			DECLARE @forumstyle INT
			SELECT @forumstyle = forumstyle FROM forums WHERE forumid = @forumid
			IF ( @forumstyle <> 1 )
			BEGIN
				UPDATE Threads
					Set VisibleTo = 1
					WHERE ThreadID = @threadid
				SELECT @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					EXEC Error @ErrorCode
					RETURN @ErrorCode
				END
			END
		END
			
		IF (dbo.udf_getsiteoptionsetting(@siteid, 'Moderation', 'CloseThreadOnHideFirstPost') = 1)	
		BEGIN
			UPDATE Threads
				-- First post has failed - Close Thread
				Set CanWrite = 0
				WHERE ThreadID = @threadid
			SELECT @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END
		END			
	END
	ELSE IF @realstatus = 3 
	BEGIN
		UPDATE Threads SET VisibleTo = NULL
		WHERE ThreadId = @threadid
	
		IF (dbo.udf_getsiteoptionsetting(@siteid, 'Moderation', 'ProcessPreMod') != 1)	
		BEGIN
			--Open thread automatically if post is passed and if not a process pre mod thread.
			-- fixing bug for kids where editing first post opened a closed forum
			UPDATE Threads SET CanWrite = 1
			WHERE ThreadId = @threadid
		END
	END
END

 -- add event
 EXEC addtoeventqueueinternal 'ET_MODERATIONDECISION_POST', @modhistoryid, 'IT_MODHISTORYID', @postid, 'IT_POST', @referredby


COMMIT TRANSACTION

-- Auto Close Thread if necessary
-- Might be necessary if processpremod posting is on meaning posts are created after moderation.
DECLARE @postlimit INT
DECLARE @threadPostCount INT 
SELECT @postlimit = CAST(ISNULL(dbo.udf_getsiteoptionsetting(@siteid, 'Forum', 'PostLimit' ),'0') AS INT )
IF ( @postlimit > 0 )
BEGIN
    SELECT @threadpostcount = ThreadPostCount FROM Threads WHERE ThreadId = @threadid
    IF ( @threadpostcount >= @postlimit )
    BEGIN
        -- Do not apply autoclose if threads forum is associated with an editors article.
        IF ( NOT EXISTS(SELECT * FROM GuideEntries g
                        INNER JOIN GroupMembers gm ON gm.userid = g.editor AND gm.siteid = @siteid
                        INNER JOIN Groups gr ON gr.groupid = gm.groupid AND gr.name='editor'
                        WHERE g.forumid = @forumid  ) )
        BEGIN
            UPDATE Threads SET CanWrite = 0 WHERE ThreadId = @threadid 
        END
    END
END 

--Return the email address of the moderation items affected.
SELECT 
		DupComplaints.AuthorsEmail,
		DupComplaints.AuthorID,
		DupComplaints.ComplaintsEmail,
		DupComplaints.ComplainantID,
		DupComplaints.IsLegacy,
		DupComplaints.Processed,
		DupComplaints.PostID,
		DupComplaints.ThreadID,
		DupComplaints.ModID
	 FROM
(
	SELECT	dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) 'authorsemail',
			U.UserID 'authorid', 
			dbo.udf_decryptemailaddress(TM.EncryptedCorrespondenceEmail,TM.ModID) 'complaintsemail',
			TM.ComplainantID,
			case when TM.NewPost = 0 then 1 else 0 end 'IsLegacy',
			@processed 'processed', 
			te.EntryID 'PostID',
			te.ThreadID,
			TM.ModID
		FROM ThreadMod TM WITH(NOLOCK)
			inner join ThreadEntries TE WITH(NOLOCK) on TE.EntryID = TM.PostID
			inner join Users U WITH(NOLOCK) on U.UserID = TE.UserID
		where TM.ModID = @ModID
	
	UNION ALL
	
	SELECT	dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) 'authorsemail',
			U.UserID 'authorid', 
			dbo.udf_decryptemailaddress(TM.EncryptedCorrespondenceEmail,TM.ModID) 'complaintsemail',
			TM.ComplainantID,
			case when TM.NewPost = 0 then 1 else 0 end 'IsLegacy',
			@processed 'processed', 
			te.EntryID 'PostID',
			te.ThreadID,
			d.ModID
		from ThreadMod TM WITH(NOLOCK)
			inner join ThreadEntries TE WITH(NOLOCK) on TE.EntryID = TM.PostID
			inner join Users U WITH(NOLOCK) on U.UserID = TE.UserID
			inner join @duplicatecomplaints d on d.modid = tm.modid
) AS DupComplaints
-- finally return the authors and complainants email addresses
-- also return if this was a legacy moderation or not
--select	'AuthorsEmail' = @authorsemail,
--		'ComplainantsEmail' = @complainantsemail,
--		'IsLegacy' = @islegacy
