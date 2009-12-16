/*
	Fetches details of all items locked to or referred to certain users.
*/

create procedure fetchlockeditemsstats
as
-- create temporary table to contain the union of all the locked items
create table #LockedItems (UserID int, TotalEntries int, TotalPosts int, TotalNicknames int, TotalGeneral int)
-- insert the data into this table
insert into #LockedItems
select 'UserID' = LockedBy, 'TotalEntries' = count(*), 'TotalPosts' = 0, 'TotalNicknames' = 0, 'TotalGeneral' = 0
from ArticleMod
where (Status = 1 or Status = 2 ) and LockedBy is not null
group by LockedBy
union
select 'UserID' = LockedBy, 'TotalEntries' = 0, 'TotalPosts' = count(*), 'TotalNicknames' = 0, 'TotalGeneral' = 0
from ThreadMod
where (Status = 1 or Status = 2) and LockedBy is not null
group by LockedBy
union
select 'UserID' = LockedBy, 'TotalEntries' = 0, 'TotalPosts' = 0, 'TotalNicknames' = count(*), 'TotalGeneral' = 0
from NicknameMod
where Status = 1 and LockedBy is not null
group by LockedBy
union
select 'UserID' = LockedBy, 'TotalEntries' = 0, 'TotalPosts' = 0, 'TotalNicknames' = 0, 'TotalGeneral' = count(*)
from GeneralMod
where (Status = 1 or Status = 2) and LockedBy is not null
group by LockedBy
-- select the summed results from this table and return them
select LI.UserID, UserName, 'TotalEntries' = sum(TotalEntries), 'TotalPosts' = sum(TotalPosts), 'TotalNicknames' = sum(TotalNicknames), 'TotalGeneral' = sum(TotalGeneral)
from #LockedItems LI
inner join Users U on U.UserID = Li.UserID
group by LI.UserID, UserName
return (0)
