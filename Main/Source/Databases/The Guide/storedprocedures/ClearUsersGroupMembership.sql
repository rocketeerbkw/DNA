/*
	Simply clears this users group membership by deleting all rows for them from
	the GroupMembers table for any UserInfo groups.
*/

create procedure clearusersgroupmembership @userid int, @siteid int
as
delete GroupMembers
where UserID = @userid 
	and GroupID in (select GroupID from Groups where UserInfo = 1) 
	AND SiteID = @siteid
return (0)
