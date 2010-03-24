CREATE PROCEDURE updatefrontpagepreview
@bodytext varchar(max), 
@siteid int,
@editor int, 
@extrainfo text,
@editkey uniqueidentifier = NULL

AS
BEGIN TRANSACTION

-- Get the EntryID from key articles
DECLARE @ErrorCode int
DECLARE @EntryID int
SELECT @EntryID = 0, @ErrorCode = 0

DECLARE @pagetype varchar(50)
SELECT @pagetype = 'xmlfrontpagepreview'

EXEC GetKeyArticleEntryId @pagetype, @siteid, @EntryID OUTPUT
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- if no entry id we need to create a new entry
IF (@EntryID <= 0)
BEGIN
	-- Call the internal version as this takes into account duplicate guideentries!!!
	EXEC @ErrorCode = createguideentryinternal	'frontpage', @bodytext, @extrainfo,
													@editor, 1, 10, NULL, NULL,
													@siteid, 0, 0, @EntryID OUTPUT, 0, 0, 0, 0
	IF @ErrorCode<>0 GOTO HandleError

	-- add new row to key articles
	INSERT INTO keyarticles (ArticleName, EntryID, DateActive, SiteID, EditKey) 
		VALUES (@pagetype, @EntryID, GETDATE(), @SiteID, NEWID())
	SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError
END
--else we should update the guide entry
ELSE
BEGIN
	-- Now check to make sure the Editkeys match!
	DECLARE @CurrentKey uniqueidentifier
	SELECT @CurrentKey = EditKey FROM KeyArticles
		WHERE EntryID = @EntryID

	IF (@CurrentKey != ISNULL(@editkey,@CurrentKey)) 
		GOTO HandleErrorInvalidKey

	EXEC @ErrorCode = updateguideentry	@EntryId, NULL, NULL, NULL, 
											NULL, @editor, NULL, NULL, 
											NULL, NULL, NULL, NULL, @bodytext,
											@extrainfo, NULL, NULL, NULL,NULL, NULL, NULL
	IF @ErrorCode<>0 GOTO HandleError
	
	-- update key articles
	UPDATE keyarticles SET DateActive = GETDATE(), EditKey = NEWID()
		WHERE EntryID = @EntryID
	SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError
	
END

SELECT 'ValidEditKey' = 2, 'NewEditKey' = EditKey From KeyArticles
WHERE EntryID = @EntryID

-- fall through...

ReturnWithoutError:
	COMMIT TRANSACTION
	RETURN 0

HandleErrorInvalidKey:
	ROLLBACK TRANSACTION
	SELECT 'ValidEditKey' = 1
	RETURN 0

HandleError:
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
