/*
	Fetches a list of all the current scout recommendations that have not
	yet had a decision by a staff meember
*/

create procedure fetchundecidedrecommendations @siteid int = 0
as
-- should not be duplicate entries, but do not fetch them if there are
-- status 1 = 'Recommended'
select distinct SR.RecommendationID, SR.EntryID, G.h2g2ID, G.Editor,
	'EditorName' = U.Username,
	SR.DateRecommended,
	SR.ScoutID,
	'ScoutName' = (select Username from Users where UserID = ScoutID),
	G.Status, 
	G.Type, 
	G.Style, 
	G.Subject, 
	G.DateCreated,
	U.FIRSTNAMES as EditorFirstNames, 
	U.LASTNAME as EditorLastName, 
	U.AREA as EditorArea, 
	U.STATUS as EditorStatus, 
	U.TAXONOMYNODE as EditorTaxonomyNode, 
	U.JOURNAL as EditorJournal, 
	U.ACTIVE as EditorActive, 
	P.SITESUFFIX as EditorSiteSuffix, 
	P.TITLE as EditorTitle,
	Scout.FirstNames as ScoutFirstNames, 
	Scout.LastName as ScoutLastName, 
	Scout.Area as ScoutArea, 
	Scout.Status as ScoutStatus, 
	Scout.TaxonomyNode as ScoutTaxonomyNode, 
	J.ForumID as ScoutJournal, 
	Scout.Active as ScoutActive, 
	ScoutPreferences.SiteSuffix as 
	ScoutSiteSuffix, 
	ScoutPreferences.Title as ScoutTitle
from ScoutRecommendations SR
inner join GuideEntries G on G.EntryID = SR.EntryID
inner join Users Scout on Scout.UserID = SR.ScoutID
left join Preferences ScoutPreferences on ScoutPreferences.UserID = Scout.UserID AND ScoutPreferences.SiteID = @siteid
inner join Users U on U.UserID = G.Editor
left join Preferences P on P.UserID = G.Editor AND P.SiteID = @siteid
inner join Journals J on J.UserID = Scout.UserID and J.SiteID = @siteid
where SR.Status = 1
order by SR.DateRecommended asc
return (0)
