/*
	Check that a userid is in the GuideEntryPermissions table
	for a given article
*/

CREATE PROCEDURE getarticlepermissionsforuser
	@h2g2id INT,
	@userid INT
AS

SELECT g.status, p.*
FROM GuideEntries g WITH(NOLOCK)
	LEFT JOIN (
		SELECT TOP 1 gep.*
		FROM GuideEntryPermissions gep WITH(NOLOCK, INDEX=IX_GuideEntryPermissions)
			JOIN TeamMembers tm WITH(NOLOCK) ON gep.TeamID = tm.TeamID
		WHERE gep.h2g2ID = @h2g2id AND tm.UserID = @userid
		ORDER BY priority DESC
		) AS p ON g.EntryId = p.h2g2Id/10
WHERE g.EntryID = @h2g2id/10