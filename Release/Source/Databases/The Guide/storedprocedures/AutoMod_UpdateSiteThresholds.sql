CREATE PROCEDURE automod_updatesitethresholds
	@siteid INT, 
	@bannedthresholdvalue SMALLINT, 
	@premodthresholdvalue SMALLINT, 
	@postmodthresholdvalue TINYINT, 
	@reactivethresholdvalue TINYINT, 
	@maxtrustvalue TINYINT, 
	@numpostspertrustpoint TINYINT, 
	@maxintopremodcount TINYINT, 
	@seedusertrustusingpreviousbehaviour TINYINT, 
	@initialtrustpoints TINYINT
AS
	/*
		Function: Updates sites auto mod threshold values. 

		Params:
			@siteid INT, 
			@bannedthresholdvalue SMALLINT, 
			@premodthresholdvalue SMALLINT, 
			@postmodthresholdvalue TINYINT, 
			@reactivethresholdvalue TINYINT, 
			@maxtrustvalue TINYINT, 
			@numpostspertrustpoint TINYINT, 
			@maxintopremodcount TINYINT, 
			@seedusertrustusingpreviousbehaviour TINYINT, 
			@initialtrustpoints TINYINT

		Results Set: 

		Returns: @@ERROR
	*/

	UPDATE	dbo.Sites
	   SET	BannedThresholdValue				= @BannedThresholdValue, 
			PremodThresholdValue				= @PremodThresholdValue, 
			PostmodThresholdValue				= @PostmodThresholdValue, 
			ReactiveThresholdValue				= @ReactiveThresholdValue, 
			MaxTrustValue						= @MaxTrustValue, 
			NumPostsPerTrustPoint				= @NumPostsPerTrustPoint, 
			MaxIntoPreModCount					= @MaxIntoPreModCount, 
			SeedUserTrustUsingPreviousBehaviour	= @SeedUserTrustUsingPreviousBehaviour, 
			InitialTrustPoints					= @InitialTrustPoints
	 WHERE	SiteID = @siteid

RETURN @@ERROR