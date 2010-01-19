/*
	Fetches a list of all the current scout recommendations
	Currently only gets the article info though, no data about the scout or
	the recommendation.
*/

create procedure fetchscoutrecommendedarticles
as
-- should not be duplicate entries, but do not fetch them if there are
-- status 1 or 3 = 'Recommended' or 'Accepted', i.e. not rejected recommendations
select distinct SR.EntryID, G.h2g2ID, G.Editor,
	'EditorName' = U.Username,
	SR.DateRecommended,
	G.Status, G.Style, G.Subject, G.DateCreated
from ScoutRecommendations SR
inner join GuideEntries G on G.EntryID = SR.EntryID
inner join Users U on U.UserID = G.Editor
where SR.Status = 1 or SR.Status = 3
order by SR.DateRecommended asc
return (0)
