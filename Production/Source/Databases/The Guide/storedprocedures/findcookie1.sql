CREATE  PROCEDURE findcookie1 @cookie uniqueidentifier
AS
RAISERROR('findcookie1 DEPRECATED',16,1)
return (0)
-- This has been deprecated
/*
INSERT INTO ActivityLog (LogDate, UserID, LogType) SELECT getdate(), UserID, 'ONLN' FROM Users WHERE Cookie = @cookie AND Status <> 0
SELECT UserID, Cookie, email, UserName, Password, FirstNames, LastName, Active, Masthead, DateJoined, Status, Anonymous, Journal
FROM Users
WHERE Cookie = @cookie
AND Status <> 0

*/
