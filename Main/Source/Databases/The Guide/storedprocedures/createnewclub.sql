CREATE PROCEDURE createnewclub
				@groupname varchar(255),
				@creator int,
				@openmembership tinyint,
				@siteid int,
				@body varchar(max),
				@extrainfo text,
				@hash uniqueidentifier
as

DECLARE @ErrorCode INT
BEGIN TRANSACTION

-- create the article to hold the description
declare @clubentryid int, @clubdatecreated datetime, @clubmessagecentre int, @clubh2g2id int, @FoundDuplicate tinyint

-- get the club guide type id
declare @guidetypeid int
SELECT @guidetypeid = Id FROM GuideEntryTypes WHERE Name = 'club'

EXEC @ErrorCode = createguideentryinternal	@groupname, @body, @extrainfo,
												@creator, 1, 3, NULL, NULL,
												@siteid, 0, @guidetypeid, @clubentryid OUTPUT,
												@clubdatecreated OUTPUT,
												@clubmessagecentre OUTPUT, @clubh2g2id OUTPUT,
												@FoundDuplicate OUTPUT, @hash
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Check to see if we found a duplicate club guide entry.
IF (@FoundDuplicate = 1)
BEGIN
	ROLLBACK TRANSACTION
	SELECT 'h2g2id' = @clubh2g2id, 'ClubID' = c.ClubID, 'FoundDuplicate' = @FoundDuplicate FROM Clubs c WHERE c.h2g2ID = @clubh2g2id
	RETURN 0
END

declare @ownerforum int
declare @memberforum int
declare @ownerteam int
declare @memberteam int

EXEC @ErrorCode = createnewteam @siteid, @creator, @groupname, 'founder',  @ownerteam OUTPUT, @ownerforum OUTPUT
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

EXEC @ErrorCode = createnewteam @siteid, @creator, @groupname, 'founder', @memberteam OUTPUT, @memberforum OUTPUT
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO Forums (Title, SiteID, CanRead, CanWrite, ThreadCanRead, ThreadCanWrite) VALUES(@groupname, @siteid, 1, 1, 1, 1)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @clubforum int
select @clubforum = @@IDENTITY

INSERT INTO Forums (Title, SiteID, CanRead, CanWrite, ThreadCanRead, ThreadCanWrite) VALUES(@groupname, @siteid, 1, 0, 1, 1)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @journal int
select @journal = @@IDENTITY

