Create Procedure nntpfetcharticleforforum @forumid int
As

EXEC openemailaddresskey

Select TOP 1 u.UserName, dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) AS email, g.Subject, g.text, g.Status, g.h2g2ID, 'Parent' = NULL, 'Bytes' = DATALENGTH(g.text), 'DatePosted' = g.DateCreated 
	FROM GuideEntries g
	INNER JOIN Users u ON g.Editor = u.UserID
	WHERE g.ForumID = @forumid
