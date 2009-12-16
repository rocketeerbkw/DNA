/*
	Fetches list of all user groups, e.g. Sub, Scout, Moderator, etc.
*/

create procedure fetchusergroupslist
as
select *
from Groups
where UserInfo = 1
return (0)
