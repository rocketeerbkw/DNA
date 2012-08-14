/*
--Team GB twitter forum
select count(*) from threadentries where forumid = 24353961
*/

select 'Total Items in BI Queue' = count(*) from bieventqueue

select 'Total NON risk mod items in queue' = count(*) from bieventqueue bi
inner join forums f on f.forumid = bi.itemid
inner join RiskModerationState rms on rms.id = f.siteid
where
rms.idtype='S' and rms.Ison = 0 and bi.eventtype = 19

select top 5 'Time in seconds to process' = DATEDIFF(second, DatePosted, DateAssessed), *
from riskmodthreadentryqueue
where DateAssessed is not null
order by dateposted desc

-- This shows all the sites that have been mis configured in the BI solution. Update the details in the BI web interface.
select distinct 'Sites Mis-configured' = siteid from RiskModDecisionsForThreadEntries where isrisky is null and dateassessed > '2012-08-14 16:15:00'

--Delete all items from the biqueue that don't belong to sites which are risk mod
/*

delete from dbo.bieventqueue where eventid in
(
	select top 100 eventid from dbo.bieventqueue bi
	inner join dbo.forums f on f.forumid = bi.itemid
	inner join dbo.RiskModerationState rms on rms.id = f.siteid
	where
	rms.idtype='S' and rms.Ison = 0 and bi.eventtype = 19
	order by eventdate desc
)

*/