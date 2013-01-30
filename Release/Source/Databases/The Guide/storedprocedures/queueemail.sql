CREATE PROCEDURE queueemail @toemailaddress nvarchar(128), @fromemailaddress nvarchar(128), @subject nvarchar(256), @body nvarchar(max), @priority smallint, @notes nvarchar(max)
AS
EXEC openemailaddresskey

INSERT INTO dbo.EmailQueue
SELECT
	ToEmailAddress = 0x00,
	FromEmailAddress = 0x00,
	Subject = 0x00,
	Body = 0x00,
	Notes = @notes,
	Priority = @priority,
	DateQueued = GetDate(),
	DateSent = NULL,
	LastFailedReason = NULL
	
DECLARE @EntryID INT
SELECT @EntryID = @@IDENTITY FROM dbo.EmailQueue
	
UPDATE dbo.EmailQueue SET
	ToEmailAddress = dbo.udf_encrypttext(@toemailaddress, @EntryID),
	FromEmailAddress = dbo.udf_encrypttext(@fromemailaddress, @EntryID),
	Subject = dbo.udf_encryptemailaddress(@subject, @EntryID),
	Body = dbo.udf_encryptemailaddress(@body, @EntryID)
WHERE ID = @EntryID
