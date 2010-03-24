create procedure addarticlemodhistory @modid int, @statusid int,
	@reasonid int, @actionid int, @lockedbychanged bit, @lockedby int, 
	@triggerid int, @triggeredby int, @notes text
as

insert into ArticleModHistory (ModId, StatusID, ReasonID, ActionID, LockedByChanged,
	LockedBy, TriggerId, TriggeredBy, Notes) values (@modid, 
	@statusid, @reasonid, @actionid, @lockedbychanged, nullif(@lockedby, 0), 
	@triggerid, nullif(@triggeredby, 0), @notes);

return @@ERROR
