/*
	Fetches a list of all the scout recommendations that have been allocated
	to a sub but not yet returned.
	Currently only gets the article info though, no data about the scout or
	the recommendation.
*/

create procedure fetchallocatedunreturnedrecommendations @siteid int=0, @show int = 10000, @skip int =0
as
-- should not be duplicate entries, but do not fetch them if there are
-- status 2 = 'Allocated'

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

set @show = @show+1 -- increase by 1 for more param

;WITH allocatedunreturnedrecommendations AS
(
	select distinct AR.EntryID, ROW_NUMBER() OVER(ORDER BY AR.DateAllocated asc) n
	from AcceptedRecommendations AR
	inner join GuideEntries G1 on G1.EntryID = AR.EntryID
	inner join Users U1 on U1.UserID = G1.Editor
	left join Preferences P on P.UserID = U1.UserID AND P.SiteID = @siteid
	left outer join GuideEntries G2 on G2.EntryID = AR.OriginalEntryID
	left outer join Users U2 on U2.UserID = G2.Editor
	left join Preferences P2 on P2.UserID = U2.UserID AND P2.SiteID = @siteid
	inner join Users SubEditor on SubEditor.UserID = AR.SubEditorID
	left join Preferences SubEditorPreferences on SubEditorPreferences.UserID = SubEditor.UserID AND SubEditorPreferences.SiteID = @siteid
	where AR.Status = 2
)
select distinct AR.EntryID, G1.h2g2ID, G1.Editor,
	'EditorName' = U1.Username,
	U1.FIRSTNAMES as EditorFirstNames, U1.LASTNAME as EditorLastName, U1.AREA as EditorArea, U1.STATUS as EditorStatus, U1.TAXONOMYNODE as EditorTaxonomyNode, U1.JOURNAL as EditorJournal, U1.ACTIVE as EditorActive,
	P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle,
	'AuthorID' = G2.Editor,
	'AuthorName' = U2.Username,
	U2.FIRSTNAMES as AuthorFirstNames, U2.LASTNAME as AuthorLastName, U2.AREA as AuthorArea, U2.STATUS as AuthorStatus, U2.TAXONOMYNODE as AuthorTaxonomyNode, U2.JOURNAL as AuthorJournal, U2.ACTIVE as AuthorActive,
	P2.SITESUFFIX as AuthorSiteSuffix, P2.TITLE as AuthorTitle,
	AR.SubEditorID,
	--'SubEditorName' = (select Username from Users where UserID = AR.SubEditorID),
	'SubEditorName' = SubEditor.Username,
	SubEditor.FIRSTNAMES as SubEditorFirstNames, SubEditor.LASTNAME as SubEditorLastName, SubEditor.AREA as SubEditorArea, SubEditor.STATUS as SubEditorStatus, SubEditor.TAXONOMYNODE as SubEditorTaxonomyNode, SubEditor.JOURNAL as SubEditorJournal, SubEditor.ACTIVE as SubEditorActive,
	SubEditorPreferences.SITESUFFIX as SubEditorSiteSuffix, SubEditorPreferences.TITLE as SubEditorTitle,
	AR.DateAllocated,
	AR.NotificationSent,
	G1.Status, G1.Style, G1.Subject, G1.DateCreated
from AcceptedRecommendations AR
inner join allocatedunreturnedrecommendations AUR on AUR.EntryID = AR.EntryID
inner join GuideEntries G1 on G1.EntryID = AR.EntryID
inner join Users U1 on U1.UserID = G1.Editor
left join Preferences P on P.UserID = U1.UserID AND P.SiteID = @siteid
left outer join GuideEntries G2 on G2.EntryID = AR.OriginalEntryID
left outer join Users U2 on U2.UserID = G2.Editor
left join Preferences P2 on P2.UserID = U2.UserID AND P2.SiteID = @siteid
inner join Users SubEditor on SubEditor.UserID = AR.SubEditorID
left join Preferences SubEditorPreferences on SubEditorPreferences.UserID = SubEditor.UserID AND SubEditorPreferences.SiteID = @siteid
where n > @skip AND n <=(@skip+@show)
return (0)
