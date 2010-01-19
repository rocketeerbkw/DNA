create procedure unlockallgeneralreferrals @userid int
as
update GeneralMod
set LockedBy = NULL, DateLocked = NULL 
where Status = 2 and LockedBy = @userid
return (0)