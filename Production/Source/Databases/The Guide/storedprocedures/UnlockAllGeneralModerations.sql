/*
	Unlocks all general pages currently locked by this user for moderation (though
	not any referrals they may have)
*/

create procedure unlockallgeneralmoderations @userid int
as
update GeneralMod
set Status = 0, LockedBy = NULL, DateLocked = NULL 
where Status = 1 and LockedBy = @userid
return (0)
