Create Procedure getbusiestforums @since datetime = '1 Jan 1990'
As
		SELECT c.Cnt, c.ThreadID, t.FirstSubject, t.ForumID, c.MostRecent
		FROM Threads t
		INNER JOIN (SELECT 'Cnt' = COUNT (*), 'Min' = MIN(DatePosted), ThreadID, 'MostRecent' = MAX(DatePosted) FROM ThreadEntries
		WHERE DatePosted > @since AND (Hidden IS NULL)
		GROUP BY ThreadID) AS c ON c.ThreadID = t.ThreadID
		ORDER BY c.MostRecent DESC
