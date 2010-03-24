/*
	Adds this user to each of the groups named.
	Ignores any invalid group names but does return the total number of groups
	the user was successfully added to.
*/

create procedure addusertogroups
	@userid int,
	@siteid int,
	@groupname1 varchar(50) = null,
	@groupname2 varchar(50) = null,
	@groupname3 varchar(50) = null,
	@groupname4 varchar(50) = null,
	@groupname5 varchar(50) = null,
	@groupname6 varchar(50) = null,
	@groupname7 varchar(50) = null,
	@groupname8 varchar(50) = null,
	@groupname9 varchar(50) = null,
	@groupname10 varchar(50) = null
as
insert into GroupMembers (UserID, GroupID, SiteID)
select @userid, GroupID, @siteid
from Groups
where Name in (	@groupname1, @groupname2, @groupname3, @groupname4, @groupname5,
				@groupname6, @groupname7, @groupname8, @groupname9, @groupname10)
		AND UserInfo = 1
-- return the number of rows affected
select 'GroupsAdded' = @@rowcount
return (0)
