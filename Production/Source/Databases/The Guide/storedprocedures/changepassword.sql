CREATE PROCEDURE changepassword @userid int, @newpassword varchar(255)
As
UPDATE Users SET Password = @newpassword WHERE UserID = @userid