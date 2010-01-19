create procedure fetchmodcomplaintsstats @userid int
as

declare @modgroupid int
select @modgroupid = groupid from groups where name='moderator'

declare @refereegroupid int
select @refereegroupid = groupid from groups where name='referee'

--forums
(select 'forums' name, count(*) count from threadmod tm
	inner join groupmembers m on m.userid = @userid and tm.siteid = m.siteid and m.groupid = @modgroupid 
	, forums f
	where (tm.status = 0 or tm.status = 2) and f.forumid = tm.forumid 
	and tm.complainantid is not null and tm.lockedby is null)
union all

--forums-fastmod
(select 'forums-fastmod' name, count(*) count 
	from threadmod tm 
		inner join groupmembers m on m.userid = @userid and tm.siteid = m.siteid and m.groupid = @modgroupid
		left join FastModForums fmf on fmf.ForumID = tm.ForumID
	where (tm.status = 0 or tm.status = 2) 
		and tm.complainantid is not null 
		and tm.lockedby is null
		and fmf.ForumID is not null)
		
union all

--entries
(select 'entries',count(*) from articlemod a
	inner join groupmembers m on m.userid = @userid and a.siteid = m.siteid and m.groupid = @modgroupid 
	where (a.status = 0 or a.status = 2) 
	and a.complainantid is not null and a.lockedby is null)
union all

--general
(select 'general',count(*) from generalmod g 
	inner join groupmembers m on m.userid = @userid and g.siteid = m.siteid 
	and m.groupid = @modgroupid
	where (g.status = 0 or g.status = 2) and g.lockedby is null)
