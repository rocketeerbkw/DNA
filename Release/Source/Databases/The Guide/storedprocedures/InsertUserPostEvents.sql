CREATE PROCEDURE insertuserpostevents
	
AS
BEGIN

set transaction isolation level read uncommitted

declare @startdate datetime 
select @startdate = max(eventdate)
from  dbo.UserPostEvents

insert into dbo.UserPostEvents --typeid, eventdate, siteid, modclassid,entryid, score, accumulativescore, userid
select
	17 --UserPost
	, convert(datetime, convert(varchar(4), datepart(yyyy, te.dateposted)) + '/' + convert(varchar(2), datepart(mm, te.dateposted)) + '/' + convert(varchar(2),datepart(dd, te.dateposted)) + ' 23:59:59')
	--, f.siteid
	, m.modclassid
	, ues.score
	, 0 as 'accumulativescore'
	, te.userid
	, count(*) as 'numberofposts'
from dbo.Threadentries te 
inner join forums f on f.forumid=te.forumid
inner join sites s on s.siteid = f.siteid
inner join ModerationClass m on m.modclassid = s.modclassid
inner join dbo.UserEventScore ues on ues.typeid = 17 and m.modclassid=ues.modclassid
where te.dateposted >= @startdate --min date from site events
and isnull(te.hidden, 0) = 0
group by convert(datetime, convert(varchar(4), datepart(yyyy, te.dateposted)) + '/' + convert(varchar(2), datepart(mm, te.dateposted)) + '/' + convert(varchar(2),datepart(dd, te.dateposted))+ ' 23:59:59')
, m.modclassid, ues.score, te.userid

--select 0
--update scores
declare @typeid int
declare @eventdate datetime
declare @siteid int 
declare @modclassid int
declare @entryid int 
declare @siteeventid int 
declare @score smallint 
declare @acummulativescore smallint 
declare @userid int 
declare @userscore smallint 
declare @numberofposts int 

DECLARE rt_cursor CURSOR FAST_FORWARD
FOR
select *
from
(
	select typeid, eventdate, 0 as 'siteid', modclassid, null as 'siteeventid', score, accumulativescore, userid, numberofposts
	from UserPostEvents
	where eventdate >= @startdate
) events
order by eventdate
 
OPEN rt_cursor
 
FETCH NEXT FROM rt_cursor INTO @typeid, @eventdate, @siteid, @modclassid, @siteeventid, @score, @acummulativescore, @userid, @numberofposts

WHILE @@FETCH_STATUS = 0
BEGIN
	set @userscore = null
	
	select @score = score
	from dbo.UserEventScore
	where typeid=@typeid and modclassid=@modclassid

	set @userscore = (@score* @numberofposts)

	-- get current accumulativescore
	update dbo.UserReputationScore
	set accumulativescore = accumulativescore + @userscore
	where userid=@userid
	and modclassid= @modclassid
	
	--print 'adding @entryid:' + convert(varchar(20), @entryid)
	update dbo.UserPostEvents
	set accumulativescore = @userscore, score = @score
	where userid=@userid
	and modclassid= @modclassid
	and eventdate = @eventdate
	
	FETCH NEXT FROM rt_cursor INTO @typeid, @eventdate, @siteid, @modclassid, @siteeventid, @score, @acummulativescore, @userid, @numberofposts
END
 
CLOSE rt_cursor

	
END