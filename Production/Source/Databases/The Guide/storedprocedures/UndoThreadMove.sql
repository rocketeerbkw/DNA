/*
	Undoes the move of a thread ot a different forum, also hiding the
	auto-posting that is made to the end of the thread. Returns info
	on the forums moved from and to.
*/

create procedure undothreadmove @threadid int, @postid int
as
declare @CurrentForumID int
declare @CurrentForumTitle nvarchar(255)
declare @OriginalForumID int
declare @OriginalForumTitle nvarchar(255)
declare @ThreadSubject nvarchar(255)
declare @Success bit
declare @postcount int, @negpostcount int
-- set to failure until we know we have succeeded
set @Success = 0
-- get the forum id and title for the old forum first
select	@OriginalForumID = T.MovedFrom,
		@ThreadSubject = T.FirstSubject,
		@CurrentForumID = T.ForumID,
		@CurrentForumTitle = F.Title,
		@postcount = ThreadPostCount,
		@negpostcount = -ThreadPostCount
from Threads T
inner join Forums F on F.ForumID = T.ForumID
where T.ThreadID = @threadid
-- if OriginalForumID is null then this thread was never moved, so we
-- can't continue with the procedure
if (@OriginalForumID is not null and @OriginalForumID != 0)
begin
	-- otherwise proceed with reversing the move
	-- get the title for the original forum we are moving back to
	select @OriginalForumTitle = Title
	from Forums
	where ForumID = @OriginalForumID

	BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	
	-- now do the move
	update ThreadEntries WITH(HOLDLOCK) set ForumID = @OriginalForumID where ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	update Threads set ForumID = @OriginalForumID, MovedFrom = null, LastUpdated = getdate() where ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	--update Forums set LastUpdated = getdate() where ForumID = @OriginalForumID or ForumID = @CurrentForumID
	INSERT INTO ForumLastUpdated(ForumID, LastUpdated)
		VALUES(@OriginalForumID, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO ForumLastUpdated(ForumID, LastUpdated)
		VALUES(@CurrentForumID, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	update ThreadPostings set ForumID = @OriginalForumID where ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	update ThreadMod set ForumID = @OriginalForumID where ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	-- hide the post saying the thread was moved, if it's id was provided
	if (@postid is not null and @postid != 0)
	begin
		update ThreadEntries set Hidden = 1 where EntryID = @postid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	end
	
	--Update the ForumPostCount for the current forum...
	EXEC updateforumpostcount @CurrentForumID, NULL, @postcount
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	-- ... and the original forum
	EXEC updateforumpostcount @OriginalForumID, NULL, @negpostcount
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	-- set the success variable to indicate all okay
	set @Success = 1
end
-- finally give a success field and some other data
select	'Success' = @Success,
		'ThreadSubject' = @ThreadSubject,
		'CurrentForumID' = @CurrentForumID,
		'CurrentForumTitle' = @CurrentForumTitle,
		'OriginalForumID' = @OriginalForumID,
		'OriginalForumTitle' = @OriginalForumTitle
return (0)
