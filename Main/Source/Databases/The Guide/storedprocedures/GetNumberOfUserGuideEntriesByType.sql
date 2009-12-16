CREATE PROCEDURE getnumberofuserguideentriesbytype @siteid INT, @type INT, @startdate datetime, @enddate datetime
AS
	/* Returns the total number of user generated GuideEntries of a certain type that were created in a daterange. */
	SELECT COUNT(ge.h2g2ID)
	  FROM dbo.GuideEntries ge WITH (NOLOCK)
	       INNER JOIN dbo.Users u WITH (NOLOCK) ON u.UserID = ge.Editor
	 WHERE ge.SiteID = @siteid
	   AND ge.Type =  @type
	   AND u.Status = 1 
	   AND NOT EXISTS (SELECT 1
						 FROM dbo.GroupMembers gm
						WHERE gm.UserID = u.UserID
						  AND gm.SiteID = @siteid
						  AND gm.GroupID IN (8, 198, 205, 207, 214)) 
	   AND ge.DateCreated BETWEEN @startdate AND @enddate

RETURN @@ERROR