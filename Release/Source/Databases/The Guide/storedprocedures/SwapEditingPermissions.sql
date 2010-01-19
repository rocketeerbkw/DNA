-- Removes an entry in GuideEntryPermissions for a specified user and replaces it with the new user
-- To avoid duplicates it also removes any entries for the new user before inserting

CREATE PROCEDURE swapeditingpermissions
	@h2g2id int,
	@oldeditor int,
	@neweditor int
AS

-- run this inside a transaction please

DELETE GuideEntryPermissions 
	FROM GuideEntryPermissions gep WITH(INDEX=IX_GuideEntryPermissions)
	JOIN UserTeams u ON u.TeamID = gep.TeamID
	WHERE gep.h2g2id = @h2g2id AND u.UserID IN (@oldeditor, @neweditor)

INSERT INTO GuideEntryPermissions (h2g2ID, TeamID, CanRead, CanWrite, CanChangePermissions)
	SELECT @h2g2id, u.TeamID, 1, 1, 1
		FROM GuideEntries g
		JOIN UserTeams u on u.SiteID = g.SiteID
		WHERE u.UserID = @neweditor AND g.h2g2ID = @h2g2ID

DECLARE @ErrorCode INT

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode != 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

RETURN @ErrorCode