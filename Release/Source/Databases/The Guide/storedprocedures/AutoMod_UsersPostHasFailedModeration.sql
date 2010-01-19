CREATE PROCEDURE automod_usersposthasfailedmoderation @userid INT, @siteid INT
AS
	/*
		Function: Updates automod point scores and, if necessary, their moderation status due to a post failure. 

		Params:
			@UserID - user who's post has failed. 
			@SiteID - site on which their post has failed.

		Results Set: 

		Returns: @@ERROR
	*/

	IF EXISTS (SELECT 1 
				 FROM dbo.Preferences 
				WHERE UserID = @UserID 
				  AND SiteID = @SiteID 
				  AND ModStatus = 4) -- banned
	BEGIN
		-- They already are already banned.
		RETURN 0; 
	END;

	DECLARE @TrustPoints_Tbl TABLE (TrustPoints SMALLINT, ModStatus UserModStatus); 

	UPDATE dbo.Preferences
	   SET TrustPoints = TrustPoints - 1, 
		   TrustPointPosts = 0 -- Random
	OUTPUT INSERTED.TrustPoints, INSERTED.ModStatus
	  INTO @TrustPoints_Tbl
	 WHERE UserID = @userid
	   AND SiteID = @siteid;

	DECLARE @TrustPoints SMALLINT;
	DECLARE @ModStatus UserModStatus; 
	
	SELECT	@TrustPoints = TrustPoints, 
			@ModStatus = ModStatus
	  FROM	@TrustPoints_Tbl;

	EXEC dbo.automodaudit_addrecord @userid			= @userid, 
									@siteid			= @siteid, 
									@reasonid		= 10, -- PostFailure
									@trustpoints	= @TrustPoints, 
									@modstatus		= @ModStatus

	EXEC dbo.AutoMod_WorkOutCorrectModStatus @userid		= @userid, 
											 @siteid		= @siteid, 
											 @trustpoints	= @TrustPoints

RETURN @@ERROR
