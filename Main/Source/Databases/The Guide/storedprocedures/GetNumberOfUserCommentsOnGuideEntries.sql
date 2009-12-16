CREATE PROCEDURE getnumberofusercommentsonguideentries @siteid INT, @type INT, @startdate datetime, @enddate datetime
AS
	/* Returns the number of user comments on GuideEntries of a certain type that were created in a daterange. */
	SELECT COUNT(te.EntryID)
	  FROM dbo.GuideEntries ge WITH (NOLOCK)
		   INNER JOIN dbo.Forums f WITH (NOLOCK) ON f.ForumID = ge.ForumID
		   INNER JOIN dbo.ThreadEntries te WITH (NOLOCK) ON te.ForumID = f.ForumID
		   INNER JOIN dbo.Users u WITH (NOLOCK) ON u.UserID = te.UserID
	 WHERE ge.SiteID = @siteid
	   AND ge.Type =  @type
	   AND te.DatePosted BETWEEN @startdate AND @enddate
	   AND u.Status = 1 
	   AND NOT EXISTS (SELECT 1
						 FROM dbo.GroupMembers gm
						WHERE gm.UserID = u.UserID
						  AND gm.SiteID = @siteid
						  AND gm.GroupID IN (8, 198, 205, 207, 214)) 

RETURN @@ERROR