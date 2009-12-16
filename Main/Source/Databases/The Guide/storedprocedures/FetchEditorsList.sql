create procedure fetcheditorslist
as
select UserID, UserName
from Users
where Status > 1 and Active = 1
return (0)
