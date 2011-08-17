Create Procedure getallusers
As
/*

	-- Pretty sure this is not used anymore
	
		EXEC openemailaddresskey;

		SELECT u.UserID, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) as email, u.UserName , a.LogDate 
		FROM Users u INNER JOIN ActivityLog a ON a.UserID = u.UserID
		WHERE a.LogType = 'ACTI'
		ORDER BY a.LogDate DESC
*/