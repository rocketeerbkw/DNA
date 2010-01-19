CREATE PROCEDURE isemailinbannedlist @email VARCHAR(255)
AS
DECLARE @IsBanned INT
SET @IsBanned = 0

-- Check to see if the email is in the banned emails list with the sign in banned flag set
IF EXISTS (SELECT * FROM dbo.BannedEmails WITH(NOLOCK) WHERE EMail = @email AND SignInBanned = 1)
BEGIN
	SET @IsBanned = 1
END
SELECT 'IsBanned' = @IsBanned