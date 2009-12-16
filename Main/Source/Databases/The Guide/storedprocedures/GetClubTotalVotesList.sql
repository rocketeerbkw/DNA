CREATE PROCEDURE getclubtotalvoteslist @siteid INT, @response INT
AS
	/* Lists clubs with total number of votes. */
	SELECT c.ClubID, c.Name, COUNT(vm.VoteID)
	  FROM dbo.Clubs c WITH (NOLOCK)
		   INNER JOIN dbo.ClubVotes cv WITH (NOLOCK) ON cv.ClubID = c.ClubID
		   LEFT JOIN dbo.VoteMembers vm WITH (NOLOCK) ON vm.VoteID = cv.VoteID AND vm.Response = @response AND vm.UserID > 0 AND vm.Visible = 1
	 WHERE c.SiteID = @siteid
	 GROUP BY c.ClubID, c.Name

RETURN @@ERROR 