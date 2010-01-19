/*
	Fetches the UserID and UserName of all active users who belong to the moderator group
*/

create procedure fetchmoderatorslist
as
-- need to do the check based on the name of the group rather than its GroupID
-- since the ID isn't not guaranteed the same between databases
select U.UserID, U.UserName
from Users U
inner join GroupMembers GM on GM.UserID = U.UserID
inner join Groups G on G.GroupID = GM.GroupID
where U.Active = 1 and G.Name = 'Moderator'
return (0)
