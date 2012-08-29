CREATE PROCEDURE addencryptedcontactdetails @postid INT, @text VARCHAR(8000)
AS
IF EXISTS (SELECT * FROM dbo.ThreadEntries WHERE EntryID = @postid) AND NOT EXISTS (SELECT * FROM dbo.ThreadEntriesEncrypted WHERE EntryID = @postid)
BEGIN
	EXEC openemailaddresskey
	INSERT INTO dbo.ThreadEntriesEncrypted SELECT EntryID = @postid, [EncryptedText] = dbo.udf_encryptemailaddress(@text,@postid), [HashedText] = dbo.udf_hashemailaddress(@text)
END