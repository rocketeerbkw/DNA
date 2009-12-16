CREATE PROCEDURE getclubidfromvoteid @voteid int
As
SELECT 'ObjectID' = ClubID FROM ClubVotes WHERE VoteID = @voteid