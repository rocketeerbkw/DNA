CREATE PROCEDURE automod_syncmodstatusacrosssites @userid INT, @siteid INT, @newmodstatus UserModStatus
AS
	/*
		Function: Syncs new mod status across all sites the user is a member of. 

		Params:
			@userid - User to be synced. 
			@siteid - Site to be ignored (i.e. site that already has updated mod status and trust points).
			@newmodstatus - new mod status to be applied.

		Results Set: 

		Returns: @@ERROR
	*/

	IF (@newmodstatus = 4) -- Restricted (aka banned)
	BEGIN
		EXEC dbo.automod_syncbannedacrosssites @userid = @userid,
											   @siteid = @siteid
	END

	IF (@newmodstatus = 1) -- Premoderated
	BEGIN
		EXEC dbo.automod_syncpremodacrosssites @userid = @userid,
											   @siteid = @siteid
	END

	IF (@newmodstatus = 2) -- Postmoderated
	BEGIN
		EXEC dbo.automod_syncpostmodacrosssites @userid = @userid,
												@siteid = @siteid
	END

RETURN @@ERROR