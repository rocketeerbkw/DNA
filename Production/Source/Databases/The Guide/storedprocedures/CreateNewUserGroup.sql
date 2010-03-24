/*
	Create a new user group of the given name unless one already exists.
*/

create procedure createnewusergroup @userid int, @groupname varchar(50)
as
declare @Success bit
-- default to failure
set @Success = 0
-- do a case insensitive comparison, as this is safer and less likely to cause confusion
if (not exists (select * from Groups where upper(Name) = upper(@groupname)))
begin
	insert into Groups (Name, Owner, UserInfo)
	values (@groupname, @userid, 1)
	set @Success = 1
end
-- return the success as a field
select 'Success' = @Success
return (0)
