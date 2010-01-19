/*
	Submits a subbed entry, i.e. returns it to staff only control.
	Query checks that the user ID provided is that of the sub for this
	entry, that the entry is indeed a subs copy of a recommended entry,
	and that the recommendation has the correct status and returns error
	information if not.
*/

create procedure submitreturnedsubbedentry
	@userid int,
	@entryid int,
	@comments text = null
as
declare @InvalidEntry bit
declare @UserNotSub bit
declare @WrongStatus bit
declare @Success bit
declare @DateReturned datetime
declare @SubID int
declare @AllocatorID int
declare @Status int
-- set default values for return variables
set @InvalidEntry = 0
set @UserNotSub = 0
set @WrongStatus = 0
set @Success = 0
-- first check that the entry has not already been returned
-- get the details we need about this recommendation
select	@SubID = SubEditorID,
		@AllocatorID = AllocatorID,
		@DateReturned = DateReturned,
		@Status = Status
	from AcceptedRecommendations
	where EntryID = @entryid

-- then check to see if anything is wrong
if (@Status is null or @Status = 0)
begin
	-- entry is not even an accepted recommendation
	set @InvalidEntry = 1
end
if (@SubID != @userid)
begin
	-- submitting user is not the sub for this entry
	set @UserNotSub = 1
end
-- if the status is right and this is the correct user then go ahead with the submission
if (@Status = 2 and @SubID = @userid)
begin

	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	-- update the state of the recommendation
	update AcceptedRecommendations
		set DateReturned = getdate(), Status = 3, Comments = isnull(@comments, Comments)
		where EntryID = @entryid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- then update the state of the entry itself
	-- status = 6 for 'Waiting for approval', leave sub as the editor
	update GuideEntries
		set Status = 6
		where EntryID = @entryid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- add to the edit history
	insert into EditHistory (EntryID, UserID, DatePerformed, Action, Comment)
		values (@entryid, @userid, getdate(), 17, 'Returned by Sub Editor')
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	-- set success
	set @Success = 1
end
else
begin
	-- if something wrong then set failure
	set @Success = 0
end
-- return fields indicating the status of the submission
select	'Success' = @Success,
	'InvalidEntry' = @InvalidEntry,
	'UserNotSub' = @UserNotSub,
	'RecommendationStatus' = @Status,
	'DateReturned' = @DateReturned
return (0)
