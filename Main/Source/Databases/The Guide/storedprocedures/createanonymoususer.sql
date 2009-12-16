Create Procedure createanonymoususer
As
declare @cookie uniqueidentifier
SELECT @cookie = newid()
INSERT INTO Users (Cookie, Anonymous) VALUES (@cookie, 0)
SELECT 'Cookie' = @cookie, 'UserID' = @@IDENTITY
	return (0)