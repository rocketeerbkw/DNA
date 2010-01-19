/*
	Unlocks all posts currently locked by this user for moderation (though
	not any referrals they may have)
*/

create procedure unlockallforummoderations @userid int
as
update ThreadMod
set Status = 0, LockedBy = NULL, DateLocked = NULL 
where Status = 1 and LockedBy = @userid
return (0)
