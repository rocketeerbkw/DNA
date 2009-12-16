create procedure checkuserhasentrylockedformoderation @userid int, @h2g2id int
as
-- check if in the table and locked by this user
select 'IsLocked' =
	case
		when exists (	select ModID
						from ArticleMod
						where	h2g2ID = @h2g2id and
								(Status = 1 or Status = 2) and 
								LockedBy is not null and LockedBy = @userid)
			then 1
		else 0
	end
return (0)
