Create Procedure random42
As
	EXEC openemailaddresskey

	SELECT  u.UserID, UserName, dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) as email, LogDate FROM ActivityLog a INNER JOIN Users u ON u.UserID = a.UserID 
		WHERE LogDate < '28 Apr 1999 21:00:00'

	return (0)