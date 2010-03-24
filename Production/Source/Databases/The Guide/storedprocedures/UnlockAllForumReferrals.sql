create procedure unlockallforumreferrals @userid int
as
update ThreadMod
set LockedBy = NULL, DateLocked = NULL 
where Status = 2 and LockedBy = @userid
return (0)