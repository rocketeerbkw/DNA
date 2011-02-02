CREATE PROCEDURE updateguideentry	@entryid int, 
										@dateexpired datetime = NULL, 
										@cancelled int = NULL,
										@supercededby int = NULL, 
										@basedon int = NULL, 
										@editor int = NULL, 
										@subject varchar(255) = NULL, 
										@keywords varchar(255) = NULL, 
										@latestversion int = NULL, 
										@style int = NULL, 
										@status int = NULL,
										@submittable tinyint = NULL, 
										@bodytext varchar(max) = NULL,
										@extrainfo text = NULL,
										@type int = NULL,
										@addevent int = NULL,
										@preprocessed int = NULL,
										@canread int = NULL,
										@canwrite int = NULL,
										@canchangepermissions int = NULL,
										@groupnumber int = NULL,
										@updatecontentsignif int = NULL,
										@editinguser int = NULL,
										@updatedatecreated bit = NULL
										
AS
declare @set varchar(2048)
declare @comma varchar(5)
declare @h2g2id int
declare @premoderation int, @siteid int, @hidden int
declare @articlemoderationstatus int
declare @oldStatus int
declare @oldEditor int
declare @lastupdated datetime

-- Get some current information out
SELECT @premoderation = s.PreModeration, @siteid = g.SiteID, @oldStatus = g.status, @oldEditor = g.Editor, @lastupdated = g.LastUpdated,
		@h2g2ID = h2g2ID, @hidden = Hidden
FROM GuideEntries g INNER JOIN Sites s ON s.SiteID = g.SiteID
	WHERE g.EntryID = @entryid

IF (@siteid IS NULL)
BEGIN
	SELECT @siteid = 1
END

declare @HideArticle bit
SET @HideArticle = 0

DECLARE @UserToCheck INT;
SELECT @UserToCheck = ISNULL(@editor, @oldEditor); 

EXEC dbo.checkifarticleshouldbehidden	@siteid = @siteid, 
										@userid = @UserToCheck, 
										@h2g2id = @h2g2ID, 
										@hide	= @HideArticle output

