CREATE PROCEDURE automod_userhasposted @userid INT, @siteid INT
AS
	/*
		Function: Updates automod point scores and, if necessary, their moderation status. 

		Params:
			@UserID - user that has posted. 
			@SiteID - site on which they have posted.

		Results Set: 

		Returns: @@ERROR
	*/

	IF EXISTS (SELECT 1 FROM dbo.Preferences WHERE UserID = @UserID AND SiteID = @SiteID AND PrefStatus = 4)
	BEGIN
		RAISERROR ('AutoMod_UserHasPosted has been called on a banned user!',16,1);
	END;

	DECLARE @MaxTrustPoints TINYINT;
	DECLARE @NumPostsPerTrustPoint TINYINT; 
	
	SELECT	@MaxTrustPoints			= MaxTrustValue, 
			@NumPostsPerTrustPoint	= NumPostsPerTrustPoint
	  FROM	dbo.Sites
	 WHERE	SiteID = @SiteID;

	IF EXISTS (SELECT 1 FROM dbo.Preferences WHERE UserID = @UserID AND SiteID = @SiteID AND TrustPoints >= @MaxTrustPoints)
	BEGIN
		-- They already have max trust score. Don't give them any more to avoid karma whoring.
		RETURN 0; 
	END;

	DECLARE @TrustPointPosts_Tbl TABLE (TrustPointPosts TINYINT, TrustPoints SMALLINT, ModStatus UserModStatus); 

	UPDATE dbo.Preferences
	   SET TrustPointPosts = TrustPointPosts + 1
	OUTPUT INSERTED.TrustPointPosts, INSERTED.TrustPoints, INSERTED.ModStatus
	  INTO @TrustPointPosts_Tbl
	 WHERE UserID = @UserID
	   AND SiteID = @SiteID;

	DECLARE @TrustPointPosts TINYINT; 
	DECLARE @TrustPoints SMALLINT; 
	DECLARE @ModStatus UserModStatus; 

	SELECT @TrustPointPosts = TrustPointPosts, 
		   @TrustPoints		= TrustPoints,
		   @ModStatus		= ModStatus
	  FROM @TrustPointPosts_Tbl

	EXEC dbo.automodaudit_addrecord @userid			= @userid, 
									@siteid			= @siteid, 
									@reasonid		= 2, -- Post
									@trustpoints	= @TrustPoints, 
									@modstatus		= @ModStatus

	DECLARE @TrustPoints_Tbl TABLE (TrustPoints SMALLINT, ModStatus UserModStatus); 

	IF (@TrustPointPosts % @NumPostsPerTrustPoint = 0)
	BEGIN
		UPDATE dbo.Preferences
		   SET TrustPoints		= TrustPoints + 1,
			   TrustPointPosts	= 0 -- reset TrustPointPosts
		OUTPUT INSERTED.TrustPoints, INSERTED.ModStatus
		  INTO @TrustPoints_Tbl
		 WHERE UserID = @UserID
		   AND SiteID = @SiteID;

		SELECT @TrustPoints		= TrustPoints,
			   @ModStatus		= ModStatus
		  FROM @TrustPoints_Tbl

		EXEC dbo.automodaudit_addrecord @userid			= @userid, 
										@siteid			= @siteid, 
										@reasonid		= 3, -- AddTrustPoint
										@trustpoints	= @TrustPoints, 
										@modstatus		= @ModStatus
	END
	
	SELECT @TrustPoints = TrustPoints
	  FROM @TrustPoints_Tbl

	IF (@TrustPoints IS NULL)
	BEGIN
		SELECT @TrustPoints = TrustPoints
		  FROM dbo.Preferences
		 WHERE UserID = @UserID
		   AND SiteID = @SiteID;
	END

	-- Always work out member's correct mod status after posting incase site thresholds have changed.
	EXEC dbo.automod_workoutcorrectmodstatus @userid		= @userid, 
											 @siteid		= @siteid, 
											 @trustpoints	= @TrustPoints

RETURN @@ERROR
