CREATE PROCEDURE getnumberofusersvotingonclubs @siteid INT, @startdate datetime, @enddate datetime
AS
	/* Returns the number of users that have voted on clubs. */

	SELECT COUNT (DISTINCT vm.UserID)
	  FROM dbo.Clubs c WITH (NOLOCK)
			INNER JOIN dbo.ClubVotes cv WITH (NOLOCK) ON cv.ClubID = c.ClubID
			INNER JOIN dbo.VoteMembers vm WITH (NOLOCK) ON vm.VoteID = cv.VoteID
	 WHERE c.SiteID = @siteid
	   AND vm.DateVoted BETWEEN @startdate AND @enddate

RETURN @@ERROR 