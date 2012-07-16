CREATE PROCEDURE addencryptedcontactdetails @postid INT, @text VARCHAR(MAX)
AS
IF EXISTS (SELECT * FROM dbo.ThreadEntries WHERE EntryID = @postid) AND NOT EXISTS (SELECT * FROM dbo.ThreadEntriesEncrypted WHERE EntryID = @postid)
BEGIN
	INSERT INTO dbo.ThreadEntriesEncrypted SELECT EntryID = @postid, [Text] = @text
END