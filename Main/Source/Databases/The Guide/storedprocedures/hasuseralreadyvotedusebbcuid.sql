CREATE PROCEDURE hasuseralreadyvotedusebbcuid @ivoteid int, @uid uniqueidentifier
As
-- check to see if the user belongs to the club
SELECT 'AlreadyVoted' =
CASE WHEN EXISTS
(
SELECT UserID FROM VoteMembers WHERE UID = @uid AND VoteID = @ivoteid
) THEN 1
ELSE 0
END