/*
	Deactivates an account without cancelling it altogether
*/

create procedure deactivateaccount @userid int
as
update Users set SinBin = 1, Active = 0, Status = 0, DateReleased = getdate()
where UserID = @userid
-- return a field for the number of rows updated so that success can
-- be checked if necessary
select 'RowsUpdated' = @@rowcount
return (0)
