/*
	Clears the BBC login detail associated with this user ID so that they can
	be used by another account, or this account can be associated with another
	BBC account.
*/

create procedure clearusersbbclogindetails @userid int
as
update Users set LoginName = null, BBCUID = null
where UserID = @userid
select 'Success' = @@rowcount
return (0)
