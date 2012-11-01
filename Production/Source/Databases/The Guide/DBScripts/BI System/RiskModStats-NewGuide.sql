/*
	Display the total number of items processed and the total number that got decisions made in the last given months per day.
	If there's a difference, then we have a miss configured site or some other proble.
*/
DECLARE @FourMonthsAgo datetime
SELECT @FourMonthsAgo = DATEADD(Month, -6 , getdate())

select
	rmq.day,
	rmq.month,
	'Month-Day' = cast(rmq.month as varchar) + '-' + cast(rmq.day as varchar),
	'AutoMod Assessed' = rmq.PostsAssessed,
	'Human Assessed' = tmq.PostsAssessed,
	'Total Assessed Items' = rmd.PostsAssessed,
	Diff = rmd.PostsAssessed - rmq.PostsAssessed,
	'% of Risk Mod Items' = 100.0 * (1.0 * rmq.PostsAssessed /rmd.PostsAssessed)
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
INNER JOIN 
(
	select Day = datepart(day, datecompleted), Month = datepart(month, datecompleted), PostsAssessed = count(*) from dbo.ThreadMod
	where datecompleted > @FourMonthsAgo
	group by datepart(day, datecompleted), datepart(month, datecompleted)
) as tmq ON rmq.day = tmq.day AND rmd.month = tmq.month
order by month asc, day asc

select
	rmq.year,
	rmq.month,
	'Year-Month' = cast(rmq.Year as varchar) + '-' + cast(rmq.Month as varchar),
	'AutoMod Assessed' = rmq.PostsAssessed,
	'Human Assessed' = tmq.PostsAssessed,
	'Total Assessed Items' = rmd.PostsAssessed,
	Diff = rmd.PostsAssessed - rmq.PostsAssessed,
	'% of Risk Mod Items' = 100.0 * (1.0 * rmq.PostsAssessed /rmd.PostsAssessed)
from
(
	SELECT Month = datepart(month, dateassessed), Year = datepart(year, dateassessed), PostsAssessed = count(*) from dbo.RiskModThreadEntryQueue
	where dateassessed > @FourMonthsAgo
	group by datepart(year, dateassessed), datepart(month, dateassessed)
) as rmq
INNER JOIN 
(
	select Month = datepart(month, dateassessed), Year = datepart(year, dateassessed), PostsAssessed = count(*) from dbo.RiskModDecisionsForThreadEntries
	where dateassessed > @FourMonthsAgo
	group by datepart(year, dateassessed), datepart(month, dateassessed)
) as rmd ON rmd.month = rmq.month AND rmd.year = rmq.year
INNER JOIN 
(
	select Month = datepart(month, datecompleted), Year = datepart(year, datecompleted), PostsAssessed = count(*) from dbo.ThreadMod
	where datecompleted > @FourMonthsAgo
	group by datepart(year, datecompleted), datepart(month, datecompleted)
) as tmq ON rmd.month = tmq.month AND rmd.year = tmq.year
order by year asc, month asc