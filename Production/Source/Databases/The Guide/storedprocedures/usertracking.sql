Create Procedure usertracking @userid int
As
	SELECT	'Activity' = 'ForumPosts', 
			'Table' = 'ThreadEntries',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM ThreadEntries WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'PagesAsEditor', 
			'Table' = 'GuideEntries',
			'Field' = 'Editor',
			'number' = COUNT(*) FROM GuideEntries WHERE Editor = @userid
	UNION
	SELECT	'Activity' = 'PagesAsResearcher', 
			'Table' = 'Researchers',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM Researchers WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'EditMarks', 
			'Table' = 'EditMarks',
			'Field' = 'Editor',
			'number' = COUNT(*) FROM EditMarks WHERE Editor = @userid
	UNION
	SELECT	'Activity' = 'EditHistory', 
			'Table' = 'EditHistory',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM EditHistory WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'ArticleViews', 
			'Table' = 'ArticleViews',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM ArticleViews WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'ActivityLog', 
			'Table' = 'ActivityLog',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM ActivityLog WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'Favourites', 
			'Table' = 'Favourites',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM Favourites WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'PeopleWatch', 
			'Table' = 'PeopleWatch',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM PeopleWatch WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'PeopleWatched', 
			'Table' = 'PeopleWatch',
			'Field' = 'WatchUserID',
			'number' = COUNT(*) FROM PeopleWatch WHERE WatchUserID = @userid
	UNION
	SELECT	'Activity' = 'Sessions', 
			'Table' = 'Sessions',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM Sessions WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'ViewedMovies', 
			'Table' = 'ViewedMovies',
			'Field' = 'UserID',
			'number' = COUNT(*) FROM ViewedMovies WHERE UserID = @userid
	UNION
	SELECT	'Activity' = 'Journal', 
			'Table' = 'Forums',
			'Field' = 'JournalOwner',
			'number' = COUNT(*) FROM Forums WHERE JournalOwner = @userid
	return (0)