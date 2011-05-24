-- newguide 2:52
declare @startdate datetime 
set @startdate ='2011/03/01' -- '2010-11-24 07:21:03.210'

--clear tables
truncate table dbo.UserReputationScore
truncate table dbo.UserPostEvents
truncate table dbo.UserEventScore
truncate table dbo.UserSiteEvents

-- add scores to UserEventScore table
insert into dbo.UserEventScore
select m.modclassid, s.activitytype,0
from  ModerationClass m, siteactivitytypes s

--modify events scores
update dbo.UserEventScore set score = -5 where typeid=1 --Moderate Post Failed
update dbo.UserEventScore set score = 1 where typeid=17 --User Post Successful
update dbo.UserEventScore set score = 1 where typeid=18 --Complaint Upheld
update dbo.UserEventScore set score = -1 where typeid=19 --Complaint Rejected



-- insert user post events
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


declare @editorgroup int
select @editorgroup = GroupID FROM Groups WHERE Name = 'Editor'

declare @moderatorgroup int
select @moderatorgroup = GroupID FROM Groups WHERE Name = 'Moderator'

declare @refereegroup int
select @refereegroup = GroupID FROM Groups WHERE Name = 'Referee'

declare @hostgroup INT
select @hostgroup = GroupID FROM Groups WHERE name = 'Host'
-- insert site events
insert into dbo.UserSiteEvents --typeid, eventdate, siteid, modclassid,siteeventid, score, accumulativescore, userid
select sai.[type]
	, sai.datetime
	, sai.siteid
	, m.modclassid
	, sai.id
	, ues.score
	, 0 as 'accumulativescore'
	, saiuser.userid
from dbo.SiteActivityItems sai 
inner join
(
	select id, t.c.value('@USERID', 'int') as userid
	from dbo.SiteActivityItems 
	CROSS APPLY SiteActivityItems.activitydata.nodes('/ACTIVITYDATA/USER') AS T(c)
	where t.c.value('@USERID', 'int') > 0
	and t.c.value('@USERID', 'int') not in
	(
		select distinct(userid)
		from groupmembers
		where groupid in (@moderatorgroup, @editorgroup, @refereegroup, @hostgroup)
	)
) saiuser on saiuser.id = sai.id
inner join sites s on s.siteid = sai.siteid
inner join ModerationClass m on m.modclassid = s.modclassid
inner join dbo.UserEventScore ues on ues.typeid = sai.[type] and m.modclassid=ues.modclassid
where sai.type not in (3,4,5,6,9,15) -- a
and sai.datetime >=@startdate --min date from site events
