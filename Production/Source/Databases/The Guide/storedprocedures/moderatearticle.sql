CREATE PROCEDURE moderatearticle @h2g2id int, @modid int, @status int, 
	@notes varchar(2000), @referto int, @referredby int
As
-- if @referto is zero then this is the same as it being null
if @referto = 0 set @referto = null

DECLARE @realStatus INT
DECLARE @datereferred datetime
DECLARE @datecompleted datetime
DECLARE @DateLocked datetime
DECLARE @RefModID INT
DECLARE @OldNotes VARCHAR(2000)
DECLARE @ErrorCode INT
declare @ExecError int

select @realStatus = CASE @status WHEN 6 THEN 4 ELSE @status END

IF @realStatus = 2
BEGIN
	SELECT @datereferred = getdate()
	SELECT @datecompleted = NULL
	SELECT @DateLocked = getdate()
END
ELSE IF @realStatus = 0
BEGIN
	SELECT @datereferred = NULL, @datecompleted = NULL
	select @DateLocked = null
END
ELSE
BEGIN
	select @DateLocked = null
	SELECT @datereferred = NULL
	SELECT @datecompleted = getdate()
END

BEGIN TRANSACTION

--check if moderation item is referred 
IF @realStatus = 2 AND @referto IS NOT NULL
BEGIN
	--check if referee already has this record referred to him
	SELECT top 1 @RefModID = ModID, @OldNotes = Notes
		FROM ArticleMod
		WHERE h2g2ID = @h2g2ID AND Status = 2 AND ComplainantID is null
			AND LockedBy = @referto

	--if referee already has this record then update it's notes and remove 
	--original record from moderation table
	IF @RefModID IS NOT NULL
	BEGIN
		--set the notes
		declare @NewNotes varchar(2000)
		set @NewNotes = @notes;
		SET @Notes = CHAR(13) + CHAR(10) + 'Referred: ' + CAST(getdate() AS VARCHAR(25)) + CHAR(13) + CHAR(10) + '[' + LEFT(@Notes, 1960)
		SET @Notes = @OldNotes + LEFT(@Notes, 1999 - LEN(@OldNotes)) + ']'
		UPDATE ArticleMod SET Notes = @Notes WHERE ModID = @RefModID
		select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;	
		exec @ExecError = addarticlemodhistory @modid, NULL, 
			NULL, NULL, 0, NULL, 0, @referredby, @NewNotes;
		select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
		if (@ErrorCode <> 0) goto HandleError;
	
		--remove original record if it is not the same as found one (happens when
		--referee refers item to himself
--		IF @ModID <> @RefModID
--		BEGIN
--			DELETE FROM ArticleMod WHERE ModID = @ModID
--			select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
--
--			SELECT @ModID = @RefModID
--		END
	END
END

--update original record only if this is not the case when
--it is referred to person who already has this article moderation item referred to him
IF @RefModID IS NULL
BEGIN
	-- make sure we don't overwrite any existing dates when moderating an item
	UPDATE ArticleMod
		SET	Status = @realStatus,
			Notes = @notes,
			DateLocked = isnull(@DateLocked, DateLocked),
			DateReferred = isnull(@datereferred, DateReferred),
			DateCompleted = isnull(@datecompleted, DateCompleted),
			LockedBy = CASE WHEN @realStatus = 2 THEN @referto ELSE LockedBy END,
			ReferredBy = CASE WHEN @realStatus = 2 THEN @referredby ELSE ReferredBy END
		WHERE ModID = @modid
	select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
	
	declare @LockedBy int
	declare @LockedByChanged bit
	select @LockedBy = CASE WHEN @realStatus = 2 THEN @referto ELSE null END;
	select @LockedByChanged = CASE WHEN @realStatus = 2 THEN 1 ELSE 0 END;
	exec @ExecError = addarticlemodhistory @modid, @realStatus, 
		NULL, NULL, @LockedByChanged, @LockedBy, 0, @referredby, @notes;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if (@ErrorCode <> 0) goto HandleError;
END

-- if article is referred then it should be hidden
IF  @realStatus = 2
BEGIN
	UPDATE GuideEntries WITH(HOLDLOCK)
		SET Hidden = 2, LastUpdated = getdate()
		WHERE h2g2ID = @h2g2id
	select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;

	UPDATE dbo.Forums 
	   SET CanWrite = 0, 
		   CanRead = 0 
	  FROM dbo.Forums f
		   INNER JOIN dbo.GuideEntries ge on ge.ForumID = f.ForumID
	 WHERE ge.h2g2ID = @h2g2ID;

	select @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;

	exec @ExecError = addarticlemodhistory @modid, NULL, 
		NULL, 2, 0, NULL, 5, @referredby, null;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if (@ErrorCode <> 0) goto HandleError;
END
-- if article if failed however then it should be deleted *and also hidden*
-- otherwise personal spaces don't get hidden when failed
-- For accept-and-edit mode do nothing with the article
IF  @realStatus = 4 AND @status <> 6
BEGIN
	UPDATE GuideEntries
		SET Hidden = 1, LastUpdated = getdate()
		WHERE h2g2ID = @h2g2id
	SELECT @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
	
	UPDATE dbo.Forums 
	   SET CanWrite = 0, 
		   CanRead = 0
	  FROM dbo.Forums f
	 INNER JOIN dbo.GuideEntries ge on ge.ForumID = f.ForumID
	 WHERE ge.h2g2ID = @h2g2ID;
	 
	 DECLARE @forumid INT
	 SELECT @forumid = forumid
	 FROM GuideEntries ge WHERE ge.h2g2ID = @h2g2id
	 
	 INSERT INTO ForumLastUpdated (ForumID, LastUpdated) 
		VALUES(@forumid, getdate())
	 
	 UPDATE Threads 
	    SET CanWrite = 0,
	    LastUpdated = getdate()
	    FROM Threads th
	    WHERE th.forumid = @forumid

	exec @ExecError = addarticlemodhistory @modid, NULL, 
		NULL, 2, 0, NULL, 7, @referredby, NULL;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if (@ErrorCode <> 0) goto HandleError;
END
-- if passed then ensure that the article is unhidden
IF @realStatus = 3
BEGIN
	UPDATE GuideEntries
		SET Hidden = NULL, LastUpdated = getdate()
		WHERE h2g2ID = @h2g2id AND Hidden IS NOT NULL
	SELECT @ErrorCode = @@ERROR; if (@ErrorCode <> 0) goto HandleError;
	
	UPDATE dbo.Forums 
	   SET CanWrite = 1, 
		   CanRead = 1
	 FROM dbo.Forums f
	 INNER JOIN dbo.GuideEntries ge on ge.ForumID = f.ForumID
	 WHERE ge.h2g2ID = @h2g2ID;
	 
	 SELECT @forumid = forumid
	 FROM GuideEntries ge WHERE ge.h2g2ID = @h2g2id
	 
	 INSERT INTO ForumLastUpdated (ForumID, LastUpdated) 
		VALUES(@forumid, getdate())
	 
	 UPDATE Threads 
	 SET CanWrite = 1,
	 LastUpdated = getdate()
	 FROM Threads th
	 WHERE th.forumid = @forumid
	    
	exec @ExecError = addarticlemodhistory @modid, NULL, 
		NULL, 3, 0, NULL, 6, @referredby, NULL;
	select @ErrorCode = @@ERROR; if @ErrorCode = 0 select @ErrorCode = @ExecError
	if (@ErrorCode <> 0) goto HandleError;
END

COMMIT TRANSACTION

-- return the email addresses and IDs of the author and the complainant, if any
-- also return if this was a legacy moderation or not
select	U.Email as AuthorsEmail,
		U.UserID as AuthorID,
		AM.CorrespondenceEmail as ComplainantsEmail,
		AM.ComplainantID,
		case when AM.NewArticle = 0 then 1 else 0 end as IsLegacy,
		G.Status as EntryStatus
	from ArticleMod AM
		inner join GuideEntries G on G.h2g2ID = AM.h2g2ID
		inner join Users U on U.UserID = G.Editor
	where AM.ModID = @ModID
	
return 0

HandleError:
rollback transaction
return @errorcode

