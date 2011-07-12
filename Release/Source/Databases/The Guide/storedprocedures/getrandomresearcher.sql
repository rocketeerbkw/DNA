Create Procedure getrandomresearcher
As
	EXEC openemailaddresskey

	declare @maxuser int
	SELECT @maxuser = MAX(UserID) FROM Users WHERE Active = 1
	declare @startuser int
	SELECT @startuser = CONVERT(int, (RAND() * @maxuser)+1)
	SELECT TOP 1	UserID, Active, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) as email,
					'Name' = CASE 
						WHEN UserName IS NULL THEN 'Field Researcher ' + CONVERT(varchar(255),UserID)
						ELSE UserName
					END
		FROM Users u  WHERE u.UserID >= @startuser AND Active = 1
	return (0)