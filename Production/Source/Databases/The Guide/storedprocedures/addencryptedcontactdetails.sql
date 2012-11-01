CREATE PROCEDURE addencryptedcontactdetails @postid INT, @text VARCHAR(8000)
AS
IF EXISTS (SELECT * FROM dbo.ThreadEntries WHERE EntryID = @postid)
BEGIN
	EXEC openemailaddresskey
	IF (NOT EXISTS (SELECT * FROM dbo.ThreadEntriesEncrypted WHERE EntryID = @postid))
	BEGIN
		INSERT INTO dbo.ThreadEntriesEncrypted
			SELECT	EntryID = @postid,
					[EncryptedText] = dbo.udf_encrypttext(@text, @postid),
					[HashedText] = dbo.udf_hashemailaddress(@text)
	END 
	ELSE
	BEGIN
		UPDATE dbo.ThreadEntriesEncrypted
			SET	[EncryptedText] = dbo.udf_encrypttext(@text, @postid),
				[HashedText] = dbo.udf_hashemailaddress(@text)
			WHERE EntryID = @postid
	END
END