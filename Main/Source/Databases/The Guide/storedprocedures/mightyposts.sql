Create Procedure mightyposts
As

SELECT TOP 10	t.UserID,
				t.Subject,
				t.ForumID,
				t.ThreadID,
				t.EntryID,
				'totlength' = DATALENGTH(t.text),
				'UserName' =
					CASE
					WHEN u.UserName IS NULL OR u.UserName = ''
						THEN 'Researcher ' + CAST(u.UserID AS varchar)
						ELSE u.UserName
					END
	FROM Users u WITH(NOLOCK)
	INNER JOIN ThreadEntries t WITH(NOLOCK) ON t.UserID = u.UserID
	WHERE (Hidden IS NULL)
	AND DatePosted > DATEADD(day, -1, getdate())
	ORDER BY totlength DESC




