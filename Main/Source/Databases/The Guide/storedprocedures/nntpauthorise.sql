Create Procedure nntpauthorise @userid int, @password varchar(255)
As
SELECT * FROM Users WHERE UserID = @userid AND Password = @password AND Active = 1
	return (0)