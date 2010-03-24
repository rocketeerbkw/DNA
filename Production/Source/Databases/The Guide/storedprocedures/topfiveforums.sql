CREATE Procedure topfiveforums @groupname varchar(50) = 'MostThreads'
As
	SELECT	f.ForumID,  
			CASE WHEN f.Title = '' 
				THEN 'No Subject' 
				WHEN u.UserName IS NOT NULL
				THEN 'Journal of ' + u.UserName
				ELSE f.Title 
				END as Title, 
			t.Rank 
		FROM TopFives t 
		INNER JOIN Forums f ON f.ForumID = t.h2g2ID
		LEFT JOIN Journals J on J.ForumID = t.h2g2id
		LEFT JOIN Users u ON u.UserID = J.UserID
		WHERE GroupName = @groupname ORDER BY Rank
	return (0)



