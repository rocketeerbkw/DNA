Create Procedure addbozo		@userid int, @bozoid int
As
	DECLARE @username varchar(255), @checkname int
	SELECT @username = UserName, @checkname = UserID FROM Users WHERE UserID = @bozoid
	IF @checkname IS NOT NULL
	BEGIN
		INSERT INTO PeopleWatch (UserID, WatchUserID, WatchType)
			VALUES (@userid, @bozoid, 2)
		SELECT 'UserName' = @username, 'Success' = 1
	END
	SELECT 'UserName' = NULL, 'Success' = 0
	return (0)