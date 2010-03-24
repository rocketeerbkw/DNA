CREATE PROCEDURE updatelocalpassword @loginname varchar(255), @password varchar(255), @newpassword varchar(255)
as
UPDATE Users Set Password = @newpassword where LoginName = @loginname AND Password = @password