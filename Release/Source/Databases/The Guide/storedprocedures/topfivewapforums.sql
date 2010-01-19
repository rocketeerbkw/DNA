Create Procedure topfivewapforums
As
	SELECT t.ForumID, t.ThreadID, 'DatePosted' = t.LastPosted, t.FirstSubject 
		FROM Threads t
		INNER JOIN TopFives f ON t.ThreadID = f.h2g2ID AND f.GroupName = 'WAPForums'
		ORDER BY f.Rank DESC

	return (0)