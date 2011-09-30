/*
	Registers a users complaint about something offer than an article or posting.
*/

create procedure registergeneralcomplaint
	@complainantid int,
	@url varchar(255),
	@correspondenceemail varchar(255),
	@complainttext nvarchar(max),
	@siteid int,
	@hash uniqueidentifier,
	@ipaddress varchar(25) = null,
	@bbcuid uniqueidentifier = null
as
declare @ModID int
-- if complainant ID is null then set it to zero
set @complainantid = isnull(@complainantid, 0)
select @ModID = NULL
-- insert the data into the general moderation table
-- but only if URL is non-null
if (@url is not null)
begin

	BEGIN TRY
	-- First see if we can insert the hash at all
	INSERT INTO ComplaintDuplicates (HashValue, DateCreated)
	VALUES(@hash, getdate())
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT ModId, 1 AS Duplicate FROM ComplaintDuplicates WHERE HashValue = @hash
		return(0)
	END

	END TRY

	BEGIN CATCH
		SELECT ModId,1 AS Duplicate FROM ComplaintDuplicates WHERE HashValue = @hash
		return (0) -- This error is expected for duplicate complaints.
	END CATCH
	
	insert into GeneralMod (URL, DateQueued, Status, ComplainantID, CorrespondenceEmail, ComplaintText,SiteID)
	values (@url, getdate(), 0, @complainantid, @correspondenceemail, @complainttext,@siteid)
	-- capture the key value
	set @ModID = @@identity
	if @ipaddress IS NOT NULL
	BEGIN
		insert into GeneralModIPAddress (GeneralModID, IPAddress, BBCUID) VALUES(@ModID, @ipaddress, @bbcuid)
	END
	
	DECLARE @BanGroup INT
	SELECT @BanGroup = groupID FROM Groups WHERE NAME = 'BannedFromComplaining'
	if (@complainantid IN (SELECT UserID FROM GroupMembers WHERE GroupID = @BanGroup AND SiteID = @siteid) AND @ModID IS NOT NULL)
	BEGIN
	update GeneralMod SET DateLocked = getdate(), DateCompleted = getdate(), Status = 3, Notes = 'Automatically processed', LockedBy = 6
		WHERE ModID = @ModID
	END
	
	UPDATE ComplaintDuplicates SET ModId = @ModID WHERE hashvalue = @hash
end

-- add event 
EXEC addtoeventqueueinternal 'ET_COMPLAINTRECIEVED', @ModID, 'IT_MODID', @siteid, 'IT_SITE', 0

-- return the moderation ID of the column inserted, or null if something bad happened
select 'ModID' = @ModID
return (0)
