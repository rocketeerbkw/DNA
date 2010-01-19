/*
	Updates the subject and/or text of a forum posting
*/

create procedure updatepostdetails @userid int, @postid int, @subject nvarchar(255), 
										@text nvarchar(max), @eventdate varchar(64) = NULL, @setlastupdated tinyint, @forcemoderateandhide tinyint,
										@ignoremoderation tinyint
as

-- do as a transaction since potentially more than one user might be attempting
-- to update the same post
begin transaction
DECLARE @ErrorCode INT

declare @CurrentDate datetime
set @CurrentDate = getdate()

declare @ForumID int
declare @ThreadID int
declare @parentid int
declare @siteid int
declare @oldsubject nvarchar(255)

-- find required info
select	@ForumID = te.ForumID,
		@ThreadID = te.ThreadID,
		@parentid = te.Parent,
		@oldsubject = te.Subject,
		@siteid = f.siteid
	from ThreadEntries te WITH(UPDLOCK)
	INNER JOIN Forums f ON te.forumid = f.forumid
	where EntryID = @postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @premoderation int, @unmoderated int
if (@ignoremoderation = 1)
BEGIN
		-- ignore moderation (usually because it's being updated by an editor)
		SELECT @premoderation = 0, @unmoderated = 1
		SET @forcemoderateandhide = 0
END
ELSE
BEGIN
	EXEC getmodstatusforforum @userid,@threadid,@forumid,@siteid,@premoderation OUTPUT, @unmoderated OUTPUT

	-- If we're forcing moderation, then make sure unmoderated = 0
	if (@forcemoderateandhide = 1)
	BEGIN
		SELECT @unmoderated = 0
	END
END

-- save the old details
INSERT INTO ThreadEditHistory (OldSubject, blobid, text, DateEdited, ForumID, ThreadID, EntryID)
	SELECT @oldsubject, 0, t.text, @CurrentDate, @ForumID, @ThreadID, @postid
	FROM ThreadEntries t WHERE t.EntryID=@postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- update the subject in the ThreadEntries table
update ThreadEntries
	set Subject = @subject, 
	text = @text,
	LastUpdated = CASE WHEN @setlastupdated = 1 THEN getdate() ELSE LastUpdated END,
	Hidden = CASE WHEN (@premoderation = 1 OR @forcemoderateandhide = 1) THEN 3 ELSE Hidden END
	where EntryID = @postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- update the LastUpdated field in the Threads table
update Threads
	set LastUpdated = @CurrentDate,
	EventDate = ISNULL(@eventdate,EventDate)
	where ThreadID = @ThreadID
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- update the LastUpdated field in the Forum table also
--update Forums
--	set LastUpdated = @CurrentDate
--	where ForumID = @ForumID
INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
	VALUES(@forumid, @currentdate)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

IF @parentid IS NULL
BEGIN
	-- update the FirstSubject field in the Thread table also
	update Threads
		set FirstSubject = CASE WHEN @premoderation = 1 THEN '' ELSE @subject END,
		VisibleTo = CASE WHEN @premoderation = 1 THEN 1 ELSE NULL END
		where ThreadID = @ThreadID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

IF (@unmoderated = 0)
BEGIN
	INSERT INTO ThreadMod (ForumID, ThreadID, PostID, Status, NewPost, SiteID)
		VALUES(@forumid, @threadid, @postid, 0, 1, @siteid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END


-- commit the entire transaction
commit transaction

-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
EXEC addtoeventqueueinternal 'ET_FORUMEDITED', @ForumID, 'IT_FORUM', @postid, 'IT_POST', @userid

return (0)
