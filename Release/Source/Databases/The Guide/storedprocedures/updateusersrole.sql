create procedure updateusersrole @iuserid int, @iclubid int, @srole varchar(255)
as
UPDATE TeamMembers SET Role = @srole WHERE UserID = @iuserid AND TeamID
	IN ( SELECT MemberTeam FROM Clubs WHERE ClubID = @iclubid )
