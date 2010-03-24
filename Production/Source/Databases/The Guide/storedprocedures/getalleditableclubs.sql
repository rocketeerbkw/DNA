create procedure getalleditableclubs @userid int
as
select DISTINCT c.* from Clubs c
INNER JOIN TeamMembers t ON t.TeamID IN (c.OwnerTeam, c.MemberTeam)
INNER JOIN ClubPermissions p ON c.ClubID = p.ClubID AND p.TeamID = t.TeamID
WHERE p.CanEdit = 1 AND t.UserID = @userid

