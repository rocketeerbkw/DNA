set nocount on

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
declare @logdate datetime

DECLARE @runningTotal TABLE
(
  userid int,
  modclassid int,
  accumulativescore smallint
)

truncate table dbo.UserReputationScore
truncate table dbo.UserEventScore


-- add scores to UserEventScore table
insert into dbo.UserEventScore
select m.modclassid, s.activitytype,0
from  ModerationClass m, siteactivitytypes s

--modify events scores
update dbo.UserEventScore set score = -5 where typeid=1 --Moderate Post Failed
update dbo.UserEventScore set score = 1 where typeid=17 --User Post Successful
update dbo.UserEventScore set score = 1 where typeid=18 --Complaint Upheld
update dbo.UserEventScore set score = -1 where typeid=19 --Complaint Rejected


DECLARE rt_cursor CURSOR FAST_FORWARD
FOR
select *
from
(
select typeid, eventdate, 0 as 'siteid', modclassid, null as 'siteeventid', score, accumulativescore, userid, numberofposts
from UserPostEvents

union all

select typeid, eventdate, siteid, modclassid, siteeventid, score, accumulativescore, userid, 0
from UserSiteEvents
) events
order by eventdate
 
OPEN rt_cursor
 
FETCH NEXT FROM rt_cursor INTO @typeid, @eventdate, @siteid, @modclassid, @siteeventid, @score, @acummulativescore, @userid, @numberofposts
set @logdate = @eventdate

WHILE @@FETCH_STATUS = 0
BEGIN
	set @userscore = null
	
	select @score = score
	from dbo.UserEventScore
	where typeid=@typeid and modclassid=@modclassid

	if @siteeventid is null
	BEGIN
		set @userscore = (@score* @numberofposts)
	END
	ELSE
	BEGIN
		set @userscore = @score
	END
	
	
	-- get current accumulativescore
	
	update @runningTotal
	set accumulativescore = accumulativescore + @userscore
	where userid=@userid
	and modclassid= @modclassid
	
	if @@rowcount =0
	BEGIN -- add if new user
		--print 'adding UserReputationScore:' + convert(varchar(20), @userid) + ' and modclassid' + convert(varchar(20), @modclassid)
		insert into @runningTotal(userid, modclassid, accumulativescore)
		values (@userid, @modclassid, @userscore)
	END
	
	
	select @userscore =  accumulativescore
	from @runningTotal
	where userid=@userid and modclassid=@modclassid


	if @siteeventid is null
	BEGIN
		--print 'adding @entryid:' + convert(varchar(20), @entryid)
		update dbo.UserPostEvents
		set accumulativescore = @userscore
		, score = @score
		where userid=@userid
		and modclassid= @modclassid
		and eventdate = @eventdate
	END
	ELSE
	BEGIN
		update  dbo.UserSiteEvents
		set accumulativescore = @userscore 
		, score = @score
		where siteeventid = @siteeventid
	END

	if @eventdate> dateadd(dd, 1, @logdate)
	begin
		print 'adding @eventdate:' + convert(varchar(20), @eventdate)
		set @logdate = @eventdate
	end
	
	FETCH NEXT FROM rt_cursor INTO @typeid, @eventdate, @siteid, @modclassid, @siteeventid, @score, @acummulativescore, @userid, @numberofposts
END
 
CLOSE rt_cursor
DEALLOCATE rt_cursor

insert into dbo.UserReputationScore
select *
from @runningTotal



--drop table @runningTotal