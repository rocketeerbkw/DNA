/*
	Fetches a list of all the scout recommendations that have been accepted
	and not yet allocated.
	Currently only gets the article info though, no data about the scout or
	the recommendation.
*/

create procedure fetchunallocatedacceptedrecommendations @siteid int = 0, @show int = 10000, @skip int =0
as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


set @show = @show + 1 -- add one

-- should not be duplicate entries, but do not fetch them if there are
-- status 1 = 'Accepted'
;WITH unallocatedacceptedrecommendations AS
(
	select distinct AR.EntryID, ROW_NUMBER() OVER(ORDER BY SR.DecisionDate asc) n
	from AcceptedRecommendations AR
	inner join GuideEntries G on G.EntryID = AR.EntryID
	inner join Users U on U.UserID = G.Editor
	left join Preferences P on P.UserID = U.UserID AND P.SiteID = @siteid
	left outer join GuideEntries G2 on G2.EntryID = AR.OriginalEntryID
	left outer join Users U2 on U2.UserID = G2.Editor
	left join Preferences P2 on P2.UserID = U2.UserID AND P2.SiteID = @siteid
	inner join ScoutRecommendations SR on SR.RecommendationID = AR.RecommendationID
	inner join Journals J on J.UserID = U.UserID and J.SiteID = @siteid
	inner join Journals J2 on J2.UserID = U2.UserID and J2.SiteID = @siteid
	where AR.Status = 1
)
select distinct AR.EntryID, G.h2g2ID, G.Editor,
	'EditorName' = U.Username, U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
	P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle,
	'AuthorID' = G2.Editor,
	'AuthorName' = U2.Username, U2.FIRSTNAMES as AuthorFirstNames, U2.LASTNAME as AuthorLastName, U2.AREA as AuthorArea, U2.STATUS as AuthorStatus, U2.TAXONOMYNODE as AuthorTaxonomyNode, J2.ForumID as AuthorJournal, U2.ACTIVE as AuthorActive,
	P2.SITESUFFIX as AuthorSiteSuffix, P2.TITLE as AuthorTitle,
	SR.DecisionDate,
	G.Status, G.Style, G.Subject, G.DateCreated
from AcceptedRecommendations AR
inner join unallocatedacceptedrecommendations UAR on UAR.EntryID = AR.EntryID
inner join GuideEntries G on G.EntryID = AR.EntryID
inner join Users U on U.UserID = G.Editor
left join Preferences P on P.UserID = U.UserID AND P.SiteID = @siteid
left outer join GuideEntries G2 on G2.EntryID = AR.OriginalEntryID
left outer join Users U2 on U2.UserID = G2.Editor
left join Preferences P2 on P2.UserID = U2.UserID AND P2.SiteID = @siteid
inner join ScoutRecommendations SR on SR.RecommendationID = AR.RecommendationID
inner join Journals J on J.UserID = U.UserID and J.SiteID = @siteid
inner join Journals J2 on J2.UserID = U2.UserID and J2.SiteID = @siteid
where n > @skip AND n <=(@skip+@show)
return (0)
