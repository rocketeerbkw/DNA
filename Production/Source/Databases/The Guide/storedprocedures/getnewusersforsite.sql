CREATE PROCEDURE getnewusersforsite @siteid int, @timeunit varchar(10), @numberofunits int, @count int OUTPUT
AS
-- Just reading, so set the iso level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Setup the date range to check between. Make sure we don't do a stupid search and go over one year
DECLARE @Date datetime
SET @Date =	CASE
			WHEN LOWER(@timeunit) = 'year' AND @numberofunits <= 1 THEN DATEADD(YEAR, -@numberofunits, GetDate())
			WHEN LOWER(@timeunit) = 'month' AND @numberofunits <= 12 THEN DATEADD(MONTH, -@numberofunits, GetDate())
			WHEN LOWER(@timeunit) = 'week' AND @numberofunits <= 52 THEN DATEADD(WEEK, -@numberofunits, GetDate())
			WHEN LOWER(@timeunit) = 'day' AND @numberofunits <= 365 THEN DATEADD(DAY, -@numberofunits, GetDate())
			WHEN LOWER(@timeunit) = 'hour' AND @numberofunits <= 8736 THEN DATEADD(HOUR, -@numberofunits, GetDate())
			ELSE DATEADD(WEEK, -1, GetDate()) -- Default to one week
		END

-- Find the number of joined users whcih match the given criteria
SELECT u.userid, u.username, p.datejoined, p.AutoSinBin FROM dbo.Users u
	INNER JOIN dbo.Preferences p ON u.UserID = p.UserID
	WHERE p.DateJoined > @Date AND p.SiteID = @siteid
	ORDER BY p.DateJoined desc

-- Finally get the number of rows we selected.
SELECT @count = @@ROWCOUNT
