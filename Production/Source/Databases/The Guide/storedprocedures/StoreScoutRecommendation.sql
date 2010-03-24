/*
	Procedure to add a new scout recommendation to the ScoutRecommendations table.
	It will fail if the entry is already in the recommendation table, or if it does not have a status
	of 3 (user entry, public), but does not do any other checking.

	It returns the ID for this recommendation, whether or not it was already recommended and if so
	the user ID and username of the person who did so, and also returns whether the entry had an invalid
	status.
*/
create procedure storescoutrecommendation
					@entryid int,
					@scoutid int,
					@comments text = null
as
declare @RecommendationID int
declare @AlreadyRecommended bit
declare @UserID int
declare @Username varchar(255)
declare @WrongStatus bit
-- first check if the entry being recommended has an invalid status
if ((select Status from GuideEntries where EntryID = @entryid) <> 3) set @WrongStatus = 1
else set @WrongStatus = 0
-- now check if this entry has already been recommended and has not yet had a decision made on it
-- if it has been recommended previously and had a decision it is okay to recommend it again if it's
-- status allows this (this will mean it was rejected)
-- status 1 = 'Recommended', status 3 = 'Accepted'
if ((select count(EntryID) from ScoutRecommendations where EntryID = @entryid and (Status = 1 or Status = 3)) > 0)
begin
	-- if already recommended and awaiting a decision get some info on who recommended it
	set @AlreadyRecommended = 1
	set @RecommendationID = null
	select @UserID = UserID, @Username = Username from Users where UserID in (select ScoutID from ScoutRecommendations where EntryID = @entryid and (Status = 1 or Status = 3))
end
else if (@WrongStatus = 0)
begin
	-- only add it to the table if status is okay and it is not already there pending a decision
	set @AlreadyRecommended = 0
	insert into ScoutRecommendations (EntryID, ScoutID, DateRecommended, Comments, Status)
		values (@entryid, @scoutid, getdate(), @comments, 1)
	set @RecommendationID = @@identity
end
-- return all the info we have got
select	'RecommendationID' = @RecommendationID,
		'AlreadyRecommended' = @AlreadyRecommended,
		'UserID' = @UserID,
		'Username' = @Username,
		'WrongStatus' = @WrongStatus,
		'Success' = case
						when (@AlreadyRecommended = 0 and @WrongStatus = 0) then 1
						else 0
					end
return (0)
