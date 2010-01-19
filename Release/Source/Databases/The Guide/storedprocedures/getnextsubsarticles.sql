CREATE Procedure getnextsubsarticles @userid int
As
	INSERT INTO SubsArticles (UserId, EntryID)
	SELECT TOP 2 @userid, g.EntryID
		FROM GuideEntries g 
		INNER JOIN
		(
			SELECT EntryID, 'DatePerformed' = MAX(DatePerformed) 
				FROM EditHistory 
				WHERE Action = 5 
				GROUP BY EntryID
		) e
			ON e.EntryID = g.EntryID
	WHERE	g.Status = 4 
			/* AND g.EntryID > 20512 - Temporary hack until manual Sub-Editor Queue clears*/
			AND g.EntryID NOT IN 
			(
				SELECT EntryID 
					FROM SubsArticles 
					WHERE ReturnDate IS NULL
			)
	ORDER BY e.DatePerformed
	return (0)
