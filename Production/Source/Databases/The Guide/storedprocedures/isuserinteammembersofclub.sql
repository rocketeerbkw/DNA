CREATE  PROCEDURE isuserinteammembersofclub @iuserid int, @iclubid int
AS
SELECT * FROM TeamMembers WHERE UserID = @iuserid AND TeamID
IN ( SELECT MemberTeam FROM Clubs WHERE ClubID = @iclubid ) 
