/*
	Registers a users complaint about an article by inserting a new
	entry into the ArticleMod table.
*/

create procedure registerarticlecomplaint
	@complainantid int,
	@correspondenceemail varchar(255),
	@h2g2id int,
	@complainttext text,
	@hash uniqueidentifier,
	@ipaddress varchar(25) = null,
	@bbcuid uniqueidentifier = null 
as

declare @ErrorCode int
declare @ExecError int
declare @ModID int

-- check if the entry exists and what its status is
declare @SiteID int
declare @EntryID int
declare @AssetID int
declare	@MimeType varchar(255)

select @EntryID = GE.EntryID, @SiteID = GE.SiteID , @AssetID = AM.MediaAssetID, @MimeType = MA.MimeType
from GuideEntries GE
left join ArticleMediaAsset AM on AM.entryid = GE.entryid
left join MediaAsset MA on MA.ID = AM.MediaAssetID
where h2g2ID = @h2g2id
declare @status int
set @status = 0
if (@AssetID IS NOT NULL)
begin
	set @status = 2
end

-- insert the values into the article moderation table as long as the h2g2 ID exists
if (@EntryID is not null)
begin
	begin transaction
	
	-- if complainant ID is null then set it to zero
	set @complainantid = isnull(@complainantid, 0)
	
	BEGIN TRY

-- First see if we can insert the hash at all
	INSERT INTO ComplaintDuplicates (HashValue, DateCreated)
	VALUES(@hash, getdate())
	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRANSACTION
		SELECT ModId, 1 AS Duplicate FROM ComplaintDuplicates WHERE HashValue = @hash
		return(0)
	END

	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ModId, 1 AS Duplicate FROM ComplaintDuplicates WHERE HashValue = @hash
		return (0) -- This error is expected for duplicate complaints.
	END CATCH

	-- edited entries and help pages go straight to referrals queue
	-- but set LockedBy to UserID 1 in this case to avoid mysterious errors
	insert into ArticleMod (h2g2ID, DateQueued, Status, LockedBy, NewArticle, 
		ComplainantID, CorrespondenceEmail, ComplaintText, DateReferred,
		SiteID)
		values 
		(@h2g2id, getdate(), @status, null, 1, @complainantid, 
		@correspondenceemail, @complainttext, null,	@SiteID)
	select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
	-- capture the key value
	set @ModID = @@identity
	
	if @ipaddress IS NOT NULL
	BEGIN
		insert into ArticleModIPAddress (ArticleModID, IPAddress, BBCUID) VALUES (@ModID, @ipaddress, @bbcuid)
	END
	
	exec @ExecError = addarticlemodhistory @ModID, @status, 
		NULL, NULL, 0, NULL, 1, @complainantid, NULL;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if (@ErrorCode <> 0) goto HandleError;
	
	if (@status = 2)
	begin
	-- if article is referred then it should be hidden
		UPDATE GuideEntries WITH(HOLDLOCK)
			SET Hidden = 2, LastUpdated = getdate()
			WHERE h2g2ID = @h2g2id
		select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
		
		exec @ExecError = addarticlemodhistory @modid, NULL, 
			NULL, 2, 0, NULL, 5, null, null;
		select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
		if (@ErrorCode <> 0) goto HandleError;
		
		if (@AssetID IS NOT NULL)
		BEGIN
			UPDATE MediaAsset WITH(HOLDLOCK)
				SET Hidden = 2, LastUpdated = getdate()
				WHERE ID = @AssetID
			SELECT @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
		END
	end
	

	DECLARE @BanGroup INT
	SELECT @BanGroup = groupID FROM Groups WHERE NAME = 'BannedFromComplaining'
	if (@complainantid IN (SELECT UserID FROM GroupMembers WHERE GroupID = @BanGroup AND SiteID = @siteid) AND @ModID IS NOT NULL)
	BEGIN
		update ArticleMod SET DateLocked = getdate(), DateCompleted = getdate(), 
			Status = 3, Notes = 'Automatically processed', LockedBy = 6
			WHERE ModID = @ModID
		select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
		
		exec @ExecError = addarticlemodhistory @ModID, 0, 
			NULL, NULL, 1, 6, 4, NULL, NULL;
		select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
		if (@ErrorCode <> 0) goto HandleError;	
	END
	
	-- add event 
	EXEC addtoeventqueueinternal 'ET_COMPLAINTRECIEVED', @ModID, 'IT_MODID', @h2g2id, 'IT_H2G2', 0
	
	commit transaction
end

UPDATE ComplaintDuplicates SET ModId = @ModID WHERE hashvalue = @hash 

-- return the moderation ID of the column inserted
-- this will be null if something failed
select 'ModID' = @ModID, 'MediaAssetID' = @AssetID, 'MimeType' = @MimeType
return (0)

HandleError:
rollback transaction
return @ErrorCode
