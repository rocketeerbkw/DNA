CREATE PROCEDURE getnumberofuserssendingprivatemessages @startdate datetime, @enddate datetime
AS
	/* Returns the number of users sending private messages. */

	SELECT COUNT(DISTINCT(te.UserID))
	  FROM Users u WITH (NOLOCK)
			INNER JOIN UserTeams ut ON ut.UserID = u.UserID
			INNER JOIN Teams tm WITH (NOLOCK) ON tm.TeamID = ut.TeamID
			INNER JOIN Forums f WITH (NOLOCK) ON f.ForumID  = tm.ForumID
			INNER JOIN ThreadEntries te WITH (NOLOCK) ON te.ForumID = f.ForumID
	  WHERE te.DatePosted BETWEEN @startdate AND @enddate

RETURN @@ERROR