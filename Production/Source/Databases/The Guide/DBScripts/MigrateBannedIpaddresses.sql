insert into [dbo].[BannedIPAddress]
select distinct te.userid, ipaddress, bbcuid
from threadentriesipaddress teia
inner join threadentries te on te.entryid= teia.entryid
where te.userid in
(
	select distinct userid from preferences where prefstatus=4
	)
and ipaddress is not null 
and bbcuid is not null
and bbcuid <> '00000000-0000-0000-0000-000000000000'