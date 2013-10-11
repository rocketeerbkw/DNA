CREATE PROCEDURE updatequeuedemail @id int, @sent tinyint, @failuredetails varchar(max)
AS
IF (@sent = 1)
BEGIN
	UPDATE dbo.EmailQueue SET DateSent = GETDATE() WHERE ID = @id
END
ELSE
BEGIN
	UPDATE dbo.EmailQueue SET LastFailedReason = @failuredetails WHERE ID = @id
END