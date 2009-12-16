Create Procedure getallusers
As
		SELECT u.UserID, u.email, u.UserName , a.LogDate 
		FROM Users u INNER JOIN ActivityLog a ON a.UserID = u.UserID
		WHERE a.LogType = 'ACTI'
		ORDER BY a.LogDate DESC
