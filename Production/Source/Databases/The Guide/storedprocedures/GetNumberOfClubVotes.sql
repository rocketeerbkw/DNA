CREATE PROCEDURE getnumberofclubvotes @siteid INT, @response int, @startdate datetime, @enddate datetime
AS
	/* Returns total number of votes cast on clubs within a date range. */

	SELECT count (vm.VoteID)
	  FROM dbo.Clubs c WITH (NOLOCK)
			INNER JOIN dbo.ClubVotes cv WITH (NOLOCK) ON cv.ClubID = c.ClubID
			INNER JOIN dbo.VoteMembers vm WITH (NOLOCK) ON vm.VoteID = cv.VoteID
	 WHERE c.SiteID = @siteid
	   AND vm.Response = @response
	   AND vm.DateVoted BETWEEN @startdate AND @enddate

RETURN @@ERROR 