CREATE PROCEDURE moderatepostold @forumid int, @threadid int, @postid int, 
	@modid int, @status int, @notes varchar(2000), @referto int, @referredby int, @moderationstatus int = 0
As
-- if @referto is zero then this is the same as it being null
if @referto = 0 set @referto = null

declare @realStatus int
declare @datereferred datetime
declare @datecompleted datetime
declare @DateLocked datetime

select @realStatus = CASE @status WHEN 6 THEN 4 ELSE @status END
select @realStatus = CASE @status WHEN 8 THEN 3 ELSE @status END

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

-- Update the ThreadMod line for this moderation
-- make sure we don't overwrite any existing dates however
UPDATE ThreadMod
	SET	Status = @realStatus,
		Notes = @notes,
		DateLocked = isnull(@DateLocked, DateLocked),
		DateReferred = isnull(@datereferred, DateReferred),
		DateCompleted = isnull(@datecompleted, DateCompleted),
		LockedBy = CASE WHEN @realStatus = 2 THEN @referto ELSE LockedBy END,
		ReferredBy = CASE WHEN @realStatus = 2 THEN @referredby ELSE ReferredBy END
	WHERE ModID = @modid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


--Check to see if the post we're about to moderate is in the PreModPostings table.
--If so, we need to create the new threa entry and update the ThreadMod Table with the new entry id
IF EXISTS ( SELECT * FROM dbo.ThreadMod WITH(NOLOCK) WHERE ModID = @ModID AND IsPreModPosting = 1 )
BEGIN
	IF @realstatus = 3 OR @realstatus = 4 
	BEGIN
		--Only create a premod posting for a final moderation decision.
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
					'ComplainantsEmail' = @complainantsemail,
					'ComplainantID' = @complainantid, 
					'IsLegacy' = @islegacy,
					'PostID' = 0,
					'ThreadID' = 0
			RETURN @ErrorCode
		END
	END
	ELSE
	BEGIN
		-- Not a final mod decision - further processign not required.
		COMMIT TRANSACTION
			select	'AuthorsEmail' = @authorsemail,
					'AuthorID' = @authorid, 
					'ComplainantsEmail' = @complainantsemail,
					'ComplainantID' = @complainantid, 
					'IsLegacy' = @islegacy,
					'PostID' = 0,
					'ThreadID' = 0
			RETURN
	END
END

-- Check to make sure we we're passed a postid and threadid.
IF (@PostID = 0 OR @ThreadId = 0 OR @ForumId = 0)
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('moderatepostold - ThreadID = 0 OR PostID = 0 OR ForumId = 0',16,1)
	SELECT	'AuthorsEmail' = @authorsemail,
			'AuthorID' = @authorid, 
			'ComplainantsEmail' = @complainantsemail,
			'ComplainantID' = @complainantid, 
			'IsLegacy' = @islegacy,
			'PostID' = 0,
			'ThreadID' = 0
	RETURN 50000
END

select	@authorsemail = U.Email,
		@authorid = U.UserID,
		@complainantsemail = TM.CorrespondenceEmail,
		@complainantid = TM.ComplainantID, 
		@islegacy = case when TM.NewPost = 0 then 1 else 0 end
	from ThreadMod TM WITH(UPDLOCK)
		inner join ThreadEntries TE WITH(NOLOCK) on TE.EntryID = TM.PostID
		inner join Users U WITH(NOLOCK) on U.UserID = TE.UserID
	where TM.ModID = @ModID

declare @dummy int
select @dummy = ForumID from Forums WITH(UPDLOCK) WHERE ForumID = @forumid
declare @threadmod int
select @dummy = ThreadID, @threadmod = ISNULL(ModerationStatus,0) from Threads WITH(UPDLOCK) WHERE ThreadID = @threadid

-- Get the parent ID - if it's NULL this is the first post in a thread
declare @parent int, @newsubject varchar(255)  
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

DECLARE @siteid INT
DECLARE @newpost int
SELECT @siteid = siteid, @newpost = NewPost FROM ThreadMod WITH(NOLOCK) WHERE ModId = @modid

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
-- Now unhide the thread if necessary

IF @newpost = 0
BEGIN
	-- Unhide the thread if there are no more unmoderated posts in this thread
	-- and the thread contains at least one visible post
	IF NOT EXISTS (SELECT * FROM ThreadMod WHERE DateCompleted IS NULL AND ThreadID = @threadid) AND EXISTS (SELECT * FROM ThreadEntries WHERE ThreadID = @threadid AND (Hidden = 2 OR Hidden IS NULL))
	BEGIN
		UPDATE Threads
			SET VisibleTo = NULL
			WHERE ThreadID = @threadid	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ThreadEntries
		SET Hidden = NULL WHERE Hidden = 2 AND ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	END
END
ELSE
BEGIN
	-- Now see if we need to hide/unhide the whole thread
	IF EXISTS (SELECT * FROM ThreadEntries WITH(UPDLOCK) 
				WHERE threadid = @threadid AND Hidden IS NULL)
	BEGIN
		-- Make sure the thread is unhidden
		UPDATE Threads
			Set VisibleTo = NULL
			WHERE ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
	ELSE
	BEGIN
		IF (dbo.udf_getsiteoptionsetting(@siteid, 'Moderation', 'CloseThreadOnHideFirstPost') = 1)
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
END

COMMIT TRANSACTION

-- finally return the authors and complainants email addresses
-- also return if this was a legacy moderation or not
select	'AuthorsEmail' = @authorsemail,
		'AuthorID' = @authorid, 
		'ComplainantsEmail' = @complainantsemail,
		'ComplainantID' = @complainantid, 
		'IsLegacy' = @islegacy,
		'PostID' = @PostID,
		'ThreadID' = @ThreadID
