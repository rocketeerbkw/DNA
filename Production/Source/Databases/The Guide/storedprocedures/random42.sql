Create Procedure random42
As
	SELECT  u.UserID, UserName, email, LogDate FROM ActivityLog a INNER JOIN Users u ON u.UserID = a.UserID 
		WHERE LogDate < '28 Apr 1999 21:00:00'

	return (0)