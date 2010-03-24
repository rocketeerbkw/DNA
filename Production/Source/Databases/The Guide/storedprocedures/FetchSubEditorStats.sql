/*
	Fetches stats on this sub editor if an ID is provided, or on all subs otherwise.
*/

create procedure fetchsubeditorstats @subid int = null
as
select U.UserID as SubID, U.UserName, Quota,
	(select count(*) from AcceptedRecommendations where SubEditorID = U.UserID and Status = 2) as CurrentAllocations,
	(select count(*) from AcceptedRecommendations where SubEditorID = U.UserID and Status = 3) as SubbedEntries
from Users U
left outer join SubDetails SD on SD.SubEditorID = U.UserID
where U.UserID in (	select SubEditorID from AcceptedRecommendations
					union select UserID from GroupMembers GM inner join Groups G on GM.GroupID = G.GroupID where G.Name = 'Subs')
	and (@subid is null or @subid = U.UserID)
order by U.UserID
return (0)
