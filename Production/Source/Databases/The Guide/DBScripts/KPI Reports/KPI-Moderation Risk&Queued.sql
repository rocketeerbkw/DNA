declare @mindate datetime
declare @maxdate datetime

set @mindate ='20120701'
set @maxdate = DATEADD(MONTH, 1, @mindate)

DECLARE @TotalPosts INT
select @TotalPosts = count(*)
from threadentries
where dateposted >= @mindate and dateposted < @maxdate

DECLARE @TotalThreadModItemsProcessed INT
select @TotalThreadModItemsProcessed = count(*)
from threadmod
where datecompleted >= @mindate and datecompleted < @maxdate

DECLARE @TotalThreadModItemsFailed INT
select @TotalThreadModItemsFailed = count(*)
from threadmod
where datecompleted >= @mindate and datecompleted < @maxdate AND status = 4

DECLARE @TotalNonRiskModItemsProcessed INT
select @TotalNonRiskModItemsProcessed = count(*)
from threadmod
where datecompleted >= @mindate and datecompleted < @maxdate
and postid not in
(
	select threadentryid from riskmodthreadentryqueue
	where dateassessed >= @mindate and dateassessed < @maxdate
)

DECLARE @TotalRiskModItemsProcessed INT
select @TotalRiskModItemsProcessed = count(*)
from riskmodthreadentryqueue as rm
where dateassessed >= @mindate and dateassessed < @maxdate

DECLARE @TotalRiskModItemsPasses INT
select @TotalRiskModItemsPasses = count(*)
from riskmodthreadentryqueue
where dateassessed >= @mindate and dateassessed < @maxdate
and threadentryid not in
(
	select postid from threadmod
	where datecompleted >= @mindate and datecompleted < @maxdate
)

DECLARE @TotalRiskModItemsInModQueue INT
select @TotalRiskModItemsInModQueue = count(*)
from riskmodthreadentryqueue as rm
inner join threadmod tm on tm.postid = rm.threadentryid
where dateassessed >= @mindate and dateassessed < @maxdate

DECLARE @TotalRiskModItemsNotReferedButFailed INT
select @TotalRiskModItemsNotReferedButFailed = count(*)
from threadmod tm
inner join riskmodthreadentryqueue rm on tm.postid = rm.threadentryid
where dateassessed >= @mindate and dateassessed < @maxdate and isrisky = 0

DECLARE @TotalRiskModItemsRefered INT
select @TotalRiskModItemsRefered = count(*)
from threadmod tm
inner join riskmodthreadentryqueue rm on tm.postid = rm.threadentryid
where dateassessed >= @mindate and dateassessed < @maxdate and isrisky = 1

SELECT
	'@TotalPosts' = @TotalPosts,
	'@TotalThreadModItemsProcessed' = @TotalThreadModItemsProcessed,
	'@TotalNonRiskModItemsProcessed' = @TotalNonRiskModItemsProcessed,
	'@TotalThreadModItemsFailed' = @TotalThreadModItemsFailed,
	'@TotalRiskModItemsProcessed' = @TotalRiskModItemsProcessed,
	'@TotalRiskModItemsPasses' = @TotalRiskModItemsPasses,
	'@TotalRiskModItemsInModQueue' = @TotalRiskModItemsInModQueue,
	'@TotalRiskModItemsNotReferedButFailed' = @TotalRiskModItemsNotReferedButFailed,
	'@TotalRiskModItemsRefered' = @TotalRiskModItemsRefered

print @mindate
print 'total posts: ' + cast(@TotalPosts as varchar)
DECLARE @TotalItems INT
SELECT @TotalItems = @TotalRiskModItemsProcessed + @TotalNonRiskModItemsProcessed + @TotalRiskModItemsNotReferedButFailed
print 'total items moderated: ' + cast(@TotalItems as varchar)
print 'total non risk mod items moderated: ' + cast(@TotalNonRiskModItemsProcessed as varchar)
print 'total risk mod items processed: ' + cast(@TotalRiskModItemsProcessed as varchar)
print 'total items failed: ' + cast(@TotalRiskModItemsInModQueue + @TotalThreadModItemsFailed as varchar)
print 'total non risk mod items failed: ' + cast(@TotalThreadModItemsFailed as varchar)
print 'total risk mod items failed: ' + cast(@TotalRiskModItemsInModQueue as varchar)
print '% Failed: ' + cast(((1.0 * @TotalThreadModItemsFailed) / @TotalItems) * 100.0 as varchar)
DECLARE @Passed float
SELECT @Passed = ((1.0 * @TotalRiskModItemsPasses) / @TotalRiskModItemsProcessed) * 100.0
print '% of risk mod items passed: ' + cast(@Passed as varchar)
print '% of risk mod items failed: ' + cast(100.0 - @Passed as varchar)
print '% total items risk moderated: ' + cast(((1.0 * @TotalRiskModItemsProcessed) / @TotalItems) * 100.0 as varchar)
print '% total items human moderated: ' + cast(((1.0 * @TotalNonRiskModItemsProcessed + @TotalRiskModItemsNotReferedButFailed) / @TotalItems) * 100.0 as varchar)