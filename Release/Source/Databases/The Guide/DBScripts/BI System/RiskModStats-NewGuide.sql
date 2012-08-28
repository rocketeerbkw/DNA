/*
	Display the total number of items processed and the total number that got decisions made in the last 4 months per day.
	If there's a difference, then we have a miss configured site or some other proble.
*/
DECLARE @FourMonthsAgo datetime
SELECT @FourMonthsAgo = DATEADD(Month, -4 , getdate())
select
	rmq.day,
	rmq.month,
	RealPostsAssessed = rmq.PostsAssessed,
	rmd.PostsAssessed, Diff = rmd.PostsAssessed - rmq.PostsAssessed,
	'% of extra work done in error' = 100 - 100.0 * (1.0 * rmq.PostsAssessed /rmd.PostsAssessed)
from
(
	select Day = datepart(day, dateassessed), Month = datepart(month, dateassessed), PostsAssessed = count(*) from dbo.RiskModThreadEntryQueue
	where dateassessed > @FourMonthsAgo
	group by datepart(day, dateassessed), datepart(month, dateassessed)
) as rmq
INNER JOIN 
(
	select Day = datepart(day, dateassessed), Month = datepart(month, dateassessed), PostsAssessed = count(*) from dbo.RiskModDecisionsForThreadEntries
	where dateassessed > @FourMonthsAgo
	group by datepart(day, dateassessed), datepart(month, dateassessed)
) as rmd ON rmq.day = rmd.day AND rmd.month = rmq.month
order by month asc, day asc

