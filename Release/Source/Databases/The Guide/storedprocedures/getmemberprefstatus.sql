--This stored procedure will return a users current status on a site.
-- Returns 0 - standard (NULL i.e. not set - is converted to 0), 
--		   1 - premod, 
--		   2 - postmod, 
--		   4 - banned
CREATE PROCEDURE getmemberprefstatus @userid int, @siteid int, @prefstatus int output
AS
DECLARE @AutoSinBin tinyint, @datejoined datetime
SELECT	@PrefStatus = PrefStatus,
		@AutoSinBin = AutoSinBin,
		@datejoined = DateJoined
	FROM dbo.Preferences WITH(NOLOCK)
	WHERE SiteID = @SiteID AND UserID = @UserID

-- Check to see if the user has the auto sin bin feature turned on
IF (@AutoSinBin = 1 AND @PrefStatus <> 1 AND @PrefStatus <> 4)
BEGIN
	SET @PrefStatus = 1
END
