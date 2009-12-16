/*
	Checks this user and this entry ID to see if the user is the sub editor
	currently allocated to subbing this entry.
*/

create procedure checkissubeditor @userid int, @entryid int
as
-- get the recommendation id for a recommendation with this entry ID
-- this user as sub editor, and a status of 'allocated'
declare @RecommendationID int
select @RecommendationID = RecommendationID
from AcceptedRecommendations
where EntryID = @entryid and SubEditorID = @userid and Status = 2
-- if no such recommendation exists then either it has been returned
-- already or this is not the right sub editor
if (isnull(@RecommendationID, 0) > 0) select 'IsSub' = 1
else select 'IsSub' = 0
return (0)
