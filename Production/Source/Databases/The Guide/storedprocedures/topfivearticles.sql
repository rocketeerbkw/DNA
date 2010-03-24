CREATE    PROCEDURE topfivearticles @groupname varchar(50) = 'MostViewed'
AS

SELECT	g.Subject, 
		g.EntryID, 
		g.h2g2ID, 
		'ActualID' = 'A' + CAST(g.h2g2ID AS varchar(40)) 
		FROM TopFives t, 
		GuideEntries g 
		WHERE t.h2g2ID = g.h2g2ID 
		AND GroupName = @groupname 
		ORDER BY t.Rank

