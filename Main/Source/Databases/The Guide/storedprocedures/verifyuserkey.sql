CREATE PROCEDURE verifyuserkey @userid int, @key int
As
RAISERROR('verifyuserkey DEPRECATED',16,1)

/* deprecated - never called

declare @cookie uniqueidentifier, 
		@active int, 
		@sinbin int, 
		@status int, 
		@email varchar(255),
		@datereleased datetime

SELECT @email = email, @cookie = Cookie, @active = Active, @status = Status, @sinbin = SinBin, @datereleased = DateReleased FROM Users WHERE UserID = @userid
declare @checksum int
IF @status = 0
BEGIN
	IF @sinbin = 1
	BEGIN
		SELECT 'Result' = 2, 'Reason' = 'This account has been suspended until ', 'DateReleased' = @datereleased, 'Active' = 0
	END
	ELSE
	BEGIN
		SELECT 'Result' = 1, 'Reason' = 'This account has been suspended', 'Active' = 0
	END
END
ELSE
BEGIN
	EXEC checksumcookie @cookie, @checksum OUTPUT
	IF @checksum = @key	
	BEGIN
		SELECT 'Result' = 0, 'Reason' = 'Account verified', 'Email' = @email, 'Active' = @active
	END
	ELSE
	BEGIN
		SELECT 'Result' = 3, 'Reason' = 'The key does not match the account', 'Active' = 0
	END
END
*/