/*
	Inserts this article into the queue for moderation as a new article.
*/

create procedure queuearticleformoderation @h2g2id int, @triggerid int,
	@triggeredby int,  @notes varchar(2000), @modid int out
as
declare @Status int, @NewEntry int
declare @DateQueued datetime
declare @OldNotes varchar(2000)

-- find out if this entry is already queued and not locked and not a complaint
select top 1 @ModID = ModID, @Status = Status, @OldNotes = Notes, @NewEntry = NewArticle, 
				@DateQueued = DateQueued
from ArticleMod
where	h2g2ID = @h2g2id and Status = 0 and LockedBy is null 
		and ComplainantID is null
order by DateQueued asc, ModID asc

DECLARE @ErrorCode INT
declare @ExecError int

BEGIN TRANSACTION

-- if already queued then update this entry
if (@ModID is not null)
begin
	-- prepend the date to the new notes
	-- then append the new notes if there is room for them
	set @notes = char(13) + char(10) + cast(getdate() as varchar(25)) + ': ' + left(@notes, 1970)
	set @notes = @OldNotes + left(@notes, 2000 - len(@OldNotes))
	-- if the moderation we are updating is a legacy one, then reset the
	-- DateQueued so that it doesn't leap to the head of the queue
	if (@NewEntry = 0) set @DateQueued = getdate()
	-- update the notes field and the DateQueued and set as a NewArticle
	update ArticleMod set Notes = @notes, DateQueued = @DateQueued, NewArticle = 1
		where ModID = @ModID
	select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;	
	exec @ExecError = addarticlemodhistory @ModID, NULL, 
		NULL, NULL, 0, NULL, @triggerid, @triggeredby, @notes;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if (@ErrorCode <> 0) goto HandleError;
end
else
begin
	-- find out if this entry is referred and not locked and not 
	-- a complaint and move it from referrals queue 
	select @ModID = ModId, @OldNotes = notes from ArticleMod where h2g2ID = @h2g2id 
		and Status = 2 and LockedBy is null and ComplainantID is null;
	if (@ModID <> null)
	begin
		-- prepend the date to the new notes
		-- then append the new notes if there is room for them
		set @notes = char(13) + char(10) + cast(getdate() as varchar(25)) + ': ' + left(@notes, 1970)
		set @notes = @OldNotes + left(@notes, 2000 - len(@OldNotes))
		update ArticleMod set status = 0, notes = @notes, newarticle = 1
			where ModId = @ModID;
		select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
		
		exec @ExecError = addarticlemodhistory @ModID, 0, 
			NULL, NULL, 0, NULL, @triggerid, @triggeredby, @notes;
		select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
		if (@ErrorCode <> 0) goto HandleError;	
	end			
	else
	begin
		-- insert a new entry as long as the h2g2ID exists
		if exists (select h2g2id from GuideEntries where h2g2ID = @h2g2id)
		begin
			declare @SiteID int
			select @SiteID = ge.SiteID from GuideEntries ge where ge.h2g2ID = @h2g2id
			insert into ArticleMod (h2g2ID, DateQueued, Status, Notes, NewArticle, SiteID)
				values (@h2g2id, getdate(), 0, @notes, 1, @SiteID)
			select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
			select @ModID = @@identity
			
			exec @ExecError = addarticlemodhistory @ModID, 0, 
				NULL, NULL, 0, NULL, @triggerid, @triggeredby, @notes;
			select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
			if (@ErrorCode <> 0) goto HandleError;	
		end
	end
end

COMMIT TRANSACTION

-- return the ModID (will be null if something went wrong)
select 'ModID' = @ModID
return (0)

HandleError:
rollback transaction
return @errorcode


