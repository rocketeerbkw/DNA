Create Procedure statsmovieviews @fromdate datetime = '1 Jan 1900', @todate datetime = '1 Jan 2199'
As
SELECT 'Date' = CAST(CAST(MONTH(DateViewed) as varchar) + '/' + CAST(DAY(DateViewed) as varchar) + '/' + cast(YEAR(DateViewed) as varchar) as datetime), 'Count' = COUNT(*) FROM ViewedMovies WHERE DateViewed >= @fromdate AND DateViewed < @todate
GROUP BY CAST(CAST(MONTH(DateViewed) as varchar) + '/' + CAST(DAY(DateViewed) as varchar) + '/' + cast(YEAR(DateViewed) as varchar) as datetime)
	return (0)