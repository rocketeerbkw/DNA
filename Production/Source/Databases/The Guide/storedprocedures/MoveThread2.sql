/*
	Move a thread to a new forum and return info on the forums
	moved from and to.
	If junking a thread (i.e. moving it to forum no. 1) then make sure
	all its posts are hidden and deleted from the ThreadPostings table.
*/

create procedure movethread2 @threadid int, @forumid int
as
declare @OldForumID int
declare @OldForumTitle nvarchar(255)
declare @NewForumTitle nvarchar(255)
declare @ThreadSubject nvarchar(255)
declare @Success bit
declare @rowcount int
declare @canread int, @canwrite int
declare @postcount int, @negpostcount int
-- default to failed
set @Success = 0

BEGIN TRANSACTION
DECLARE @ErrorCode INT

-- get the forum id and title for the old forum first
select	@ThreadSubject = T.FirstSubject,
		@OldForumID = T.ForumID,
		@OldForumTitle = F.Title,
		@postcount = ThreadPostCount,
		@negpostcount = -ThreadPostCount
	from Threads T WITH(UPDLOCK) inner join Forums F WITH(UPDLOCK) on F.ForumID = T.ForumID
	where T.ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- then get the title for the new forum along with the new read and write permissions
select @NewForumTitle = Title, @canread = ThreadCanRead, @canwrite = ThreadCanWrite from Forums WITH(UPDLOCK) where ForumID = @forumid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
-- TODO - make moving threads activate the ThreadPosting and FaveForums 
-- TODO - make unhiding reveal ordinary posts
-- if forum IDs are different then do the move
if (@forumid <> @OldForumID)
begin
	if (@forumid = 1)
	begin
		-- if sending to junk forum make sure all posts are hidden as well
		-- as moved, and are removed from the ThreadPostings table
		update Threads set ForumID = @forumid, MovedFrom = @OldForumID, LastUpdated = getdate(), VisibleTo = 1, CanRead = @canread, CanWrite = @canwrite where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		update ThreadEntries set ForumID = @forumid, Hidden = 5 where ThreadID = @threadid AND Hidden IS NULL
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
			VALUES (@forumid, getdate())
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
			VALUES (@oldforumid, getdate())
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END


		delete from ThreadPostings where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		update ThreadMod set ForumID = @forumid where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		update ThreadModOld set ForumID = @forumid where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	end
	else
	begin
		if (@OldForumID = 1)
		begin
			update ThreadEntries set Hidden = NULL WHERE ThreadID = @threadid AND Hidden = 5
			SELECT @ErrorCode = @@ERROR, @rowcount = @@ROWCOUNT
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END
			if @rowcount > 0
			begin
				update Threads set VisibleTo = NULL where ThreadID = @threadid 
				SELECT @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					EXEC Error @ErrorCode
					RETURN @ErrorCode
				END
			end
		end
		-- otherwise just do a move
		update ThreadEntries set ForumID = @forumid where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		update Threads set ForumID = @forumid, MovedFrom = @OldForumID, LastUpdated = getdate(), CanRead = @canread, CanWrite = @canwrite where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
			VALUES (@forumid, getdate())
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
			VALUES (@oldforumid, getdate())
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		update ThreadPostings set ForumID = @forumid where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		update ThreadMod set ForumID = @forumid where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		update ThreadModOld set ForumID = @forumid where ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	end
	set @Success = 1
end

--Update the ForumPostCount in both the old...
EXEC updateforumpostcount @OldForumID, NULL, @negpostcount
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--- ...and the new forums
EXEC updateforumpostcount @forumid, NULL, @postcount
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

-- finally give a success field and some other data
-- success will be zero forum IDs were the same
select	'Success' = @Success,
		'ThreadSubject' = @ThreadSubject,
		'OldForumID' = @OldForumID,
		'OldForumTitle' = @OldForumTitle,
		'NewForumID' = @forumid,
		'NewForumTitle' = @NewForumTitle
return (0)
