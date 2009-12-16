CREATE PROCEDURE loginlocaluser	@loginname varchar(255), @password varchar(255)
as
SELECT UserID, Username, LoginName, Cookie, BBCUID
	FROM Users 
	WHERE LoginName = @loginname AND @password = Password