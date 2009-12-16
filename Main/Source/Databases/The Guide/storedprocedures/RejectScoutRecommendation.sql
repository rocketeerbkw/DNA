/*
	Sets a scouts recommendations status to rejected (2) and optionally
	replaces the comments with staff comments.
*/

create procedure rejectscoutrecommendation
	@recommendationid int,
	@comments text = null
as
-- can only reject recommendations that have no decision as yet
update ScoutRecommendations
set Status = 2, DecisionDate = getdate(), Comments = isnull(@comments, Comments)
where RecommendationID = @recommendationid and Status = 1
-- return a field to indicate success if the specified id exists and no error occurred
-- also return data required to send a personalised email to scout
if ((select count(RecommendationID)
	 from ScoutRecommendations
	 where RecommendationID = @recommendationid and Status = 2) > 0)
begin
	select 'Success' = 1, 'ScoutEmail' = U.Email, 'ScoutName' = U.Username, G.h2g2ID, G.Subject, SR.DateRecommended
	from ScoutRecommendations SR
	inner join Users U on U.UserID = SR.ScoutID
	inner join GuideEntries G on G.EntryID = SR.EntryID
	where SR.RecommendationID = @recommendationid
end
else select 'Success' = 0
return (0)
