CREATE Procedure prolificposters @siteid int
As

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT TOP 10	c.cnt, 
				c.UserID, 
				c.totlength, 
				'ratio' = c.totlength / c.cnt, 
				'UserName' = 
					CASE 
					WHEN u.UserName IS NULL OR u.UserName = '' 
						THEN 'Researcher ' + CAST(u.UserID AS varchar) 
						ELSE u.UserName 
					END 
	FROM Users u 
	INNER JOIN 
		(SELECT 'cnt' = COUNT(*), 
				'totlength' = SUM(DATALENGTH(t.text)), 
				UserID 
			FROM ThreadEntries t
				INNER JOIN forums f ON f.forumid = t.forumid
			WHERE (Hidden IS NULL) 
				AND DatePosted > DATEADD(day, -1, getdate()) 
				AND f.siteid = @siteid
			GROUP BY UserID) As c 
		ON c.UserID = u.UserID 
	ORDER BY c.cnt DESC