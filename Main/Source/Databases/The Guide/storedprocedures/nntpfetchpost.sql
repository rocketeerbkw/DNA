CREATE PROCEDURE nntpfetchpost @entryid int
 AS

EXEC openemailaddresskey

SELECT EntryID, ForumID, Parent, ThreadID, Subject, DatePosted, t.UserID, u.UserName, dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) AS email, t.text FROM ThreadEntries t 
	INNER JOIN Users u ON u.UserID = t.UserID
WHERE EntryID = @entryid
