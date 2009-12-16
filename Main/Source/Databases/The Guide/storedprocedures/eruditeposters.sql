CREATE Procedure eruditeposters @siteid int
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
				INNER JOIN forums fs  on t.forumid = fs.forumid
			WHERE DatePosted > DATEADD(day, -1, getdate()) AND siteid = @siteid AND (Hidden IS NULL)
			GROUP BY UserID) As c 
		ON c.UserID = u.UserID 
	WHERE c.cnt >= 5
	ORDER BY ratio DESC