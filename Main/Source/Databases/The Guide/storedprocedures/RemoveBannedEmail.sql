CREATE PROCEDURE removebannedemail @email VARCHAR(255)
AS
DELETE FROM dbo.BannedEMails WHERE Email = @email
