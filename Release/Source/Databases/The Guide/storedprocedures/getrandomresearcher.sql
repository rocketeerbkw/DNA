Create Procedure getrandomresearcher
As
	declare @maxuser int
	SELECT @maxuser = MAX(UserID) FROM Users WHERE Active = 1
	declare @startuser int
	SELECT @startuser = CONVERT(int, (RAND() * @maxuser)+1)
	SELECT TOP 1	UserID, Active, email,
					'Name' = CASE 
						WHEN UserName IS NULL THEN 'Field Researcher ' + CONVERT(varchar(255),UserID)
						ELSE UserName
					END
		FROM Users u  WHERE u.UserID >= @startuser AND Active = 1
	return (0)