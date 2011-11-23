-- newguide 2:52
declare @startdate datetime 
set @startdate ='2011/03/01' -- '2010-11-24 07:21:03.210'

--clear tables
truncate table dbo.UserReputationScore
truncate table dbo.UserPostEvents
truncate table dbo.UserEventScore

-- add scores to UserEventScore table
insert into dbo.UserEventScore
select 1, s.activitytype,0, 0
from  siteactivitytypes s

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



-- insert user post events
insert into dbo.UserPostEvents --typeid, eventdate, modclassid,entryid, score, accumulativescore, userid
select
	17 --UserPost
	, convert(datetime, convert(varchar(4), datepart(yyyy, te.dateposted)) + '/' + convert(varchar(2), datepart(mm, te.dateposted)) + '/' + convert(varchar(2),datepart(dd, te.dateposted)) + ' 23:59:59')
	, 1
	, ues.score
	, 0 as 'accumulativescore'
	, te.userid
	, count(*) as 'numberofposts'
from dbo.Threadentries te
inner join dbo.UserEventScore ues on ues.typeid = 17 
where te.dateposted >=@startdate --min date from site events
and isnull(te.hidden, 0) = 0
group by convert(datetime, convert(varchar(4), datepart(yyyy, te.dateposted)) + '/' + convert(varchar(2), datepart(mm, te.dateposted)) + '/' + convert(varchar(2),datepart(dd, te.dateposted))+ ' 23:59:59')
, te.userid, ues.score

