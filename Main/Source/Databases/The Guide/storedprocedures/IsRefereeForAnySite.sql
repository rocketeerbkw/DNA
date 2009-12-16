CREATE PROCEDURE isrefereeforanysite @userid INT
AS

SELECT COUNT (gm.UserID) NumberOfSites
FROM GroupMembers gm INNER JOIN Groups g ON g.GroupID = gm.GroupID
WHERE g.Name = 'Referee' AND gm.UserID = @userid
