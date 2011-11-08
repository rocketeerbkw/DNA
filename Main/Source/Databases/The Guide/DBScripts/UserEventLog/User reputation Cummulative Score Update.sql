-- new guide 2:18:51

set nocount on


declare @mindate datetime
declare @typeid int
declare @eventdate datetime
declare @siteid int 
declare @modclassid int
declare @entryid int 
declare @siteeventid int 
declare @score smallint 
declare @acummulativescore smallint 
declare @userid int 
declare @addscore smallint 
declare @numberofposts int 
declare @logdate datetime
declare @maxscore smallint
declare @newaccummulativescore smallint 
declare @override bit


--change this date 
set @mindate = '20100601'

DECLARE @runningTotal TABLE
(
  userid int,
  modclassid int,
  accumulativescore smallint,
  unique(userid,modclassid)
)
-- clear all scores
truncate table dbo.UserEventScore

-- add scores to UserEventScore table
insert into dbo.UserEventScore
select m.modclassid, s.activitytype,0, 0
from  ModerationClass m, siteactivitytypes s

--modify events scores
update dbo.UserEventScore set score = -5 where typeid=1 --Moderate Post Failed
update dbo.UserEventScore set score = 1 where typeid=17 --User Post Successful
update dbo.UserEventScore set score = 0 where typeid=18 --Complaint Upheld
update dbo.UserEventScore set score = 0 where typeid=19 --Complaint Rejected
update dbo.usereventscore set score = -7, overridescore=1 where typeid=10 --premod
update dbo.usereventscore set score = -2, overridescore=1 where typeid=11 --postmod
update dbo.usereventscore set score = -17, overridescore=1 where typeid=12 --banned
update dbo.usereventscore set score = -17, overridescore=1 where typeid=13 --deactiviated
update dbo.usereventscore set score = 0, overridescore=1 where typeid=16 --standard
update dbo.usereventscore set score = 11, overridescore=1 where typeid=20 --trusted
set @maxscore = 15

DECLARE rt_cursor CURSOR FAST_FORWARD
FOR
select *
from
(
select typeid, eventdate, 0 as 'siteid', modclassid, null as 'siteeventid', score, accumulativescore, userid, numberofposts
from UserPostEvents
where eventdate > @mindate

union all

select typeid, eventdate, siteid, modclassid, siteeventid, score, accumulativescore, userid, 0
from UserSiteEvents
where eventdate > @mindate
) events
order by eventdate
 
OPEN rt_cursor
 
FETCH NEXT FROM rt_cursor INTO @typeid, @eventdate, @siteid, @modclassid, @siteeventid, @score, @acummulativescore, @userid, @numberofposts
set @logdate = @eventdate

WHILE @@FETCH_STATUS = 0
BEGIN
	set @addscore = null
	set @newaccummulativescore = null
	
	
	select @score = score, @override = overridescore
	from dbo.UserEventScore
	where typeid=@typeid and modclassid=@modclassid

	if @siteeventid is null
	BEGIN
		set @addscore = (@score* @numberofposts)
	END
	ELSE
	BEGIN
		set @addscore = @score
	END
	
	
	-- get current accumulativescore
	if @override = 1
	BEGIN
		set @newaccummulativescore = @score
	END
	ELSE
	BEGIN
		select  @newaccummulativescore = accumulativescore + @addscore
		from @runningTotal
		where userid=@userid and modclassid= @modclassid
		
		if @newaccummulativescore is null
		BEGIN
			set @newaccummulativescore = @addscore
		END
	END
	
	if @newaccummulativescore > @maxscore
	BEGIN
		set @newaccummulativescore = @maxscore
	END
	
	--apply update
	update @runningTotal
	set accumulativescore = @newaccummulativescore
	where userid=@userid
	and modclassid= @modclassid
	
	if @@rowcount =0
	BEGIN -- add if new user
		--print 'adding UserReputationScore:' + convert(varchar(20), @userid) + ' and modclassid' + convert(varchar(20), @modclassid)
		insert into @runningTotal(userid, modclassid, accumulativescore)
		values (@userid, @modclassid, @newaccummulativescore)
	END

	if @siteeventid is null
	BEGIN
		--print 'adding @entryid:' + convert(varchar(20), @entryid)
		update dbo.UserPostEvents
		set accumulativescore = @newaccummulativescore
		, score = @score
		where userid=@userid
		and modclassid= @modclassid
		and eventdate = @eventdate
	END
	ELSE
	BEGIN
		update  dbo.UserSiteEvents
		set accumulativescore = @newaccummulativescore 
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

truncate table dbo.UserReputationScore
insert into dbo.UserReputationScore
select *,getdate()
from @runningTotal

