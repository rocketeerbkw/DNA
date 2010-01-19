CREATE PROCEDURE getmoderatorsforsite @siteid int
AS

declare @modgroupid int
SELECT @modgroupid = groupid from Groups where name='Moderator'

select 	u.userid, u.email, u.username,u.username, u.lastname,u.loginname, s.siteid
	 from groupmembers m inner join sites s on m.siteid = s.siteid 
			     inner join users u on u.userid = m.userid 

where m.groupid = @modgroupid and u.userid in (select userid from groupmembers m where siteid = @siteid and groupid = @modgroupid) 
order by s.siteid, u.userid 

return(0)