Create Procedure getalluserpages		@userid int, 
										@status int, 
										@status2 int = NULL, 
										@status3 int = NULL, 
										@status4 int = NULL, 
										@status5 int = NULL, 
										@status6 int = NULL
As
	SELECT DISTINCT g.Subject, g.h2g2ID,g.DateCreated, u.UserName, g.Status
	FROM GuideEntries g
		INNER JOIN Researchers r ON r.EntryID = g.EntryID
		INNER JOIN Users u ON u.UserID = @userid
	WHERE (g.Editor = @userid OR r.UserID = @userid) 
		AND (g.Status = @status
			OR g.Status = @status2
			OR g.Status = @status3
			OR g.Status = @status4
			OR g.Status = @status5
			OR g.Status = @status6
			)
	ORDER BY DateCreated DESC
	return (0)
