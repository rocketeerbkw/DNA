CREATE   PROCEDURE threadlistposts @threadid int, @userid int = NULL, @ignorebozos int = 0, @showmax int = 0
AS
declare @select varchar(4096)

IF @showmax > 0
BEGIN
IF @userid IS NULL
BEGIN
		SELECT @select = 'SELECT TOP ' + CAST(@showmax AS varchar) + '
			ForumID, 
			ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.UserName, 
			''Subject'' = CASE Subject WHEN '''' THEN ''No Subject'' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			Hidden,
			''Interesting'' = NULL,
			t.text 
	FROM ThreadEntries t, Users u
	WHERE t.UserID = u.UserID AND t.ThreadID = ' + CAST(@threadid AS varchar) + '
	ORDER BY DatePosted DESC'

EXEC(@select)
END
ELSE
	IF @ignorebozos = 0
	BEGIN
		SELECT @select = 'SELECT TOP ' + CAST(@showmax AS varchar) + ' 
			ForumID, 
			ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.UserName, 
			''Subject'' = CASE Subject WHEN '''' THEN ''No Subject'' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			''Hidden'' = 
				CASE t.Hidden 
					WHEN 1 THEN 1 
					ELSE 
					CASE p.WatchType 
						WHEN 2 THEN 1 
						ELSE NULL 
					END 
				END, 
			''Interesting'' = 
				CASE p.WatchType
					WHEN 1 THEN 1
					ELSE 0
				END,
			t.text 
		FROM ThreadEntries t
		INNER JOIN Users u ON t.UserID = u.UserID
		LEFT JOIN PeopleWatch p ON p.UserID = ' + CAST(@userid AS varchar) +' AND p.WatchUserID = t.UserID
		WHERE t.ThreadID = ' + CAST(@threadid AS varchar) + '
		ORDER BY DatePosted DESC'
	EXEC(@select)
	END
	ELSE
	BEGIN
		SELECT @select = 'SELECT TOP ' + CAST(@showmax AS varchar) + '			
			ForumID, 
			ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.UserName, 
			''Subject'' = CASE Subject WHEN '''' THEN ''No Subject'' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			''Hidden'' = 
				CASE t.Hidden 
					WHEN 1 THEN 1 
					ELSE 
					CASE p.WatchType 
						WHEN 2 THEN 1 
						ELSE NULL 
					END 
				END, 
			''Interesting'' = 
				CASE p.WatchType
					WHEN 1 THEN 1
					ELSE 0
				END,
			t.text 
		FROM ThreadEntries t
		INNER JOIN Users u ON t.UserID = u.UserID
		LEFT JOIN PeopleWatch p ON (p.UserID = ' + CAST(@userid AS varchar) + ' AND p.WatchUserID = t.UserID) OR (p.UserID = 0 AND p.WatchUserID = t.UserID)
		WHERE t.ThreadID = ' + CAST(@threadid AS varchar) + '
		ORDER BY DatePosted DESC'
	EXEC(@select)
	END


END
ELSE
BEGIN
IF @userid IS NULL
BEGIN
		SELECT 
			ForumID, 
			ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.UserName, 
			'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			Hidden,
			'Interesting' = NULL,
			t.text 
	FROM ThreadEntries t, Users u
	WHERE t.UserID = u.UserID AND t.ThreadID = @threadid
	ORDER BY DatePosted
END
ELSE
	IF @ignorebozos = 0
		SELECT 
			ForumID, 
			ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.UserName, 
			'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			'Hidden' = 
				CASE t.Hidden 
					WHEN 1 THEN 1 
					ELSE 
					CASE p.WatchType 
						WHEN 2 THEN 1 
						ELSE NULL 
					END 
				END, 
			'Interesting' = 
				CASE p.WatchType
					WHEN 1 THEN 1
					ELSE 0
				END,
			t.text 
		FROM ThreadEntries t
		INNER JOIN Users u ON t.UserID = u.UserID
		LEFT JOIN PeopleWatch p ON p.UserID = @userid AND p.WatchUserID = t.UserID
		WHERE t.ThreadID = @threadid
		ORDER BY DatePosted
	ELSE
		SELECT 
			ForumID, 
			ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.UserName, 
			'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			'Hidden' = 
				CASE t.Hidden 
					WHEN 1 THEN 1 
					ELSE 
					CASE p.WatchType 
						WHEN 2 THEN 1 
						ELSE NULL 
					END 
				END, 
			'Interesting' = 
				CASE p.WatchType
					WHEN 1 THEN 1
					ELSE 0
				END,
			t.text 
		FROM ThreadEntries t
		INNER JOIN Users u ON t.UserID = u.UserID
		LEFT JOIN PeopleWatch p ON (p.UserID = @userid AND p.WatchUserID = t.UserID) OR (p.UserID = 0 AND p.WatchUserID = t.UserID)
		WHERE t.ThreadID = @threadid
		ORDER BY DatePosted


END