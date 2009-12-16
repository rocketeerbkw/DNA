CREATE PROCEDURE automod_calctrustzone @trustpoints SMALLINT, @siteid INT
AS
	/*
		Function: Calculates zone the trustpoint score falls within. 

		Params:
			@trustpoints - Trust point score. 
			@siteid - site to check threshold against.

		Results Set: 

		Returns: AutoModTrustZone (see table AutoModTrustZone for descriptions)
	*/

	DECLARE @BannedThresholdValue SMALLINT;
	DECLARE @PremodThresholdValue SMALLINT;
	DECLARE @PostmodThresholdValue TINYINT;
	DECLARE @ReactiveThresholdValue TINYINT;
	DECLARE @MaxTrustPoints TINYINT;
	DECLARE @NumPostsPerTrustPoint TINYINT;
	DECLARE @MaxIntoPreModCount TINYINT;

	SELECT	@BannedThresholdValue	= BannedThresholdValue,
			@PremodThresholdValue	= PremodThresholdValue,
			@PostmodThresholdValue	= PostmodThresholdValue,
			@ReactiveThresholdValue = ReactiveThresholdValue,
			@MaxTrustPoints			= MaxTrustValue, 
			@NumPostsPerTrustPoint	= NumPostsPerTrustPoint,
			@MaxIntoPreModCount		= MaxIntoPreModCount
	  FROM	dbo.Sites
	 WHERE	SiteID = @siteid;

	DECLARE @Zone AutoModTrustZone; 

    if (@trustpoints <= @BannedThresholdValue)
	BEGIN
        SET @Zone = 1;
	END
	ELSE IF (@trustpoints > @BannedThresholdValue AND @trustpoints <= @PremodThresholdValue)
	BEGIN
        SET @Zone = 2;
	END
	ELSE IF (@trustpoints > @PremodThresholdValue AND @trustpoints < @PostmodThresholdValue)
	BEGIN
        SET @Zone = 3;
	END
	ELSE IF (@trustPoints >= @PostmodThresholdValue AND @trustPoints < @ReactiveThresholdValue)
	BEGIN
        SET @Zone = 4;
	END
	ELSE
	BEGIN
		SET @Zone = 5;
	END

return @Zone