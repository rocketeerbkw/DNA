/*
	Registers a users complaint about a posting by inserting a new
	entry into the ThreadMod table.
*/

create procedure registerpostingcomplaint
	@complainantid int,
	@correspondenceemail varchar(255),
	@postid int,
	@complainttext text,
	@hash uniqueidentifier,
	@ipaddress varchar(25) = null,
	@bbcuid uniqueidentifier = null
as
if @postid = 22139334
BEGIN
select 'ModID' = 0
return(0)
END


-- if complainant ID is null then set it to zero
set @complainantid = isnull(@complainantid, 0)
-- fetch the correct values for ThreadID, SiteID and ForumID
declare @ThreadID int, @ForumID int, @ModID int, @SiteID int
select @ThreadID = ThreadID, @ForumID = ForumID
from ThreadEntries
where EntryID = @PostID

--get SiteID
select @SiteID = SiteID from Forums where ForumID = @ForumID

set @ModID = NULL

-- insert the data into the thread moderation table if we have sensible values for the post, thread and forum IDs
if (@PostID > 0 and @ThreadID > 0 and @ForumID > 0)
begin
	-- First see if we can insert the hash at all
	BEGIN TRY
		INSERT INTO ComplaintDuplicates (HashValue, DateCreated)
		VALUES(@hash, getdate())
		IF @@ROWCOUNT = 0
		BEGIN
			SELECT ModId, 1 AS Duplicate FROM ComplaintDuplicates WHERE HashValue = @hash
			return(0)
		END
	END TRY

	BEGIN CATCH
		SELECT ModId, 1 AS Duplicate FROM ComplaintDuplicates WHERE HashValue = @hash
		return (0) -- This error is expected for duplicate complaints.
	END CATCH
	
	
	DECLARE @lockedby INT
	select @ModID = ModId FROM ThreadMod where PostID = @postid AND status=0 AND complainantid IS NULL AND lockedby IS NULL
	IF @ModID IS NOT NULL
	BEGIN
		--Remove unprocessed item due to complaint.
		update ThreadMod SET DateLocked = getdate(), DateCompleted = getdate(), Status = 3, Notes = 'Automatically processed - item has a complaint.', LockedBy = 6
		where ModId = @ModID
	END
	
	DECLARE @spooferDetected int
	SET @spooferDetected = 0
	IF @complainantid = 0 AND PATINDEX('%@bbc.co.uk%',@correspondenceemail) > 0
	BEGIN
		SET @correspondenceemail=REPLACE(@correspondenceemail,'@bbc.co.uk','@spoofedbbc.co.uk')
		SET @spooferDetected = 1
	END


	--Add New Moderation item to queue.
	insert into ThreadMod (PostID, ThreadID, ForumID, DateQueued, Status, 
							NewPost, ComplainantID, CorrespondenceEmail, 
							ComplaintText, SiteID )
	values (@PostID, @ThreadID, @ForumID, getdate(), 0, 1, @complainantid, 
				@correspondenceemail, @complainttext, @SiteID )
	-- capture the key value
	set @ModID = @@identity
	if @ipaddress IS NOT NULL
	BEGIN
		insert into ThreadModIPAddress (ThreadModID, IPAddress, BBCUID) VALUES(@ModID, @ipaddress, @bbcuid)
	END

	IF @spooferDetected=1
	BEGIN
		update ThreadMod SET Notes='Changed email address to end in @spoofedbbc.co.uk as it is suspicious' where Modid=@ModID
	END
	
	-- add event 
	EXEC addtoeventqueueinternal 'ET_COMPLAINTRECIEVED', @ModID, 'IT_MODID', @PostID, 'IT_POST', 0
END

DECLARE @BanGroup INT
SELECT @BanGroup = groupID FROM Groups WHERE NAME = 'BannedFromComplaining'
if (@complainantid IN (SELECT UserID FROM GroupMembers WHERE GroupID = @BanGroup AND SiteID = @siteid) AND @ModID IS NOT NULL)
BEGIN
update ThreadMod SET DateLocked = getdate(), DateCompleted = getdate(), Status = 3, Notes = 'Automatically processed - user banned from complaining.', LockedBy = 6
	WHERE ModID = @ModID
END

UPDATE ComplaintDuplicates SET ModId = @ModID WHERE hashvalue = @hash

-- return the moderation ID of the column inserted
select 'ModID' = @ModID
return (0)
