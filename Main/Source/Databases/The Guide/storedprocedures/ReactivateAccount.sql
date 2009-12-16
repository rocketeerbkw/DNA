/*
	Reactivates a deactivated account.
	Note that users status is always set to 1, so if an editor was deactivated
	then reactivated they would come back as an ordinary user.
*/

create procedure reactivateaccount @userid int
as
update Users set SinBin = null, Active = 1, Status = 1, DateReleased = null
where UserID = @userid
-- return a field for the number of rows updated so that success can
-- be checked if necessary
select 'RowsUpdated' = @@rowcount
return (0)
