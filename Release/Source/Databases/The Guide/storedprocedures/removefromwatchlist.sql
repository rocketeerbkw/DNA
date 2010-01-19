Create Procedure removefromwatchlist @userid int, @watchuserid int
As
	DECLARE @username varchar(255), @checkname int
	SELECT @username = UserName, @checkname = UserID FROM Users WHERE UserID = @watchuserid
	IF @checkname IS NOT NULL
	BEGIN
		DELETE FROM PeopleWatch WHERE UserID = @userid AND WatchUserID = @watchuserid
 		SELECT 'UserName' = @username, 'Success' = 1
	END
	SELECT 'UserName' = NULL, 'Success' = 0
	return (0)