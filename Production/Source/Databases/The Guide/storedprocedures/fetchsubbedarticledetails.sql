CREATE PROCEDURE fetchsubbedarticledetails @h2g2id int
As
SELECT a.*, g.h2g2ID, g.Subject, 
	'Originalh2g2ID' = g1.h2g2ID,
	'SubEditorName' = u.UserName,
	'AcceptorName' = u1.UserName,
	'AllocatorName' = u2.UserName
	FROM AcceptedRecommendations a
	INNER JOIN GuideEntries g ON g.EntryID = a.EntryID
	INNER JOIN GuideEntries g1 ON g1.EntryID = a.OriginalEntryID
	LEFT OUTER JOIN Users u ON u.UserID = a.SubEditorID
	LEFT OUTER JOIN Users u1 ON u1.UserID = a.AcceptorID
	LEFT OUTER JOIN Users u2 ON u2.UserID = a.AllocatorID
	WHERE g.h2g2ID = @h2g2id OR g1.h2g2ID = @h2g2id
	ORDER BY a.RecommendationID