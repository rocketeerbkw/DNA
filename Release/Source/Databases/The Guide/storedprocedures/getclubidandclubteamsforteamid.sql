create procedure getclubidandclubteamsforteamid @teamid int
as

SELECT c.ClubID, c.MemberTeam, c.OwnerTeam FROM Clubs c WHERE c.OwnerTeam = @teamid OR
c.MemberTeam = @teamid
