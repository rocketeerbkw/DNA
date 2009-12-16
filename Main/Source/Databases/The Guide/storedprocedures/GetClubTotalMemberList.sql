CREATE PROCEDURE getclubtotalmemberlist @siteid INT
AS
	/* Returns a list of clubs with owner and member counts. */
	SELECT c.ClubID, c.Name, COUNT(owners.UserID) AS 'Owner count', COUNT(members.UserID) AS 'Member count'
	  FROM dbo.Clubs c WITH (NOLOCK)
		   INNER JOIN dbo.TeamMembers owners WITH (NOLOCK) ON owners.TeamID = c.OwnerTeam 
		   LEFT JOIN dbo.TeamMembers members WITH (NOLOCK) ON owners.TeamID = c.MemberTeam 
	 WHERE c.SiteID = @siteid
	 GROUP BY c.ClubID, c.Name

RETURN @@ERROR