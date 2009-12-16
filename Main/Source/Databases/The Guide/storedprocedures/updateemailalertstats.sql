CREATE PROCEDURE updateemailalertstats @totalemailssent int, @totalprivatemsgssent int, @totalfailed int, @updatetype int
AS
BEGIN TRANSACTION
DECLARE @Error int
INSERT INTO EmailAlertstats (totalemail, totalprivatemsg, totalfailed, updatetype) VALUES (@totalemailssent, @totalprivatemsgssent, @totalfailed, @updatetype)
SET @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	EXEC Error @Error
	ROLLBACK TRANSACTION
	RETURN @Error
END
COMMIT TRANSACTION
