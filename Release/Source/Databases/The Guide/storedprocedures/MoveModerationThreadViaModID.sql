/*
	This procedure is used to move moderation threads into different forums.
	It will also take into account premod posting threads. These do not exist in the threads
	table untill they are passed or failed, so extra the premodposting table is updated.

	This procedure will return non transactional errors via the return value.
	The errors are as follows...

	0 - No Error
	1 - Failed to find old forum
	2 - New forum is the same as the old
	3 - Failed to find the new forum
*/
CREATE PROCEDURE movemoderationthreadviamodid @threadmodid int, @forumid int
AS
-- Get the current details for thread
DECLARE @IsPreModPosting INT
DECLARE @OldForumID INT
DECLARE @OldForumTitle NVARCHAR(255)
DECLARE @ThreadID INT

-- Start by getting the current details
SELECT	@IsPreModPosting = tm.IsPreModPosting,
		@OldForumTitle = f.Title,
		@OldForumID = f.ForumID,
		@ThreadID = tm.ThreadID
	FROM dbo.ThreadMod tm WITH(NOLOCK)
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = tm.ForumID
		LEFT JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = tm.ThreadID
	WHERE tm.ModID = @threadmodid

-- Check we got valid details
IF (ISNULL(@OldForumID,0) = 0)
BEGIN
	-- Failed to find the moderation item
	RETURN -1
END

-- Check to see if we're doing something daft
IF (@OldForumID = @forumid)
BEGIN
	-- Why move to the same forum?
	RETURN -2
END

-- Now get the new forum details
DECLARE @NewForumTitle NVARCHAR(255)
DECLARE @CanRead INT
DECLARE @CanWrite INT
SELECT	@NewForumTitle = Title,
		@CanRead = ThreadCanRead,
		@CanWrite = ThreadCanWrite
	FROM dbo.Forums WITH(NOLOCK)
		WHERE ForumID = @forumid

-- Check to make sure we get just the one row back
IF (@@ROWCOUNT <> 1)
BEGIN
	-- The new forum does not exist, or there's more than one!
	RETURN -3
END

-- Do the following in a try catch as it saves checking after each transactional statement
BEGIN TRY

BEGIN TRANSACTION

-- Start by updating the threadmod/threadmodold table as this is global to both premod and non premod posts
DECLARE @ErrorCode INT
UPDATE dbo.ThreadMod SET ForumID = @forumid WHERE ModID = @threadmodid
UPDATE dbo.ThreadModOld SET ForumID = @forumid WHERE ModID = @threadmodid

-- Now see what we're dealing with
DECLARE @ThreadSubject NVARCHAR(255)
IF (@IsPreModPosting > 0)
BEGIN
	-- All we need to do is change the forumid in the premodposting. The post does not exist yet
	UPDATE dbo.PreModPostings SET ForumID = @forumid WHERE ModID = @threadmodid

	-- Get the subject from the premodtable for the thread
	SELECT @ThreadSubject = CASE WHEN ISNULL(pmp.ThreadID,0) = 0 THEN pmp.Subject ELSE t.FirstSubject END
		FROM dbo.PreModPostings pmp WITH(NOLOCK)
			LEFT JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = pmp.ThreadID
			WHERE pmp.ModID = @threadmodid
END
ELSE
BEGIN
	-- Ok, we need to update forums post counts and the threads can read/write details
	-- as well as updating the mod table.
	DECLARE @AddThreadPostCount INT
	DECLARE @RemoveThreadPostCount INT
	SELECT 	@AddThreadPostCount = ThreadPostCount,
			@RemoveThreadPostCount = -ThreadPostCount,
			@ThreadSubject = FirstSubject
		FROM dbo.Threads WITH(NOLOCK)
			WHERE ThreadID = @ThreadID

	-- Check to see if we're moving the the thread to the junk forum
	IF (@forumid = 1)
	BEGIN
		-- Send to junk forum
		UPDATE dbo.Threads SET ForumID = @forumid, MovedFrom = @OldForumID, LastUpdated = GETDATE(), VisibleTo = 1, CanRead = @CanRead, CanWrite = @CanWrite WHERE ThreadID = @ThreadID

		-- Update the threa entry table
		UPDATE dbo.ThreadEntries SET ForumID = @forumid, Hidden = 5 WHERE ThreadID = @ThreadID AND Hidden IS NULL

		-- Delete the post from the thread postings table
		DELETE FROM dbo.ThreadPostings WHERE ThreadID = @ThreadID
	END
	ELSE
	BEGIN
		-- Check to see if we're moving from the junk forum
		IF (@OldForumID = 1)
		BEGIN
			UPDATE dbo.ThreadEntries SET Hidden = NULL WHERE ThreadID = @ThreadID AND Hidden = 5
			IF (@@ROWCOUNT > 0)
			BEGIN
				UPDATE dbo.Threads SET VisibleTo = NULL WHERE ThreadID = @ThreadID
			END
		END

		-- Update the thread entries
		UPDATE dbo.ThreadEntries SET ForumID = @forumid WHERE ThreadID = @ThreadID

		-- Set the correct permissions for the thread
		UPDATE dbo.Threads SET ForumID = @forumid, MovedFrom = @OldForumID, LastUpdated = GETDATE(), CanRead = @CanRead, CanWrite = @CanWrite WHERE ThreadID = @ThreadID

		-- Update the threadpostings with the new forumid
		UPDATE dbo.ThreadPostings SET ForumID = @forumid WHERE ThreadID = @ThreadID
	END

	-- Add entries for both forums in the forum last updated table
	INSERT INTO dbo.ForumLastUpdated (ForumID, LastUpdated) VALUES (@forumid, GETDATE())
	INSERT INTO dbo.ForumLastUpdated (ForumID, LastUpdated)	VALUES (@OldForumID, GETDATE())

	-- Update the new and old forum counts
	EXEC updateforumpostcount @OldForumID, NULL, @RemoveThreadPostCount
	EXEC updateforumpostcount @forumid, NULL, @AddThreadPostCount
END

COMMIT TRANSACTION

END TRY

-- Did we catch any errors?
BEGIN CATCH
	SELECT @ErrorCode = ERROR_NUMBER()
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END CATCH

-- Return the results of the move
SELECT	'OldForumID' = @OldForumID,
		'OldForumTitle' = @OldForumTitle,
		'NewForumID' = @forumid,
		'NewForumTitle' = @NewForumTitle,
		'IsPreModPosting' = @IsPreModPosting,
		'ThreadSubject' = ISNULL(@ThreadSubject,''),
		'ThreadID' = ISNULL(@ThreadID,0)