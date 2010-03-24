Create Procedure finduserfromemail @email varchar(255)
As
SELECT	u.*
FROM Users u 
WHERE email = @email AND Status <> 0
UNION ALL
SELECT	u.*
FROM Users u 
WHERE LoginName = @email AND Status <> 0

order by UserID
	return (0)