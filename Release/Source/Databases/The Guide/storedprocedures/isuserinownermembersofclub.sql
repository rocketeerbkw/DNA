CREATE PROCEDURE isuserinownermembersofclub @iuserid int, @iclubid int
AS
SELECT * FROM TeamMembers WHERE UserID = @iuserid AND TeamID
IN ( SELECT OwnerTeam FROM Clubs WHERE ClubID = @iclubid ) 
