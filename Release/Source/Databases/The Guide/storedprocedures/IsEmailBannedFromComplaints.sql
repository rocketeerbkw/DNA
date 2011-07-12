CREATE PROCEDURE isemailbannedfromcomplaints @email VARCHAR(255)
AS

EXEC openemailaddresskey

DECLARE @IsBanned INT
SET @IsBanned = 0

-- Check to see if the email exists in the banned email table with the complaints flag set
IF EXISTS (SELECT * FROM dbo.BannedEmails WITH(NOLOCK) WHERE HashedEMail = dbo.udf_hashemailaddress(@email) AND ComplaintBanned = 1)
BEGIN
	SET @IsBanned = 1
END
SELECT 'IsBanned' = @IsBanned