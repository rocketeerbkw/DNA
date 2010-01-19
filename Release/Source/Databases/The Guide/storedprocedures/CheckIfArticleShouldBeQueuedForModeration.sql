CREATE PROCEDURE checkifarticleshouldbequeuedformoderation @siteid int, @userid int, @h2g2id int, @queue bit output
AS
	/*
		Function: Checks if article should be queued for moderation.

		Params:
			@siteid - SiteID.
			@userid - Author. 
			@h2g2id - ID of article (can be null if creating article).
			@queue - Boolean returning if article should be queued for moderation. 

		Returns: @@ERROR

		Notes: Boolean returned in output param @queue. 
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

	IF (@userid IS NULL)
	BEGIN
		RAISERROR('Param UserID is null in CheckIfArticleShouldBeHidden.', 16, 1);
	END

	IF EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @userid AND Status = 2)
	BEGIN
		-- superuser 
		SET @queue = 0; 
		RETURN @@ERROR;
	END	

	IF (@siteid IS NULL)
	BEGIN
		RAISERROR('Param SiteID is null in CheckIfArticleShouldBeHidden.', 16, 1);
	END

	IF EXISTS (SELECT 1 FROM dbo.VHosts WHERE UserID = @userid AND SiteID = @siteid)
	BEGIN
		SET @queue = 0; 
		RETURN @@ERROR;
	END

	IF EXISTS (SELECT 1 FROM dbo.VModerators WHERE UserID = @userid AND SiteID = @siteid)
	BEGIN
		SET @queue = 0; 
		RETURN @@ERROR;
	END

	DECLARE @IsSitePreModerated TINYINT;
	SELECT @IsSitePreModerated = PreModeration
	  FROM dbo.Sites s
	 WHERE s.SiteID = @siteid;

	DECLARE @IsSitePostModerated TINYINT;
	IF EXISTS (SELECT 1 FROM dbo.Sites WHERE SiteID = @siteid AND PreModeration = 0 AND Unmoderated = 0)
	BEGIN
		SET @IsSitePostModerated = 1
	END
	ELSE
	BEGIN
		SET @IsSitePostModerated = 0
	END 

	DECLARE @ArticlesCurrentModStatus BIT; 
	SELECT TOP 1 @ArticlesCurrentModStatus = Status
	  FROM ArticleMod
	 WHERE h2g2ID = @h2g2id
	  AND DateCompleted IS NOT NULL 
	 ORDER BY DateCompleted DESC 

	DECLARE @IsArticleLockedOrReferred INT; 
	IF EXISTS (SELECT 1 
				 FROM dbo.ArticleMod
				WHERE h2g2ID = @h2g2id
				  AND DateCompleted IS NULL
				  AND ( 
						(Status = 2) OR -- referred
						(DateLocked IS NOT NULL AND LockedBy IS NOT NULL) -- locked by a moderator
					   ) 
			  )
	BEGIN
		SET @IsArticleLockedOrReferred = 1; 
	END
	ELSE 
	BEGIN 
		SET @IsArticleLockedOrReferred = 0; 
	END

	DECLARE @UserPrefStatus INT
	EXEC dbo.getmemberprefstatus @userid		= @userid, 
								 @siteid		= @siteid, 
								 @prefstatus	= @UserPrefStatus output -- returns 1 if user premodded

	IF (@UserPrefStatus = 4)
	BEGIN
		DECLARE @ErrorString varchar(255); 
		SET @ErrorString = 'In CheckIfAricleShouldBeQueueForModeration but UserID ' + @userid + ' is banned.'
		RAISERROR(@ErrorString, 16, 1);
	END

	IF (@IsSitePreModerated = 1 OR
		@IsSitePreModerated IS NULL OR
		@IsSitePostModerated = 1 OR
		@ArticlesCurrentModStatus = 4 OR -- failed moderation
		@IsArticleLockedOrReferred = 1 OR
		@UserPrefStatus = 1) -- premoderated
	BEGIN
		SET @queue = 1; 
	END
	ELSE 
	BEGIN
		SET @queue = 0;
	END

RETURN @@ERROR