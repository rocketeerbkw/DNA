CREATE PROCEDURE checkuserpostfreq @userid int, @siteid int, @seconds int OUTPUT
As

-- Default to 0, meaning this user doesn't have to wait at all
SET @seconds=0

DECLARE @LastPosted datetime
SELECT @LastPosted = LastPosted FROM UserLastPosted WHERE UserID=@userid AND SiteID=@siteid

IF @LastPosted IS NOT NULL
BEGIN
	DECLARE @PostFreq int
	
	-- Find the post frequency for this site, i.e. the max of the given site and site 0 (all of DNA)
	SELECT @PostFreq = max(t.Seconds) FROM 
		(
			SELECT CAST(Value as int) as 'Seconds' FROM SiteOptions WHERE SiteID=0 AND Section='Forum' AND Name='PostFreq'
			UNION ALL
			SELECT CAST(Value as int) as 'Seconds' FROM SiteOptions WHERE SiteID=@siteid AND Section='Forum' AND Name='PostFreq'
		) as t
		
	IF @PostFreq > 0
	BEGIN
		DECLARE @now datetime, @cutoff datetime
		SET @now=getdate()
		SET @cutoff=DATEADD(second,@PostFreq,@LastPosted)
		
		IF @cutoff > @now
		BEGIN
			SET @seconds = DATEDIFF(second,@now,@cutoff)
		END
	END
END
