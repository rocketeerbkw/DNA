create procedure geteditableclublinkgroups @userid int
as

SELECT 'ClubID' = SourceID, Type, 'TotalGroups' = COUNT(*) FROM Links
WHERE SourceType = 'club' AND SourceID IN
(select DISTINCT c.ClubID from Clubs c
INNER JOIN TeamMembers t ON t.TeamID IN (c.OwnerTeam, c.MemberTeam)
INNER JOIN ClubPermissions p ON c.ClubID = p.ClubID AND p.TeamID = t.TeamID
WHERE p.CanEdit = 1 AND t.UserID = @userid)
GROUP BY SourceID, Type
ORDER BY SourceID, COUNT(*) DESC
