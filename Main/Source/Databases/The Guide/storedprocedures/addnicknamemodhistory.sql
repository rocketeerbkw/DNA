CREATE PROCEDURE addnicknamemodhistory @modid INT, @statusid INT,
	@lockedbychanged BIT, @lockedby INT, @triggerid INT, @triggeredby INT, @date datetime=NULL
AS

INSERT INTO NicknameModHistory (ModId, StatusID, LockedByChanged,
	LockedBy, TriggerId, TriggeredBy, DateCreated) VALUES (@modid, 
	@statusid, @lockedbychanged, NULLIF(@lockedby,0), 
	@triggerid, NULLIF(@triggeredby,0), ISNULL(@date,getdate()));

RETURN @@ERROR