SELECT @comma = ''
SELECT @set = ''
IF NOT (@dateexpired IS NULL)
BEGIN
SELECT @set = @set + @comma + 'DateExpired = @i_dateexpired'
SELECT @comma = ' , '
END
IF NOT (@cancelled IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Cancelled = @i_cancelled'
SELECT @comma = ' , '
END
IF NOT (@supercededby IS NULL)
BEGIN
SELECT @set = @set + @comma + 'SupercededBy = @i_supercededby'
SELECT @comma = ' , '
END
IF NOT (@basedon IS NULL)
BEGIN
SELECT @set = @set + @comma + 'BasedOn = @i_basedon'
SELECT @comma = ' , '
END
IF NOT (@editor IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Editor = @i_editor'
SELECT @comma = ' , '
END
IF NOT (@subject IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Subject = @i_subject'
SELECT @comma = ' , '
END
IF NOT (@keywords IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Keywords = @i_keywords'
SELECT @comma = ' , '
END
IF NOT (@latestversion IS NULL)
BEGIN
SELECT @set = @set + @comma + 'LatestVersion = @i_latestversion'
SELECT @comma = ' , '
END
IF NOT (@status IS NULL)
BEGIN
	SELECT @set = @set + @comma + 'Status = @i_status'
	SELECT @comma = ' , '
END
IF NOT (@submittable IS NULL)
BEGIN
	SELECT @set = @set + @comma + 'Submittable = @i_submittable'
	SELECT @comma = ' , '
END
IF NOT (@type IS NULL)
BEGIN
	SELECT @set = @set + @comma + 'Type = @i_type'
	SELECT @comma = ' , '
END
IF NOT (@preprocessed IS NULL)
BEGIN
	SELECT @set = @set + @comma + 'PreProcessed = @i_preprocessed'
	SELECT @comma = ' , '
END
IF NOT (@canread IS NULL)
BEGIN
	SELECT @set = @set + @comma + 'CanRead = @i_canread'
	SELECT @comma = ' , '
END
IF NOT (@canwrite IS NULL)
BEGIN
	SELECT @set = @set + @comma + 'CanWrite = @i_canwrite'
	SELECT @comma = ' , '
END
IF NOT (@canchangepermissions IS NULL)
BEGIN
	SELECT @set = @set + @comma + 'CanChangePermissions = @i_canchangepermissions'
	SELECT @comma = ' , '
END

IF NOT (@style IS NULL)
BEGIN
SELECT @set = @set + @comma + 'Style = @i_style'
SELECT @comma = ' , '
END

IF ( ISNULL(@updatedatecreated,0) = 1)
BEGIN
SELECT @set = @set + @comma + 'DateCreated = getdate()'
SELECT @comma = ' , '
END

IF (@HideArticle = 1)
BEGIN
	SELECT @set = @set + @comma + 'Hidden = 3'
	SELECT @comma = ' , '
END
ELSE 
BEGIN
	SELECT @set = @set + @comma + 'Hidden = NULL'
	SELECT @comma = ' , '
END

BEGIN TRANSACTION
DECLARE @ErrorCode INT

if DATEDIFF(minute, @lastupdated, getdate()) > 5
BEGIN
	INSERT INTO GuideEntryVersions
		(EntryID, Subject, text, Hidden, OriginalLastUpdated, DateSaved)
		SELECT EntryID, Subject, text, Hidden, LastUpdated, getdate()
			FROM GuideEntries WITH(UPDLOCK)
				WHERE EntryID = @entryid
END


IF (@set <> '')
BEGIN
	declare @query nvarchar(4000)
	SELECT @query = N'UPDATE GuideEntries WITH(HOLDLOCK) SET ' + @set + N' WHERE EntryID = @i_entryid'
	exec sp_executesql @query,
	N'@i_entryid int,
	@i_dateexpired datetime,
	@i_cancelled int,
	@i_supercededby int,
	@i_basedon int,
	@i_editor int,
	@i_subject varchar(255),
	@i_keywords varchar(255),
	@i_latestversion int,
	@i_status int,
	@i_submittable int,
	@i_type int,
	@i_preprocessed int,
	@i_canread int,
	@i_canwrite int,
	@i_canchangepermissions int,
	@i_style int',
	@i_entryid = @entryid,
	@i_dateexpired = @dateexpired,
	@i_cancelled = @cancelled,
	@i_supercededby = @supercededby,
	@i_basedon = @basedon,
	@i_editor = @editor,
	@i_subject = @subject,
	@i_keywords = @keywords,
	@i_latestversion = @latestversion,
	@i_status = @status,
	@i_submittable = @submittable,
	@i_type = @type,
	@i_preprocessed = @preprocessed,
	@i_canread = @canread,
	@i_canwrite = @canwrite,
	@i_canchangepermissions = @canchangepermissions,
	@i_style = @style
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

IF (NOT (@bodytext IS NULL))
BEGIN
	UPDATE GuideEntries SET text = @bodytext WHERE EntryID = @entryid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

--Update the extraInfo
IF (NOT (@extrainfo IS NULL))
BEGIN
	UPDATE GuideEntries SET ExtraInfo = @extrainfo WHERE entryid = @entryid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

--INSERT INTO ArticleMod (h2g2ID) VALUES (@h2g2id)

IF @subject IS NOT NULL
BEGIN
	declare @forumid int
	SELECT @forumid = ForumID FROM GuideEntries WHERE EntryID = @entryid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Forums Set Title = @subject WHERE ForumID = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

IF (@HideArticle = 1)
BEGIN
	IF EXISTS (SELECT 1 FROM dbo.Forums WITH (NOLOCK) WHERE ForumID = @forumid AND ((CanWrite = 1) OR (CanWrite = 1)))
	BEGIN
		UPDATE dbo.Forums SET CanWrite = 0, CanRead = 0 WHERE ForumID = @forumid
	END
END
ELSE
BEGIN
	IF EXISTS (SELECT 1 FROM dbo.Forums WITH (NOLOCK) WHERE ForumID = @forumid AND ((CanWrite = 0) OR (CanWrite = 0)))
	BEGIN
		UPDATE dbo.Forums SET CanWrite = 1, CanRead = 1 WHERE ForumID = @forumid
	END
END

-- do some maintenance on GuideEntryPermissions
IF @status IS NOT NULL OR @editor IS NOT NULL
BEGIN
	-- if status after all this is 1, we want no entries in GEP
	IF (@status IS NULL AND @oldStatus = 1) OR (@status IS NOT NULL AND @status = 1)
	BEGIN
		-- if @oldStatus is 1 there will be nothing to delete
		IF @status = 1
		BEGIN
			DELETE GuideEntryPermissions FROM GuideEntryPermissions WHERE h2g2id = @h2g2id
		END
	END
	ELSE
	BEGIN
		-- we want an entry in the GEP
		DECLARE @newEditor int
		IF @editor IS NOT NULL
		BEGIN
			SELECT @newEditor = @editor
		END
		ELSE
		BEGIN
			SELECT @newEditor = @oldEditor
		END
		
		IF @status IS NOT NULL AND @oldStatus = 1 AND @status != 1
		BEGIN
			-- Gone from status 1 (no entry in GEP) to some other status
			INSERT INTO GuideEntryPermissions (h2g2ID, TeamID, CanRead, CanWrite, CanChangePermissions)
				SELECT @h2g2id, u.TeamID, 1, 1, 1
					FROM UserTeams u
					WHERE u.UserID = @newEditor AND u.SiteID = @siteid
		END
		ELSE
		BEGIN
			-- The new status is irrelevant, now check editor changes
			IF @newEditor != @oldEditor
			BEGIN
				EXEC @ErrorCode = SwapEditingPermissions @h2g2id, @oldEditor, @newEditor
				IF (@ErrorCode != 0)
				BEGIN
					RETURN @ErrorCode
				END
			END
		END
	END
END

COMMIT TRANSACTION

IF(@addevent = 1)
BEGIN
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_ARTICLEEDITED', @h2g2id, 'IT_H2G2', DEFAULT, DEFAULT, @editinguser
END


	-- update content signif
	IF(@updatecontentsignif = 1)
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'UpdateGuideEntry',
												  @siteid		= @siteid, 
												  @entryid		= @entryid, 
												  @userid		= @editinguser 	
	END
	
	-- Gone to status 1 from some other status - made an official guide entry check for solo entries
	IF (@status IS NOT NULL AND @oldStatus != 1 AND @status = 1)
	BEGIN
		DECLARE @oldgroupid int
		DECLARE @newgroupid int
		DECLARE @refreshgroups int

		EXEC @ErrorCode = dbo.checksologuideentrydetails @entryid, @oldgroupid OUTPUT, @newgroupid OUTPUT, @refreshgroups OUTPUT 
		IF (@ErrorCode != 0)
		BEGIN
			RETURN @ErrorCode
		END
		
		--SELECT @oldgroupid 'OldGroup',  @newgroupid 'NewGroup', @refreshgroups 'RefreshGroups'
	END

RETURN 0