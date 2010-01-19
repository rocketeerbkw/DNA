create procedure doesuserbelongtoclub @iuserid int, @iclubid int
as
-- check to see if the user belongs to the club
SELECT 'UserBelongs' =
CASE WHEN EXISTS
(
	SELECT UserID FROM TeamMembers WHERE UserID = @iuserid AND TeamID
	IN ( SELECT MemberTeam FROM Clubs WHERE ClubID = @iclubid )
) THEN 1
ELSE 0
END