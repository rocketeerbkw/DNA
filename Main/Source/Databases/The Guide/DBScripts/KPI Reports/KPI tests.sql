use newguide

--select distinct kpiname
--from KPIsHistory

--select distinct appname
--from KPIsHistory

declare @mindate datetime
declare @maxdate datetime

set @mindate ='20111101'
set @maxdate ='20111201'

select f.title,f.forumpostcount
,(select count(*) from users u
	join threadentries te on te.userid=u.userid
	where te.forumid=f.forumid
	and u.datejoined>=f.datecreated and u.datejoined <dateadd(day,1,f.datecreated)) newUsers
from commentforums cf
join forums f on f.forumid=cf.forumid
where cf.siteid=492
and f.datecreated >= @mindate and f.datecreated < @maxdate
order by newUsers desc


set @mindate ='20111201'
set @maxdate ='20120101'

select f.title,f.forumpostcount
,(select count(*) from users u
	join threadentries te on te.userid=u.userid
	where te.forumid=f.forumid
	and u.datejoined>=f.datecreated and u.datejoined <dateadd(day,1,f.datecreated)) newUsers
from commentforums cf
join forums f on f.forumid=cf.forumid
where cf.siteid=492
and f.datecreated >= @mindate and f.datecreated < @maxdate
order by newUsers desc


set @mindate ='20120101'
set @maxdate ='20120201'

select f.title,f.forumpostcount
,(select count(*) from users u
	join threadentries te on te.userid=u.userid
	where te.forumid=f.forumid
	and u.datejoined>=f.datecreated and u.datejoined <dateadd(day,1,f.datecreated)) newUsers
from commentforums cf
join forums f on f.forumid=cf.forumid
where cf.siteid=492
and f.datecreated >= @mindate and f.datecreated < @maxdate
order by newUsers desc

set @mindate ='20120201'
set @maxdate ='20120301'

select f.title,f.forumpostcount
,(select count(*) from users u
	join threadentries te on te.userid=u.userid
	where te.forumid=f.forumid
	and u.datejoined>=f.datecreated and u.datejoined <dateadd(day,1,f.datecreated)) newUsers
from commentforums cf
join forums f on f.forumid=cf.forumid
where cf.siteid=492
and f.datecreated >= @mindate and f.datecreated < @maxdate
order by newUsers desc



select convert(char(10),u.datejoined,121),s.urlname,s.shortname, count(*) as 'new users'
from users u
join mastheads p on p.userid=u.userid
join sites s on s.siteid=p.siteid
where u.datejoined >= @mindate and u.datejoined < @maxdate
and s.urlname='newscommentsmodule'
group by convert(char(10),u.datejoined,121),s.urlname,s.shortname
order by convert(char(10),u.datejoined,121)

select convert(char(10),u.datejoined,121),s.urlname,s.shortname, count(*) as 'new users'
from users u
join mastheads p on p.userid=u.userid
join sites s on s.siteid=p.siteid
where u.datejoined >= @mindate and u.datejoined < @maxdate
and s.urlname = 'mbcbbc'
group by convert(char(10),u.datejoined,121),s.urlname,s.shortname
order by convert(char(10),u.datejoined,121)

select s.urlname,s.shortname,convert(char(13),u.datejoined,121), count(*) as 'new users'
from users u
join mastheads p on p.userid=u.userid
join sites s on s.siteid=p.siteid
where u.datejoined >= @mindate and u.datejoined < @maxdate
group by s.urlname,s.shortname,convert(char(13),u.datejoined,121)
order by convert(char(13),u.datejoined,121)
--order by count(*) desc

select s.urlname,s.shortname,count(*) as 'new users'
from users u
join mastheads p on p.userid=u.userid
join sites s on s.siteid=p.siteid
where u.datejoined >= @mindate and u.datejoined < @maxdate
group by s.urlname,s.shortname
order by count(*) desc

select s.urlname,s.shortname,count(*) as 'new comment forums'
from commentforums cf
join forums f on f.forumid=cf.forumid
join sites s on s.siteid=f.siteid
where f.datecreated >= @mindate and f.datecreated < @maxdate
group by s.urlname,s.shortname
order by count(*) desc

select s.urlname,s.shortname,count(*) as 'new users'
from users u
join preferences p on p.userid=u.userid
join sites s on s.siteid=p.siteid
where u.datejoined >= @mindate and u.datejoined < @maxdate
group by s.urlname,s.shortname
order by count(*) desc

select count(*) as 'new twitter users'
from users u
join signinuseridmapping s on s.dnauserid=u.userid
where datejoined >= @mindate and datejoined < @maxdate
and s.twitteruserid is not null

select count(*) as 'total posts'
from threadentries
where dateposted >= @mindate and dateposted < @maxdate

select count(*) as 'total failed'
from threadmod
where datecompleted >= @mindate and datecompleted < @maxdate
and status <> 3

select count(*) as 'new users'
from users
where datejoined >= @mindate and datejoined < @maxdate





select count(*) as 'moderation decisions'
from threadmod
where datecompleted >= @mindate and datecompleted < @maxdate


select count(distinct(userid)) as 'distinct users'
from threadentries
where dateposted >= @mindate and dateposted < @maxdate


