Create Procedure storefordemail @email varchar(255), @userid int
As
	IF @userid <> 0
	BEGIN
		declare @oldemail varchar(255)
		SELECT @oldemail = email FROM Users WHERE UserID = @userid
		IF @oldemail IS NULL
		BEGIN
			UPDATE Users SET email = @email WHERE UserID = @userid
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT email FROM Users WHERE email = @email)
				INSERT INTO Users (email) VALUES(@email)
		END
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT email FROM Users WHERE email = @email)
			INSERT INTO Users (email) VALUES(@email)
	END
	return (0)