Create Procedure setusername @userid int, @username varchar(255)
As
UPDATE Users SET UserName = @username WHERE UserID = @userid
	return (0)