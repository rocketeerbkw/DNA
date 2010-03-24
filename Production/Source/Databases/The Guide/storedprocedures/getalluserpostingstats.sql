Create Procedure getalluserpostingstats @userid int
As
		SELECT c.Cnt, c.ThreadID, t.FirstSubject, t.ForumID, u.UserName, c.MostRecent
		FROM Threads t
		INNER JOIN (SELECT 'Cnt' = COUNT (*), 'Min' = MIN(DatePosted), ThreadID, 'MostRecent' = MAX(DatePosted) FROM ThreadEntries
		WHERE UserID = @userid AND (Hidden <> 1 OR Hidden IS NULL)
		GROUP BY ThreadID) AS c ON c.ThreadID = t.ThreadID
		INNER JOIN Users u ON u.UserID = @userid
		ORDER BY c.MostRecent DESC
