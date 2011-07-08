CREATE PROCEDURE removebannedemail @email VARCHAR(255)
AS
EXEC openemailaddresskey

DELETE FROM dbo.BannedEMails WHERE HashedEmail = dbo.udf_hashemailaddress(@email)