-- Now insert the club record with all these parameters
IF (@openmembership = 1)
BEGIN
	INSERT INTO Clubs (Name, h2g2ID, SiteID, Journal, ClubForum, Status, OwnerTeam, MemberTeam, CanAutoJoinMember, CanAutoJoinOwner, CanBecomeMember, CanBecomeOwner, CanApproveMembers, CanApproveOwners, CanDemoteOwners, CanDemoteMembers, CanViewActions, CanView, CanEdit)
		SELECT @groupname, @clubh2g2id, @siteid, @journal, @clubforum, @openmembership, @ownerteam, @memberteam, ClubCanAutoJoinMember, ClubCanAutoJoinOwner, ClubCanBecomeMember, ClubCanBecomeOwner, ClubCanApproveMembers, ClubCanApproveOwners, ClubCanDemoteOwners, ClubCanDemoteMembers, ClubCanViewActions, ClubCanView, ClubCanEdit
		FROM DefaultPermissions WHERE SiteID = @siteid
		-- VALUES(@groupname, @clubh2g2id, @siteid, @journal, @clubforum, @openmembership, @ownerteam, @memberteam, 1,0,1,1,0,0,0,0,0,1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE
BEGIN
	INSERT INTO Clubs (Name, h2g2ID, SiteID, Journal, ClubForum, Status, OwnerTeam, MemberTeam, CanAutoJoinMember, CanAutoJoinOwner, CanBecomeMember, CanBecomeOwner, CanApproveMembers, CanApproveOwners, CanDemoteOwners, CanDemoteMembers, CanViewActions, CanView, CanEdit)
		SELECT @groupname, @clubh2g2id, @siteid, @journal, @clubforum, @openmembership, @ownerteam, @memberteam, ClosedClubCanAutoJoinMember, ClosedClubCanAutoJoinOwner, ClosedClubCanBecomeMember, ClosedClubCanBecomeOwner, ClosedClubCanApproveMembers, ClosedClubCanApproveOwners, ClosedClubCanDemoteOwners, ClosedClubCanDemoteMembers, ClosedClubCanViewActions, ClosedClubCanView, ClosedClubCanEdit
		FROM DefaultPermissions WHERE SiteID = @siteid
		-- VALUES(@groupname, @clubh2g2id, @siteid, @journal, @clubforum, @openmembership, @ownerteam, @memberteam, 1,0,1,1,0,0,0,0,0,1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
declare @clubid int
select @clubid = @@IDENTITY

-- Now add the permissions for the two teams distinct from the defaults
IF (@openmembership = 1)
BEGIN
	INSERT INTO ClubPermissions (ClubID, TeamID, Priority, CanAutoJoinMember, CanAutoJoinOwner, CanBecomeMember, CanBecomeOwner, CanApproveMembers, CanApproveOwners, CanDemoteOwners, CanDemoteMembers, CanViewActions, CanView, CanEdit)
	SELECT @clubid, @ownerteam, 2, ClubOwnerCanAutoJoinMember, ClubOwnerCanAutoJoinOwner, ClubOwnerCanBecomeMember, ClubOwnerCanBecomeOwner, ClubOwnerCanApproveMembers, ClubOwnerCanApproveOwners, ClubOwnerCanDemoteOwners, ClubOwnerCanDemoteMembers, ClubOwnerCanViewActions, ClubOwnerCanView, ClubOwnerCanEdit
	FROM DefaultPermissions WHERE SiteID = @siteid
	--VALUES (@clubid, @ownerteam, 2,1,0,0,0,1,1,1,1,1,1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	-- add the permissions for the teams on the journal
	insert into ForumPermissions (ForumID, TeamID, CanRead, CanWrite, Priority)
	SELECT @journal, @memberteam, 1, ClubMemberCanPostJournal, 1 FROM DefaultPermissions WHERE SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	insert into ForumPermissions (ForumID, TeamID, CanRead, CanWrite, Priority)
	SELECT @journal, @ownerteam, 1, ClubOwnerCanPostJournal, 2 FROM DefaultPermissions WHERE SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

END
ELSE
BEGIN
	INSERT INTO ClubPermissions (ClubID, TeamID, Priority, CanAutoJoinMember, CanAutoJoinOwner, CanBecomeMember, CanBecomeOwner, CanApproveMembers, CanApproveOwners, CanDemoteOwners, CanDemoteMembers, CanViewActions, CanView, CanEdit)
	SELECT @clubid, @ownerteam, 2, ClosedClubOwnerCanAutoJoinMember, ClosedClubOwnerCanAutoJoinOwner, ClosedClubOwnerCanBecomeMember, ClosedClubOwnerCanBecomeOwner, ClosedClubOwnerCanApproveMembers, ClosedClubOwnerCanApproveOwners, ClosedClubOwnerCanDemoteOwners, ClosedClubOwnerCanDemoteMembers, ClosedClubOwnerCanViewActions, ClosedClubOwnerCanView, ClosedClubOwnerCanEdit
	FROM DefaultPermissions WHERE SiteID = @siteid
	--VALUES (@clubid, @ownerteam, 2,1,0,0,0,1,1,1,1,1,1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- add the permissions for the teams on the journal
	insert into ForumPermissions (ForumID, TeamID, CanRead, CanWrite, Priority)
	SELECT @journal, @memberteam, 1, ClosedClubMemberCanPostJournal, 1 FROM DefaultPermissions WHERE SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	insert into ForumPermissions (ForumID, TeamID, CanRead, CanWrite, Priority)
	SELECT @journal, @ownerteam, 1, ClosedClubOwnerCanPostJournal, 2 FROM DefaultPermissions WHERE SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

END
IF (@openmembership = 1)
BEGIN
	INSERT INTO ClubPermissions (ClubID, TeamID, Priority, CanAutoJoinMember, CanAutoJoinOwner, CanBecomeMember, CanBecomeOwner, CanApproveMembers, CanApproveOwners, CanDemoteOwners, CanDemoteMembers, CanViewActions, CanView, CanEdit)
	SELECT @clubid, @memberteam, 1, ClubMemberCanAutoJoinMember, ClubMemberCanAutoJoinOwner, ClubMemberCanBecomeMember, ClubMemberCanBecomeOwner, ClubMemberCanApproveMembers, ClubMemberCanApproveOwners, ClubMemberCanDemoteOwners, ClubMemberCanDemoteMembers, ClubMemberCanViewActions, ClubMemberCanView, ClubMemberCanEdit
	FROM DefaultPermissions WHERE SiteID = @siteid
	--VALUES (@clubid, @memberteam, 1,1,0,0,1,1,0,0,0,0,1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE
BEGIN
	INSERT INTO ClubPermissions (ClubID, TeamID, Priority, CanAutoJoinMember, CanAutoJoinOwner, CanBecomeMember, CanBecomeOwner, CanApproveMembers, CanApproveOwners, CanDemoteOwners, CanDemoteMembers, CanViewActions, CanView, CanEdit)
	SELECT @clubid, @memberteam, 1, ClosedClubMemberCanAutoJoinMember, ClosedClubMemberCanAutoJoinOwner, ClosedClubMemberCanBecomeMember, ClosedClubMemberCanBecomeOwner, ClosedClubMemberCanApproveMembers, ClosedClubMemberCanApproveOwners, ClosedClubMemberCanDemoteOwners, ClosedClubMemberCanDemoteMembers, ClosedClubMemberCanViewActions, ClosedClubMemberCanView, ClosedClubMemberCanEdit
	FROM DefaultPermissions WHERE SiteID = @siteid
	--VALUES (@clubid, @memberteam, 1,1,0,0,1,1,0,0,0,0,1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

SELECT 'h2g2id' = @clubh2g2id, 'ClubID' = @clubid, 'FoundDuplicate' = @FoundDuplicate,
		'OwnerTeam' = @ownerteam


COMMIT TRANSACTION