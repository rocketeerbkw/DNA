Create Procedure statsuserjoined @fromdate datetime = '1 Jan 1900', @todate datetime = '1 Jan 2199'
As
SELECT 'Date' = CAST(CAST(MONTH(Datejoined) as varchar) + '/' + CAST(DAY(DateJoined) as varchar) + '/' + cast(YEAR(DateJoined) as varchar) as datetime), 'Count' = COUNT(*) FROM Users WHERE email IS NULL AND DateJoined >= @fromdate AND DateJoined < @todate
GROUP BY CAST(CAST(MONTH(Datejoined) as varchar) + '/' + CAST(DAY(DateJoined) as varchar) + '/' + cast(YEAR(DateJoined) as varchar) as datetime)

	return (0)