CREATE PROCEDURE hasuseralreadyvoted @ivoteid int, @iuserid int
As
-- check to see if the user belongs to the club
SELECT 'AlreadyVoted' =
CASE WHEN EXISTS
(
SELECT UserID FROM VoteMembers WHERE UserID = @iuserid AND VoteID = @ivoteid
) THEN 1
ELSE 0
END