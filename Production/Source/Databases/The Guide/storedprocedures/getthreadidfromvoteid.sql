CREATE PROCEDURE getthreadidfromvoteid @voteid int
As
SELECT 'ObjectID' = ThreadID FROM ThreadVotes WHERE VoteID = @VoteID