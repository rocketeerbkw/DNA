Create Procedure nntpfetchall @forumid int
As

EXEC openemailaddresskey

SELECT EntryID, Parent, ForumID, ThreadID, Subject, DatePosted, t.UserID, u.UserName, dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) AS email, 'Bytes' = DATALENGTH(t.text) FROM ThreadEntries t 
	INNER JOIN Users u ON u.UserID = t.UserID
WHERE ForumID = @forumid AND (Hidden IS NULL)
ORDER BY EntryID

	return (0)