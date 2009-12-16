-- Add site to ProfanityGroupMembers for a given groupid
-- Only allow one occurence of a siteid

CREATE PROCEDURE addsitetoprofanitygroup
	@groupid INT,
	@siteid INT
AS

-- Check if it is already in the table
DECLARE @SiteExists INT, @CurrentGroup INT, @Error INT
SELECT @SiteExists = SiteId, @CurrentGroup = GroupId FROM ProfanityGroupMembers WHERE SiteId = @siteid

IF (@SiteExists != 0)
	BEGIN
		-- Site already here
		IF (@CurrentGroup != @groupid)
			BEGIN
				UPDATE ProfanityGroupMembers SET GroupId = @groupid WHERE SiteId = @siteid
			END
		-- Else it's already here in the correct group
	END
ELSE
	BEGIN
		INSERT INTO ProfanityGroupMembers (GroupId, SiteID) VALUES (@groupid, @siteid)
	END

SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	EXEC Error @Error
	RETURN @Error
END

RETURN (0)
