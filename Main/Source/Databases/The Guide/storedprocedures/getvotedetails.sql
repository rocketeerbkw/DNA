CREATE PROCEDURE getvotedetails @ivoteid int
As
DECLARE @iCount int
SELECT @iCount = COUNT(*) FROM ClubVotes WHERE VoteID = @ivoteid
IF (@iCount > 0)
BEGIN
	SELECT v.*, 'VoteName' = c.Name FROM Votes v
	INNER JOIN ClubVotes cv ON v.voteid = cv.voteid
	INNER JOIN Clubs c ON c.ClubID = cv.ClubID
	WHERE v.VoteID = @ivoteid
	RETURN
END

SELECT @iCount = COUNT(*) FROM ThreadVotes WHERE VoteID = @ivoteid
IF (@iCount > 0)
BEGIN
	SELECT v.*, 'VoteName' = t.Subject FROM Votes v
	INNER JOIN ThreadVotes tv ON v.voteid = tv.voteid
	INNER JOIN threadentries t ON t.ThreadID = tv.ThreadID
	WHERE v.VoteID = @ivoteid
	RETURN
END
