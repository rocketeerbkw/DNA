CREATE PROCEDURE createduplicateguideentryinternal @entryid int, @newentryid int OUTPUT
AS

/*
	IMPORTANT!!!
	This Stored procedure should never be called directly as it doesn't do any TRANSACTION calls!
	Make sure the calling procedure calls this within BEGIN / COMMIT TRANSACTION calls
*/
IF (@@TRANCOUNT = 0)
BEGIN
	RAISERROR ('CreateDuplicateGuideEntryInternal cannot be called outside a transaction!!!',16,1)
	RETURN 50000
END

DECLARE @ErrorCode int

-- get the subject and keywords for creating a new forum
DECLARE @subject varchar(255)
DECLARE @keywords varchar(255)
DECLARE @SiteID int
DECLARE @Editor int

Select @subject = Subject, @keywords = Keywords, @SiteID = SiteID, @Editor = Editor 
FROM GuideEntries WHERE EntryID = @entryid

-- create a new forum entry for the 
DECLARE @ForumID int

INSERT INTO Forums (Title, keywords, SiteID, ForumStyle) VALUES(@subject, @keywords, @siteid, 0)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
	RETURN @ErrorCode

SELECT @ForumID = @@IDENTITY


-- generate a new guideentry
INSERT INTO GuideEntries(ExtraInfo, blobid, text, Editor, ForumID, Subject, Keywords,  
Style, Status, Hidden, SiteID, Submittable, Type, DateCreated,
PreProcessed, CanRead, CanWrite, CanChangePermissions)
(
	SELECT g2.ExtraInfo, g2.blobid, g2.text, g2.Editor, @ForumID, g2.Subject, g2.Keywords, 
	g2.Style, g2.Status, g2.Hidden, g2.SiteID, g2.Submittable, g2.Type, GETDATE(),
	g2.PreProcessed, g2.CanRead, g2.CanWrite, g2.CanChangePermissions
	FROM GuideEntries g2 WHERE g2.EntryID = @entryid
)

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
	RETURN @ErrorCode


SELECT @newentryid = @@IDENTITY

-- generate the h2g2id 
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


-- add the h2g2id
UPDATE GuideEntries SET h2g2ID = @checksum 
WHERE EntryID = @newentryid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
	RETURN @ErrorCode

-- Lastly, make sure the editor is given edit permissions
INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, Priority, CanRead, CanWrite, CanChangePermissions) 
	SELECT @checksum, TeamID, 1, 1, 1, 1 FROM UserTeams WHERE UserId = @Editor AND SiteID = @siteid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
	RETURN @ErrorCode

return 0