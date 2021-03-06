CREATE PROCEDURE updatedefaultpermissions @siteid int,
	@clubcanautojoinmember int, 
	@clubcanautojoinowner int, 
	@clubcanbecomemember int, 
	@clubcanbecomeowner int, 
	@clubcanapprovemembers int, 
	@clubcanapproveowners int, 
	@clubcandemoteowners int, 
	@clubcandemotemembers int, 
	@clubcanviewactions int, 
	@clubcanview int, 
	@clubcanpostjournal int, 
	@clubcanpostcalendar int, 

	@clubownercanautojoinmember int, 
	@clubownercanautojoinowner int, 
	@clubownercanbecomemember int, 
	@clubownercanbecomeowner int, 
	@clubownercanapprovemembers int, 
	@clubownercanapproveowners int, 
	@clubownercandemoteowners int, 
	@clubownercandemotemembers int, 
	@clubownercanviewactions int, 
	@clubownercanview int, 
	@clubownercanpostjournal int, 
	@clubownercanpostcalendar int, 

	@clubmembercanautojoinmember int, 
	@clubmembercanautojoinowner int, 
	@clubmembercanbecomemember int, 
	@clubmembercanbecomeowner int, 
	@clubmembercanapprovemembers int, 
	@clubmembercanapproveowners int, 
	@clubmembercandemoteowners int, 
	@clubmembercandemotemembers int, 
	@clubmembercanviewactions int, 
	@clubmembercanview int, 
	@clubmembercanpostjournal int, 
	@clubmembercanpostcalendar int, 

	@closedclubcanautojoinmember int, 
	@closedclubcanautojoinowner int, 
	@closedclubcanbecomemember int, 
	@closedclubcanbecomeowner int, 
	@closedclubcanapprovemembers int, 
	@closedclubcanapproveowners int, 
	@closedclubcandemoteowners int, 
	@closedclubcandemotemembers int, 
	@closedclubcanviewactions int, 
	@closedclubcanview int, 
	@closedclubcanpostjournal int, 
	@closedclubcanpostcalendar int, 

	@closedclubownercanautojoinmember int, 
	@closedclubownercanautojoinowner int, 
	@closedclubownercanbecomemember int, 
	@closedclubownercanbecomeowner int, 
	@closedclubownercanapprovemembers int, 
	@closedclubownercanapproveowners int, 
	@closedclubownercandemoteowners int, 
	@closedclubownercandemotemembers int, 
	@closedclubownercanviewactions int, 
	@closedclubownercanview int, 
	@closedclubownercanpostjournal int, 
	@closedclubownercanpostcalendar int, 

	@closedclubmembercanautojoinmember int, 
	@closedclubmembercanautojoinowner int, 
	@closedclubmembercanbecomemember int, 
	@closedclubmembercanbecomeowner int, 
	@closedclubmembercanapprovemembers int, 
	@closedclubmembercanapproveowners int, 
	@closedclubmembercandemoteowners int, 
	@closedclubmembercandemotemembers int, 
	@closedclubmembercanviewactions int, 
	@closedclubmembercanview int, 
	@closedclubmembercanpostjournal int, 
	@closedclubmembercanpostcalendar int 


as

BEGIN TRANSACTION

declare @ErrorCode int

