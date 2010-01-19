CREATE PROCEDURE makefrontpagelayoutactive @siteid int = 1
AS
BEGIN TRANSACTION
-- Get the EntryID from key articles
DECLARE @ErrorCode int
DECLARE @EntryID int

EXEC getkeyarticleentryid 'xmlfrontpagepreview', @siteid, @EntryID OUTPUT
SET @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--create a new guide entry for the live version and get the entryid

DECLARE @NewEntryID int
EXEC @ErrorCode = CreateDuplicateGuideEntryInternal @EntryID, @NewEntryID OUTPUT
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


-- copy the preview entry to a frontpage 'active' entry

INSERT INTO KeyArticles (ArticleName, EntryID, DateActive, SiteID, EditKey)
VALUES ('xmlfrontpage', @NewEntryID, GETDATE(), @siteid, NEWID())


SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

---

COMMIT TRANSACTION


