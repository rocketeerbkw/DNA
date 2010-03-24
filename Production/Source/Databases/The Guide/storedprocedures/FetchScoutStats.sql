/*
	Returns stats for a specific scout if an ID is provided, or all scouts if not
*/

create procedure fetchscoutstats @scoutid int = null
as
select U.UserID as ScoutID, U.UserName, Quota, Interval,
	(select count(*) from ScoutRecommendations where ScoutID = U.UserID) as TotalRecommendations,
	(select count(*) from ScoutRecommendations where ScoutID = U.UserID
		and DateRecommended > case SD.Interval
								when 'year' then dateadd(year, -1, getdate())
								when 'month' then dateadd(month, -1, getdate())
								when 'week' then dateadd(week, -1, getdate())
								when 'day' then dateadd(day, -1, getdate())
								else dateadd(month, -1, getdate())
							end
	) as RecommendationsLastInterval
from Users U
left outer join ScoutDetails SD on SD.ScoutID = U.UserID
where U.UserID in (select ScoutID from ScoutRecommendations union select UserID from GroupMembers GM inner join Groups G on GM.GroupID = G.GroupID where G.Name = 'Scouts')
	and (@scoutid is null or @scoutid = U.UserID)
order by U.UserID
return (0)
