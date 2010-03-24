/*
	Fetches the list of all referees for all sites
*/

CREATE PROCEDURE fetchrefereelist
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ref INT
SELECT @ref = GroupID FROM Groups WHERE Name='Referee'

DECLARE @sql NVARCHAR(max)

-- We use dynamic SQL as this helps the optimiser pick the best plan for
-- the Referee group ID
SET @sql='
	SELECT DISTINCT gm.SiteID, u.UserID, u.UserName, u.FirstNames, u.LastName, u.Status, u.TaxonomyNode
		FROM Users u 
		INNER JOIN GroupMembers gm on gm.UserID = u.UserID
		WHERE u.Active = 1 AND gm.GroupID=@i_ref
		ORDER BY u.UserID'

EXEC sp_executesql @sql, N'@i_ref int', @i_ref = @ref
