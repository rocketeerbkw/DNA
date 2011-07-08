Create Procedure copyguideentry @h2g2id int, @editor int
/*
Copy a guide entry, making the given editor the editor of the article
Superceding the entry appropriately
*/
As
RAISERROR('copyguideentry DEPRECATED',16,1)
return (0)
-- deprecated - do not use
declare @oldentryid int, @newentryid int, @oldeditor int

BEGIN TRANSACTION
DECLARE @ErrorCode INT

/* Get info on previous entry */
SELECT	@oldentryid = EntryID, 
		@oldeditor = Editor 
		FROM GuideEntries WITH(UPDLOCK)
		WHERE h2g2ID = @h2g2id
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @newid int

/* Copy the guide entry, changing the appropriate values */
INSERT INTO GuideEntries (blobid, text, BasedOn, Editor, ForumID, Subject, Keywords, Style, Status)
SELECT 0, text, @oldentryid, @editor, ForumID, Subject, Keywords, Style, 5
	FROM GuideEntries WITH(UPDLOCK) WHERE h2g2id = @h2g2id
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
SELECT @newentryid = @@IDENTITY


-- copy across the extrainfo. We need to use the 
DECLARE @sourcetextptr varbinary(16), 
		@targettextptr varbinary(16)

-- have to set the extrainfo to not null value for UPDATETEXT to work

update GuideEntries set ExtraInfo = ' ' where entryid = @newentryid

-- get the text pointers (and the new h2g2id)
DECLARE @newh2g2id INT
SELECT @sourcetextptr=TEXTPTR(ExtraInfo) FROM guideentries (UPDLOCK)
where entryid = @oldentryid
SELECT @targettextptr=TEXTPTR(ExtraInfo), @newh2g2id = h2g2id FROM guideentries (UPDLOCK)
where entryid = @newentryid

--overwrite the newentry extrainfo with the old one
if  @sourcetextptr IS NOT NULL AND @targettextptr IS NOT NULL
BEGIN
	UPDATETEXT guideentries.ExtraInfo @targettextptr 0 NULL WITH LOG guideentries.ExtraInfo @sourcetextptr 
END
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0
	RETURN @ErrorCode
END

/* Update the researchers list for this article */
INSERT INTO Researchers (EntryID, UserID) VALUES(@newentryid, @oldeditor)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Give old editor editing permissions on new article
INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, Priority, CanRead, CanWrite, CanChangePermissions) 
	SELECT @newh2g2id, TeamID, 1, 1, 1, 1 FROM Users WHERE UserId = @oldeditor

/* Set the h2g2 id of the guideentry */
declare @temp int, @checksum int
SELECT @temp = @newentryid, @checksum = 0
WHILE @temp > 0
BEGIN
	SELECT @checksum = @checksum + (@temp % 10)
	SELECT @temp = @temp  / 10
END
SELECT @checksum = @checksum % 10
SELECT @checksum = 9 - @checksum
SELECT @checksum = @checksum + (10 * @newentryid)

UPDATE GuideEntries SET h2g2ID = @checksum WHERE EntryID = @newentryid 
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

SELECT 'EntryID' = @newentryid, 'h2g2ID' = @checksum

return (0)