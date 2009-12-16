CREATE    PROCEDURE activateuserwithpassword @userid int, @password varchar(255) 
AS
SELECT UserID, Cookie, 'bAlreadyActive' = Active FROM Users WHERE UserID = @userid AND Password = @password AND Password <> ''
