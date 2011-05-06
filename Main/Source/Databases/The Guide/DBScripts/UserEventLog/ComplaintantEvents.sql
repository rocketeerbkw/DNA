-- new guide 10:08 mins

declare @startdate datetime 
set @startdate ='2011/03/01' -- '2010-11-24 07:21:03.210'

insert into siteactivityitems
select --top 10 
--tm.modid,
19 as 'type'
,convert(xml, '<ACTIVITYDATA>A complaint on <POST FORUMID="' + convert(varchar(20), tm.forumid) + '" POSTID="' + convert(varchar(20), postid) +
'" THREADID="' + convert(varchar(20), threadid) + '" URL="' + isnull(cf.url,'') + '">post</POST> ' +
'by <USER USERID="' + convert(varchar(20), complainantid) + '">' + replace(u1.username, '&', '') + 
'</USER> was rejected by <USER USERID="' + convert(varchar(20), lockedby) + '">' + replace(u2.username, '&', '') + 
'</USER> because <NOTES></NOTES></ACTIVITYDATA>') as 'activitydata'
,tm.datecompleted as 'datetime'
,tm.siteid as 'siteid'
from threadmod tm
inner join users u1 on u1.userid = tm.complainantid
inner join users u2 on u2.userid = tm.lockedby
left join commentforums cf on cf.forumid = tm.forumid
where isnull(complainantid, 0) <> 0
and tm.status=3
and datequeued > @startdate
and lockedby is not null
order by tm.modid

--31485175. 3207

insert into siteactivityitems
select --top 10 
18 as 'type'
,'<ACTIVITYDATA>A complaint on <POST FORUMID="' + convert(varchar(20), tm.forumid) + '" POSTID="' + convert(varchar(20), postid) +
'" THREADID="' + convert(varchar(20), threadid) + '" URL="' + isnull(cf.url,'') + '">post</POST> ' +
'by <USER USERID="' + convert(varchar(20), complainantid) + '">' + replace(u1.username, '&', '') + 
'</USER> was upheld by <USER USERID="' + convert(varchar(20), lockedby) + '">' + replace(u2.username, '&', '')+ 
'</USER> because <NOTES></NOTES></ACTIVITYDATA>' as 'activitydata'
,tm.datecompleted as 'datetime'
,tm.siteid as 'siteid'
from threadmod tm
inner join users u1 on u1.userid = tm.complainantid
inner join users u2 on u2.userid = tm.lockedby
left join commentforums cf on cf.forumid = tm.forumid
where isnull(complainantid, 0) <> 0
and tm.status=4
and datequeued > @startdate
and lockedby is not null

--'2010-11-24 07:21:03.210'
