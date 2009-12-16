CREATE PROCEDURE updateautosinbinstatus @userid int, @siteid int, @autosinbin tinyint output
AS
BEGIN
	/*
		Remove user from sin bin if appropriate. 
	*/
	
	DECLARE @datejoined datetime
	SELECT	@autosinbin = AutoSinBin,
			@datejoined = DateJoined
		FROM dbo.Preferences WITH(NOLOCK)
		WHERE SiteID = @SiteID AND UserID = @UserID
	
	if (ISNULL(@autosinbin, 0) = 0)
		RETURN 0;
	
	DECLARE @premodduration int
	EXEC checkpremodduration @siteid, @premodduration OUTPUT

	--the first condition that must be met is that the time duration is completed
	IF (DATEDIFF(MINUTE, @datejoined, DATEADD(MINUTE, -@premodduration, GETDATE())) >= 0)
	BEGIN
		--if the time duration is over then the user must have also posted the requiste amount of posts
		DECLARE @postcountthreshold int
		EXEC checkpostcountthreshold @siteid, @postcountthreshold OUTPUT
			
		DECLARE @currentpostcount bigint
		SELECT @currentpostcount = Total
		  FROM dbo.VUserPostCount pc WITH(NOEXPAND)
		 WHERE pc.UserID = @userid
		   AND pc.SiteID = @siteid

		DECLARE @currentarticlecount bigint
		SELECT @currentarticlecount = Total
		  FROM dbo.VUserArticleCount ac WITH(NOEXPAND)
		 WHERE ac.UserID = @userid
		   AND ac.SiteID = @siteid

		IF ((ISNULL(@currentpostcount, 0) + ISNULL(@currentarticlecount, 0)) >= @postcountthreshold)
		BEGIN
			--ok all conditions are met we can take them out of auto premod
			UPDATE dbo.Preferences
				SET AutoSinBin = 0 
				WHERE siteid = @siteid 
				AND userid = @userid			
			set @autosinbin = 0
		END
	END
END