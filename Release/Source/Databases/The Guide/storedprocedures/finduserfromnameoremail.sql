Create Procedure finduserfromnameoremail @nameoremail varchar(255)

-- horrible fat query but 

As
	RAISERROR('finduserfromnameoremail DEPRECATED',16,1)

	return (0)
	-- this procedure is deprecated
	/*
SELECT	u.UserID, 
		Cookie, 
		email, 
		UserName, 
		Password, 
		FirstNames, 
		LastName, 
		Active, 
		Masthead, 
		u.DateJoined, 
		U.Status, 
		Anonymous, 
		Journal, 
		Prefs1,
		PrefForumStyle,
		PrefForumThreadStyle,
		PrefForumShowMaxPosts,
		PrefReceiveWeeklyMailshot,
		PrefReceiveDailyUpdates
FROM Users u 
	LEFT JOIN Preferences p ON p.UserID = u.UserID
WHERE (FirstNames like '%' + @nameoremail + '%' OR LastName like '%' + @nameoremail + '%' OR UserName like '%' + @nameoremail + '%' OR email = @nameoremail) AND U.Status <> 0
	return (0)
	*/