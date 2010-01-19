CREATE PROCEDURE automod_calcnewmodstatusbasedonzone @userid INT, @siteid INT, @trustpoints SMALLINT
AS
	/*
		Function: Calculates user's mod status based on zones defined by site specific thresholds. 

		Params:
			@userid - UserID
			@siteid - site to check against.
			@trustpoints - trust points of the user. 

		Results Set: 

		Returns: UserModStatus - the user's new mod status. 
	*/

	DECLARE @Zone AutoModTrustZone; 

	EXEC @Zone = dbo.automod_calctrustzone	@trustpoints	= @trustpoints, 
											@siteid			= @siteid

	DECLARE @CurrentModStatus UserModStatus; 

	SELECT @CurrentModStatus = ModStatus
	  FROM dbo.Preferences
	 WHERE UserID = @userid
	   AND SiteID = @siteid

	DECLARE @NewModStatus UserModStatus; 

	IF (@Zone = 1) -- BannedZone
	BEGIN
		SELECT @NewModStatus = 4; -- Restricted (aka banned)
	END
	ELSE IF (@Zone = 2) -- PremodZone
	BEGIN
		SELECT @NewModStatus = 1; -- Premoderated
	END
	ELSE IF (@Zone = 3) -- BetweenPremodAndPostmodZone
	BEGIN
		SELECT @NewModStatus = @CurrentModStatus; 
	END
	ELSE IF (@Zone = 4) -- BetweenPostmodAndReactiveZone
	BEGIN
		IF (@CurrentModStatus = 1) -- Premoderated
		BEGIN
			SELECT @NewModStatus = 2; -- Postmoderated
		END
		ELSE
		BEGIN
			SELECT @NewModStatus = @CurrentModStatus;
		END
	END
	ELSE IF (@Zone = 5) -- Reactive
	BEGIN
		SELECT @NewModStatus = 0; -- Standard (aka reactive)
	END
	ELSE
	BEGIN
		RAISERROR('Inrecognised zone in CalcNewModStatusBasedOnZone.', 16, 1)
	END

RETURN @NewModStatus