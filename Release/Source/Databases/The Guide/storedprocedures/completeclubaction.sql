create procedure completeclubaction @userid int, @actionid int, @actionresult int, @siteid int = NULL, @currentsiteid int = 0
as
	declare @ErrorCode int
	
	BEGIN TRANSACTION
	declare @clubid int, @actiontype int, @actionuser int
	
	SELECT @clubid = ClubID, @actiontype = ActionType, @actionuser = UserID 
		FROM ClubMemberActions WITH(UPDLOCK)
			WHERE ActionID = @actionid AND ActionResult = 0
	declare @actionname varchar(255)
	EXEC getclubactionname @actiontype, @actionname OUTPUT
	if (@clubid IS NULL)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'Reason' = 'nosuchaction', 'ActionID' = @actionid, 'ActionName' = @actionname
		Return 1
	END

	-- Get some info from the club
	declare @clubforum int, @clubjournal int, @ownerteam int, @memberteam int, @ownerforum int, @memberforum int
	SELECT @clubforum = ClubForum, @clubjournal = Journal, @ownerteam = OwnerTeam, @memberteam = MemberTeam, @ownerforum = t1.ForumID, @memberforum = t2.ForumID
		FROM Clubs c INNER JOIN Teams t1 ON c.OwnerTeam = t1.TeamID
					INNER JOIN Teams t2 ON c.MemberTeam = t2.TeamID
			WHERE ClubID = @clubid
	if (@clubforum IS NULL)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'Reason' = 'nosuchclub', 'ActionID' = @actionid, 'ActionName' = @actionname
		Return 1
	END


	declare @canautomember int, @canautoowner int ,
												@canbecomemember int ,
												@canbecomeowner int ,
												@canapprovemembers int ,
												@canapproveowners int ,
												@candemoteowners int , 
												@candemotemembers int,
												@canviewactions int,
												@canview int,
												@canedit int,
												@isteammember int ,
												@isowner int

	
	EXEC getclubpermissionsinternal @userid, @clubid, 
												@canautomember OUTPUT,
												@canautoowner OUTPUT,
												@canbecomemember OUTPUT,
												@canbecomeowner OUTPUT,
												@canapprovemembers OUTPUT,
												@canapproveowners OUTPUT,
												@candemoteowners OUTPUT, 
												@candemotemembers OUTPUT,
												@canviewactions OUTPUT,
												@canview OUTPUT,
												@canedit OUTPUT,
												@isteammember OUTPUT,
												@isowner OUTPUT

	-- Now complete the action
	-- see if the user has the right to complete this action
	declare @isallowed int
	select @isallowed = CASE 
							-- join as member
							WHEN @actiontype = 1 AND (@canautomember = 1 OR @canapprovemembers = 1) THEN 1
							-- join as owner
							WHEN @actiontype = 2 AND (@canautoowner = 1 OR @canapproveowners = 1) THEN 1
							-- invited as member
							WHEN @actiontype = 3 AND (@userid = @actionuser) THEN 1
							-- invited as owner
							WHEN @actiontype = 4 AND (@userid = @actionuser) THEN 1
							-- Owner resigns to member
							WHEN @actiontype = 5 AND (@userid = @actionuser) THEN 1
							-- owner resigns completely
							WHEN @actiontype = 6 AND (@userid = @actionuser) THEN 1
							-- member resigns completely
							WHEN @actiontype = 7 AND (@userid = @actionuser) THEN 1
							-- Owner demotes owner to member
							WHEN @actiontype = 8 AND (@candemoteowners = 1) THEN 1
							-- owner removes owner completely
							WHEN @actiontype = 9 AND (@candemoteowners = 1) THEN 1
							-- owner removes member completely
							WHEN @actiontype = 10 AND (@candemotemembers = 1) THEN 1
							ELSE 0 END
	-- force permissions here for BBCStaff and editors?
		declare @found int

	SELECT @found = (
		SELECT 'found'=1 FROM Users u WHERE u.userid = @userid and u.status =2
		UNION
		SELECT 'found'=1 FROM GroupMembers gm 
			INNER JOIN Groups g ON g.GroupID = gm.GroupID and g.name = 'Editor'
			WHERE gm.userid = @userid and gm.siteid = @siteid
	)

	if (@found = 1)
	BEGIN
		SELECT @canautomember		= 1
		SELECT @canautoowner		= 1
		SELECT @canbecomemember		= 1
		SELECT @canbecomeowner		= 1
		SELECT @canapprovemembers	= 1
		SELECT @canapproveowners	= 1
		SELECT @candemoteowners		= 1
		SELECT @candemotemembers	= 1
		SELECT @canviewactions		= 1
		SELECT @canview				= 1
		SELECT @canedit				= 1
		SELECT @isteammember		= 1
		SELECT @isowner				= 1

		SELECT @isallowed			= 1

	END


	if (@isallowed = 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'Reason' = 'notallowed', 'ActionID' = @actionid, 'ActionName' = @actionname
		Return 1
	END

	-- Now perform the action required.
	IF (@actiontype = 1)	-- Join as member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 2)	-- Join as owner
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- And an owner
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@ownerteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 3)	-- invited as member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate()
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 4)	-- invited as owner
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate()
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@ownerteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 5)	-- Owner resigns to member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 6)	-- Owner resigns completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 7)	-- Member resigns completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team (just in case!)
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 8)	-- Owner demotes owner to member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 9)	-- Owner removes owner completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 10)	-- Owner removes member completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team (just in case!)
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE -- Don't know what this is
	BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'unknownaction', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN 0
	END

	COMMIT TRANSACTION

	-- Update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!
	IF ((@actiontype IN (1, 2, 3, 4)) AND (@actionresult = 1))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc		= 'UserJoinTeam',
												  @siteid			= @currentsiteid, 
												  @clubid			= @clubid	
	END

	-- Must have succeeded - return a result
	SELECT 'Success' = 1, 'Reason' = '',   'ActionName' = @actionname, a.*,
		'ClubName' = c.Name, 
		'ActionUserName' = u.Username, U.FIRSTNAMES as ActionFirstNames, U.LASTNAME as ActionLastName, U.AREA as ActionArea, U.STATUS as ActionStatus, U.TAXONOMYNODE as ActionTaxonomyNode, J.ForumID as ActionJournal, U.ACTIVE as ActionActive, P.SITESUFFIX as ActionSiteSuffix, P.TITLE as ActionTitle,
		'OwnerUserName' = u2.Username, U2.FIRSTNAMES as OwnerFirstNames, U2.LASTNAME as OwnerLastName, U2.AREA as OwnerArea, U2.STATUS as OwnerStatus, U2.TAXONOMYNODE as OwnerTaxonomyNode, J2.ForumID as OwnerJournal, U2.ACTIVE as OwnerActive, P2.SITESUFFIX as OwnerSiteSuffix, P2.TITLE as OwnerTitle
		FROM ClubMemberActions a 
			INNER JOIN Users u ON a.UserID = u.UserID
			LEFT JOIN Preferences p on p.UserID = u.UserID AND p.SiteID = @currentsiteid
			INNER JOIN Clubs c ON a.ClubID = c.ClubID 
			INNER JOIN Users u2 ON a.OwnerID = u2.UserID 
			LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @currentsiteid
			INNER JOIN Journals J on J.UserID = u.UserID and J.SiteID = @currentsiteid
			INNER JOIN Journals J2 on J2.UserID = u2.UserID and J2.SiteID = @currentsiteid
		WHERE ActionID = @actionID

-- fall through...
ReturnWithoutError:
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	-- See if we need to put an event in the event queue.
	IF (@actiontype IN (2,5,6,8,9))
	BEGIN
		EXEC addtoeventqueueinternal 'ET_CLUBOWNERTEAMCHANGE', @clubid, 'IT_CLUB', @actionuser, 'IT_USER', @userid
	END
	ELSE IF (@actiontype IN (1,7,10))
	BEGIN
		EXEC addtoeventqueueinternal 'ET_CLUBMEMBERTEAMCHANGE', @clubid, 'IT_CLUB', @actionuser, 'IT_USER', @userid
	END
	
	RETURN 0