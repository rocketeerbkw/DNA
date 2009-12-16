CREATE PROCEDURE updateclub	@clubid int, 
								@userid int,
								@title varchar(255) = NULL, 
								@bodytext varchar(max) = NULL,
								@extrainfo text = NULL,
								@changeeditor tinyint = NULL
AS
declare @h2g2id int
SELECT @h2g2id = h2g2ID FROM Clubs WHERE ClubID = @clubid

declare @premoderation int, @siteid int, @oldEditor int
SELECT @premoderation = s.PreModeration, @siteid = g.SiteID, @oldEditor = g.editor FROM GuideEntries g INNER JOIN Sites s ON s.SiteID = g.SiteID
	WHERE g.h2g2id = @h2g2id

IF (@siteid IS NULL)
BEGIN
	SELECT @siteid = 1
END

DECLARE @PrefStatus INT
EXEC getmemberprefstatus @UserID, @SiteID, @PrefStatus OUTPUT
IF (@premoderation IS NULL OR @premoderation <> 1) AND @PrefStatus = 1
BEGIN
	SELECT @premoderation = 1
END


-- override @changeEditor if editor hasn't changed
IF (@changeEditor = 1 AND @oldEditor = @userid)
	SELECT @changeEditor = 0


BEGIN TRANSACTION
DECLARE @ErrorCode INT


-- Update the Clubs table
IF (@title IS NOT NULL)
BEGIN
	UPDATE Clubs WITH(HOLDLOCK) SET Name=@title, LastUpdated = CURRENT_TIMESTAMP WHERE ClubID = @clubid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END


-- Update the GuideEntries table
IF (@premoderation = 1) OR (@title IS NOT NULL) OR (@bodytext IS NOT NULL) OR (@extrainfo IS NOT NULL)
BEGIN

	UPDATE GuideEntries SET
		hidden     = CASE WHEN (@premoderation = 1)     THEN 3          ELSE hidden    END
		,subject   = CASE WHEN (@title     IS NOT NULL) THEN @title     ELSE subject   END
		,text      = CASE WHEN (@bodytext  IS NOT NULL) THEN @bodytext  ELSE text      END
		,extrainfo = CASE WHEN (@extrainfo IS NOT NULL) THEN @extrainfo ELSE extrainfo END
		,editor    = CASE WHEN (@changeEditor = 1)      THEN @userid    ELSE editor    END
	WHERE h2g2id=@h2g2id

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END	

	IF (@changeEditor = 1)
	BEGIN
		EXEC @ErrorCode = SwapEditingPermissions @h2g2id, @oldEditor, @userid
		IF (@ErrorCode != 0)
			RETURN @ErrorCode
	END
END

-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
EXEC addtoeventqueueinternal 'ET_CLUBEDITED', @clubid, 'IT_CLUB', DEFAULT, DEFAULT, @userid

COMMIT TRANSACTION
Select 'Success' = 1
