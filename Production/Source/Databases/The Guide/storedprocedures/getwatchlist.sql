Create Procedure getwatchlist @userid int
As
	SELECT WatchUserID, WatchType, UserName
		FROM PeopleWatch p, Users u
		WHERE p.UserID = @userid AND p.WatchUserID = u.UserID
		ORDER BY WatchType
	return (0)