Create Procedure getanyuserpages		@status int, 
										@status2 int = NULL, 
										@status3 int = NULL, 
										@status4 int = NULL, 
										@status5 int = NULL, 
										@status6 int = NULL
As
	SELECT g.Subject, g.h2g2ID,g.DateCreated, g.Status
	FROM GuideEntries g
	WHERE (g.Status = @status
			OR g.Status = @status2
			OR g.Status = @status3
			OR g.Status = @status4
			OR g.Status = @status5
			OR g.Status = @status6
			)
	ORDER BY DateCreated DESC
	return (0)
