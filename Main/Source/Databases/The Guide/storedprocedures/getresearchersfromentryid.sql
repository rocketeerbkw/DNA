Create Procedure getresearchersfromentryid @entryid int
As
/*
 Deleted - has never worked, will never work.
SELECT u.UserName, u.UserID 
FROM Users u 
WHERE u.UserID IN 
	(
	SELECT UserID 
	FROM Researchers 
	WHERE EntryID = @entryid
	UNION SELECT $editor
	)
*/