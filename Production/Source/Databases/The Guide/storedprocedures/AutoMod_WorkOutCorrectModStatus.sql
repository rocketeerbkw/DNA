CREATE PROCEDURE automod_workoutcorrectmodstatus @userid INT, @siteid INT, @trustpoints INT
AS
	/*
		Function: Works out and updates memeber's new moderation status. 

		Params:
			@userid - user. 
			@siteid - site.
			@trustpoints - number of trustpoints the user has. 

		Results Set: 

		Returns: @@ERROR
	*/

	IF EXISTS (SELECT 1 FROM dbo.Preferences WHERE UserID = @UserID AND SiteID = @SiteID AND PrefStatus = 4)
	BEGIN
		-- If they are banned they can't be changed automatically. 
		RETURN 0;
	END;

	DECLARE @NewModStatus UserModStatus; 

	EXEC @NewModStatus = dbo.automod_calcnewmodstatusbasedonzone @userid		= @userid, 
																 @siteid		= @siteid, 
																 @trustpoints	= @trustpoints;

	EXEC dbo.automod_applynewmodstatus	@userid			= @userid, 
										@siteid			= @siteid, 
										@newmodstatus	= @NewModStatus;

RETURN @@ERROR