create procedure removehandledsnesevents @eventids xml
as
begin
	-- @eventids type expected format
	--	<eventid>
	--		eventid
	--	<eventid>
	with CTE_EVENTIDS as
	(
		select d1.c1.value('.','int') eventid
		from @eventids.nodes('/eventid') as d1(c1)	
	)
	delete from SNeSActivityQueue 
	where EventID in (select eventid from CTE_EVENTIDS)
end