UPDATE DefaultPermissions
	SET 	ClubCanAutoJoinMember = @ClubCanAutoJoinMember, 
	ClubCanAutoJoinOwner = @ClubCanAutoJoinOwner, 
	ClubCanBecomeMember = @ClubCanBecomeMember, 
	ClubCanBecomeOwner = @ClubCanBecomeOwner, 
	ClubCanApproveMembers = @ClubCanApproveMembers, 
	ClubCanApproveOwners = @ClubCanApproveOwners, 
	ClubCanDemoteOwners = @ClubCanDemoteOwners, 
	ClubCanDemoteMembers = @ClubCanDemoteMembers, 
	ClubCanViewActions = @ClubCanViewActions, 
	ClubCanView = @ClubCanView, 
	ClubCanPostJournal = @ClubCanPostJournal, 
	ClubCanPostCalendar = @ClubCanPostCalendar, 

	ClubOwnerCanAutoJoinMember = @ClubOwnerCanAutoJoinMember, 
	ClubOwnerCanAutoJoinOwner = @ClubOwnerCanAutoJoinOwner, 
	ClubOwnerCanBecomeMember = @ClubOwnerCanBecomeMember, 
	ClubOwnerCanBecomeOwner = @ClubOwnerCanBecomeOwner, 
	ClubOwnerCanApproveMembers = @ClubOwnerCanApproveMembers, 
	ClubOwnerCanApproveOwners = @ClubOwnerCanApproveOwners, 
	ClubOwnerCanDemoteOwners = @ClubOwnerCanDemoteOwners, 
	ClubOwnerCanDemoteMembers = @ClubOwnerCanDemoteMembers, 
	ClubOwnerCanViewActions = @ClubOwnerCanViewActions, 
	ClubOwnerCanView = @ClubOwnerCanView, 
	ClubOwnerCanPostJournal = @ClubOwnerCanPostJournal, 
	ClubOwnerCanPostCalendar = @ClubOwnerCanPostCalendar, 

	ClubMemberCanAutoJoinMember = @ClubMemberCanAutoJoinMember, 
	ClubMemberCanAutoJoinOwner = @ClubMemberCanAutoJoinOwner, 
	ClubMemberCanBecomeMember = @ClubMemberCanBecomeMember, 
	ClubMemberCanBecomeOwner = @ClubMemberCanBecomeOwner, 
	ClubMemberCanApproveMembers = @ClubMemberCanApproveMembers, 
	ClubMemberCanApproveOwners = @ClubMemberCanApproveOwners, 
	ClubMemberCanDemoteOwners = @ClubMemberCanDemoteOwners, 
	ClubMemberCanDemoteMembers = @ClubMemberCanDemoteMembers, 
	ClubMemberCanViewActions = @ClubMemberCanViewActions, 
	ClubMemberCanView = @ClubMemberCanView, 
	ClubMemberCanPostJournal = @ClubMemberCanPostJournal, 
	ClubMemberCanPostCalendar = @ClubMemberCanPostCalendar, 

	ClosedClubCanAutoJoinMember = @ClosedClubCanAutoJoinMember, 
	ClosedClubCanAutoJoinOwner = @ClosedClubCanAutoJoinOwner, 
	ClosedClubCanBecomeMember = @ClosedClubCanBecomeMember, 
	ClosedClubCanBecomeOwner = @ClosedClubCanBecomeOwner, 
	ClosedClubCanApproveMembers = @ClosedClubCanApproveMembers, 
	ClosedClubCanApproveOwners = @ClosedClubCanApproveOwners, 
	ClosedClubCanDemoteOwners = @ClosedClubCanDemoteOwners, 
	ClosedClubCanDemoteMembers = @ClosedClubCanDemoteMembers, 
	ClosedClubCanViewActions = @ClosedClubCanViewActions, 
	ClosedClubCanView = @ClosedClubCanView, 
	ClosedClubCanPostJournal = @ClosedClubCanPostJournal, 
	ClosedClubCanPostCalendar = @ClosedClubCanPostCalendar, 

	ClosedClubOwnerCanAutoJoinMember = @ClosedClubOwnerCanAutoJoinMember, 
	ClosedClubOwnerCanAutoJoinOwner = @ClosedClubOwnerCanAutoJoinOwner, 
	ClosedClubOwnerCanBecomeMember = @ClosedClubOwnerCanBecomeMember, 
	ClosedClubOwnerCanBecomeOwner = @ClosedClubOwnerCanBecomeOwner, 
	ClosedClubOwnerCanApproveMembers = @ClosedClubOwnerCanApproveMembers, 
	ClosedClubOwnerCanApproveOwners = @ClosedClubOwnerCanApproveOwners, 
	ClosedClubOwnerCanDemoteOwners = @ClosedClubOwnerCanDemoteOwners, 
	ClosedClubOwnerCanDemoteMembers = @ClosedClubOwnerCanDemoteMembers, 
	ClosedClubOwnerCanViewActions = @ClosedClubOwnerCanViewActions, 
	ClosedClubOwnerCanView = @ClosedClubOwnerCanView, 
	ClosedClubOwnerCanPostJournal = @ClosedClubOwnerCanPostJournal, 
	ClosedClubOwnerCanPostCalendar = @ClosedClubOwnerCanPostCalendar, 

	ClosedClubMemberCanAutoJoinMember = @ClosedClubMemberCanAutoJoinMember, 
	ClosedClubMemberCanAutoJoinOwner = @ClosedClubMemberCanAutoJoinOwner, 
	ClosedClubMemberCanBecomeMember = @ClosedClubMemberCanBecomeMember, 
	ClosedClubMemberCanBecomeOwner = @ClosedClubMemberCanBecomeOwner, 
	ClosedClubMemberCanApproveMembers = @ClosedClubMemberCanApproveMembers, 
	ClosedClubMemberCanApproveOwners = @ClosedClubMemberCanApproveOwners, 
	ClosedClubMemberCanDemoteOwners = @ClosedClubMemberCanDemoteOwners, 
	ClosedClubMemberCanDemoteMembers = @ClosedClubMemberCanDemoteMembers, 
	ClosedClubMemberCanViewActions = @ClosedClubMemberCanViewActions, 
	ClosedClubMemberCanView = @ClosedClubMemberCanView, 
	ClosedClubMemberCanPostJournal = @ClosedClubMemberCanPostJournal, 
	ClosedClubMemberCanPostCalendar = @ClosedClubMemberCanPostCalendar 
	WHERE SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Result' = 1, 'Error' = 'Internal error' 
		RETURN @ErrorCode
	END

COMMIT TRANSACTION
return 0