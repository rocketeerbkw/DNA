CREATE PROCEDURE removesitefromprofanitygroup @siteid INT
AS

-- Remove a single site from a group

DELETE FROM ProfanityGroupMembers WHERE SiteId = @siteid

DECLARE @Error INT
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	EXEC Error @Error
	RETURN @Error
END

RETURN (0)