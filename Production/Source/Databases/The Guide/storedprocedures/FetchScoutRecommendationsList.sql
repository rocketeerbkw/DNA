/*
	Returns a list of entries recommended by this scout with details
	of the entry, its recommendation, and its subbing.
*/

create procedure fetchscoutrecommendationslist
	@scoutid int,
	@unittype varchar(50),
	@numberofunits int,
	@siteid int = 0
as
-- calculate the date from which to count scout recommendations
declare @Date datetime
set @Date =	case
			when lower(@unittype) = 'year' then dateadd(year, -@numberofunits, getdate())
			when lower(@unittype) = 'month' then dateadd(month, -@numberofunits, getdate())
			when lower(@unittype) = 'week' then dateadd(week, -@numberofunits, getdate())
			when lower(@unittype) = 'day' then dateadd(day, -@numberofunits, getdate())
			when lower(@unittype) = 'hour' then dateadd(hour, -@numberofunits, getdate())
			else dateadd(month, -@numberofunits, getdate())
		end
-- fetch all relevant details on this scouts recommendations in that period
select G.*, U1.UserName as ScoutName, 
	U1.FirstNames as ScoutFirstNames, U1.LastName as ScoutLastName, U1.Area as ScoutArea, U1.Status as ScoutStatus, U1.TaxonomyNode as ScoutTaxonomyNode, U1.Journal as ScoutJournal, U1.Active as ScoutActive, P1.SiteSuffix as ScoutSiteSuffix, P1.Title as ScoutTitle,
	U2.UserName as EditorName,
	U2.FirstNames as EditorFirstNames, U2.LastName as EditorLastName, U2.Area as EditorArea, U2.Status as EditorStatus, U2.TaxonomyNode as EditorTaxonomyNode, U2.Journal as EditorJournal, U2.Active as EditorActive, P2.SiteSuffix as EditorSiteSuffix, P2.Title as EditorTitle,
	SR.DateRecommended, SR.Status as RecommendationStatus, SR.DecisionDate,
	AR.SubEditorID, AR.AcceptorID, AR.AllocatorID, AR.DateAllocated, AR.DateReturned, AR.Status as SubbingStatus,
	U3.UserName as SubEditorName,
	U3.FirstNames as SubEditorFirstNames, U3.LastName as SubEditorLastName, U3.Area as SubEditorArea, U3.Status as SubEditorStatus, U3.TaxonomyNode as SubEditorTaxonomyNode, U3.Journal as SubEditorJournal, U3.Active as SubEditorActive, P3.SiteSuffix as SubEditorSiteSuffix, P3.Title as SubEditorTitle,
	U4.UserName as AcceptorName,
	U4.FirstNames as AcceptorFirstNames, U4.LastName as AcceptorLastName, U4.Area as AcceptorArea, U4.Status as AcceptorStatus, U4.TaxonomyNode as AcceptorTaxonomyNode, U4.Journal as AcceptorJournal, U4.Active as AcceptorActive, P4.SiteSuffix as AcceptorSiteSuffix, P4.Title as AcceptorTitle,
	U5.UserName as AllocatorName,
	U5.FirstNames as AllocatorFirstNames, U5.LastName as AllocatorLastName, U5.Area as AllocatorArea, U5.Status as AllocatorStatus, U5.TaxonomyNode as AllocatorTaxonomyNode, U5.Journal as AllocatorJournal, U5.Active as AllocatorActive, P5.SiteSuffix as AllocatorSiteSuffix, P5.Title as AllocatorTitle
from GuideEntries G
inner join ScoutRecommendations SR on SR.EntryID = G.EntryID
inner join Users U1 on U1.UserID = SR.ScoutID
left join Preferences P1 on P1.UserID = U1.UserID and P1.SiteID = @siteid
inner join Users U2 on U2.UserID = G.Editor
left join Preferences P2 on P2.UserID = U2.UserID and P2.SiteID = @siteid
left outer join AcceptedRecommendations AR on AR.RecommendationID = SR.RecommendationID
left outer join Users U3 on U3.UserID = AR.SubEditorID
left join Preferences P3 on P3.UserID = U3.UserID and P3.SiteID = @siteid
left outer join Users U4 on U4.UserID = AR.AcceptorID
left join Preferences P4 on P4.UserID = U4.UserID and P4.SiteID = @siteid
left outer join Users U5 on U5.UserID = AR.AllocatorID
left join Preferences P5 on P5.UserID = U5.UserID and P5.SiteID = @siteid
where SR.ScoutID = @scoutid and SR.DateRecommended > @Date
order by DateRecommended desc
return (0)
