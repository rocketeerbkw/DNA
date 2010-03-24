CREATE PROCEDURE updateexmoderationevents @eventids xml
as
begin
	-- @eventids type expected format
	--	<eventid id='' handeld=''/>
	with CTE_EVENTIDS as
	(
		select d1.c1.value('@id','int') modid,
		d1.c1.value('@handled', 'int') handled
		from @eventids.nodes('/event') as d1(c1)
	)
	SELECT modid, handled INTO #modevents
	FROM CTE_EVENTIDS
	
	
	-- Remove successful events
	INSERT INTO  ExLinkModHistory ( ModId, Notes, ReasonID, [Timestamp]) 
	SELECT modId, 'Item handled', 1, CURRENT_TIMESTAMP from #modevents 
	WHERE handled = 1
	
	delete from ExModEventQueue 
	where modid in (select modid from #modevents WHERE handled = 1 )
	
	
	
	-- Update Unsuccesful events
	INSERT INTO  ExLinkModHistory ( ModId, Notes, ReasonID, [Timestamp]) 
	SELECT modId, 'Notification Failed - Retry', 2, CURRENT_TIMESTAMP from #modevents 
	WHERE handled = 0
	
	update  ExModEventQueue
	set lastretry = CURRENT_TIMESTAMP, retrycount = ISNULL(retrycount,0) + 1
	WHERE modid IN ( SELECT modid from #modevents WHERE handled = 0 )
	
	
	-- Remove Unsuccessful Items from Event Queue after 24 hours
	INSERT INTO  ExLinkModHistory ( ModId, Notes, ReasonID, [Timestamp] ) 
	SELECT ex.modId, 'Notification Failed - Removed', 3, CURRENT_TIMESTAMP 
	FROM ExModEventQueue ex
	INNER JOIN ExLinkMod m ON m.ModId = ex.ModId
	WHERE DATEDIFF( Hour, m.DateCompleted, ex.LastRetry ) > 24
	
	-- Remove Items that have been in the queue for over 24 hours.
	DELETE FROM ex
	FROM ExModEventQueue ex
	JOIN ExLinkMod m ON m.modid = ex.modid
	WHERE DATEDIFF( Hour, m.DateCompleted, ex.LastRetry ) > 24
	
end

