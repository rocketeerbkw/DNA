create procedure performclubaction @clubid int, @userid int, @actionuser int, @actiontype int, @siteid int, @currentsiteid int = 0
as
BEGIN TRANSACTION
	
	declare @ErrorCode int

	declare @canautomember int, @canautoowner int ,
												@canbecomemember int ,
												@canbecomeowner int ,
												@canapprovemembers int ,
												@canapproveowners int ,
												@candemoteowners int , 
												@candemotemembers int ,
												@canviewactions int,
												@canview int,
												@canedit int,
												@isteammember int,
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



	
	-- see if the user has the right to perform this action
	declare @isallowed int
	select @isallowed = CASE 
							-- join as member
							WHEN @actiontype = 1 AND (@canbecomemember = 1) THEN 1
							-- join as owner
							WHEN @actiontype = 2 AND (@canbecomeowner = 1) THEN 1
							-- invite as member
							WHEN @actiontype = 3 AND (@canapprovemembers = 1) THEN 1
							-- invite as owner
							WHEN @actiontype = 4 AND (@canapproveowners = 1) THEN 1
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

	declare @actionname varchar(255)
	EXEC getclubactionname @actiontype, @actionname OUTPUT
	declare @clubforum int, @clubjournal int, @ownerteam int, @memberteam int, @ownerforum int, @memberforum int
	SELECT @clubforum = ClubForum, @clubjournal = Journal, @ownerteam = OwnerTeam, @memberteam = MemberTeam, @ownerforum = t1.ForumID, @memberforum = t2.ForumID
		FROM Clubs c INNER JOIN Teams t1 ON c.OwnerTeam = t1.TeamID
					INNER JOIN Teams t2 ON c.MemberTeam = t2.TeamID
			WHERE ClubID = @clubid
							
	
	if (@isallowed = 0)
	BEGIN
		IF (@actiontype IN (1,2) AND @isteammember = 1)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'alreadymember', 'ActionID' = 0, 'ActionName' = @actionname
			Return 1
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'notallowed', 'ActionID' = 0, 'ActionName' = @actionname
			Return 1
		END
	END
	if (@actiontype IN (5,6) and @isowner = 0)
	BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'notowner', 'ActionID' = 0, 'ActionName' = @actionname
			Return 1
	END
	if (@actiontype = 7 and @isteammember = 0)
	BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'notmember', 'ActionID' = 0, 'ActionName' = @actionname
			Return 1
	END
	if (@actiontype = 4 AND EXISTS (select * from Clubs c INNER JOIN TeamMembers t ON c.OwnerTeam = t.TeamID WHERE c.ClubID = @clubid AND t.UserID = @actionuser))
	BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'alreadyowner', 'ActionID' = 0, 'ActionName' = @actionname
			Return 1
	END
	if (@actiontype IN (7) and @isowner = 1)
	BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'ownercantresign', 'ActionID' = 0, 'ActionName' = @actionname
			Return 1
	END
	if (@actiontype IN (5,6,8,9))
	BEGIN
			-- count the number of owners
			declare @ownercount int
			select @ownercount = COUNT(*) FROM TeamMembers WITH(UPDLOCK) WHERE TeamID = @ownerteam
			IF @ownercount = 1
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'lastownercantresign', 'ActionID' = 0, 'ActionName' = @actionname
				RETURN 1
			END
	END
	if (@actiontype IN (8,9) AND NOT EXISTS (select * from Clubs c INNER JOIN TeamMembers t ON c.OwnerTeam = t.TeamID WHERE t.UserID = @actionuser))
	BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'usernotowner', 'ActionID' = 0, 'ActionName' = @actionname
			Return 1
	END

	IF EXISTS (SELECT * FROM ClubMemberActions a WHERE ClubID = @clubid AND a.UserID = @actionUser AND ActionType = @Actiontype AND ActionResult = 0)
	BEGIN
		SELECT 'Success' = 1, 'Reason' = '', 'ActionName' = @actionname , a.* ,
		'ClubName' = c.Name, 
		'ActionUserName' = u.Username, U.FIRSTNAMES as ActionFirstNames, U.LASTNAME as ActionLastName, U.AREA as ActionArea, U.STATUS as ActionStatus, U.TAXONOMYNODE as ActionTaxonomyNode, J.ForumID as ActionJournal, U.ACTIVE as ActionActive, P.SITESUFFIX as ActionSiteSuffix, P.TITLE as ActionTitle,
		'OwnerUserName' = u2.Username, U2.FIRSTNAMES as OwnerFirstNames, U2.LASTNAME as OwnerLastName, U2.AREA as OwnerArea, U2.STATUS as OwnerStatus, U2.TAXONOMYNODE as OwnerTaxonomyNode, J2.ForumID as OwnerJournal, U2.ACTIVE as OwnerActive, P2.SITESUFFIX as OwnerSiteSuffix, P2.TITLE as OwnerTitle
			FROM ClubMemberActions a 
				INNER JOIN Users u ON a.UserID = u.UserID 
				LEFT JOIN Preferences p on p.UserID = u.UserID AND p.SiteID = @currentsiteid
				INNER JOIN Clubs c ON a.ClubID = c.ClubID 
				LEFT JOIN Users u2 ON a.OwnerID = u2.UserID 
				LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @currentsiteid
				INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = @currentsiteid
				LEFT JOIN Journals J2 on J2.UserID = U2.UserID and J2.SiteID = @currentsiteid
			WHERE a.ClubID = @clubid AND a.UserID = @actionUser AND ActionType = @Actiontype AND ActionResult = 0
		COMMIT TRANSACTION
		return 0
	END 

	declare @actionid int
	declare @ownerid int
	IF (@actiontype IN (3,4))
	BEGIN
		SELECT @ownerid = @userid
	END
	INSERT INTO ClubMemberActions (ClubID, UserID, OwnerID, ActionType, ActionResult, DateRequested)
		VALUES (@clubid, @actionuser, @ownerid, @actiontype, 0, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'Reason' = 'cantinsert', 'ActionID' = 0, 'ActionName' = @actionname
		RETURN @ErrorCode
	END
	SELECT @actionid = @@IDENTITY
	
	-- Check to see if this action autocompletes
	declare @autocomplete int
	select @autocomplete = 0


	-- Now try and autocomplete - all requests autocomplete except:
	--			Join as member when autojoin is off
	--			Join as owner when autojoin is off
	--			Invite as member always
	--			Invite as owner always
	select @autocomplete =	CASE
								WHEN @actiontype IN (5,6,7,8,9,10) THEN 1	-- all the direct action ones
								WHEN @actiontype = 1 AND @canautomember = 1 THEN 1	-- Join as member
								WHEN @actiontype = 2 AND @canautoowner = 1 THEN 1	-- Join as owner
								ELSE 0 END	-- type 3 and 4 or anything else

	IF (@autocomplete = 1)
	BEGIN
		EXEC completeclubaction @userid, @actionid, 1, @siteid, @currentsiteid
	END
	ELSE
	BEGIN
	SELECT 'Success' = 1, 'Reason' = '',  'ActionName' = @actionname, a.* ,
		'ClubName' = c.Name, 
		'ActionUserName' = u.Username, U.FIRSTNAMES as ActionFirstNames, U.LASTNAME as ActionLastName, U.AREA as ActionArea, U.STATUS as ActionStatus, U.TAXONOMYNODE as ActionTaxonomyNode, J.ForumID as ActionJournal, U.ACTIVE as ActionActive, P.SITESUFFIX as ActionSiteSuffix, P.TITLE as ActionTitle,
		'OwnerUserName' = u2.Username, U2.FIRSTNAMES as OwnerFirstNames, U2.LASTNAME as OwnerLastName, U2.AREA as OwnerArea, U2.STATUS as OwnerStatus, U2.TAXONOMYNODE as OwnerTaxonomyNode, J2.ForumID as OwnerJournal, U2.ACTIVE as OwnerActive, P2.SITESUFFIX as OwnerSiteSuffix, P2.TITLE as OwnerTitle 
		FROM ClubMemberActions a 
			INNER JOIN Users u ON a.UserID = u.UserID 
			LEFT JOIN Preferences p on p.UserID = u.UserID AND p.SiteID = @currentsiteid
			INNER JOIN Clubs c ON a.ClubID = c.ClubID
			LEFT JOIN Users u2 ON a.OwnerID = u2.UserID 
			LEFT JOIN Preferences p2 on p2.UserID = u.UserID AND p2.SiteID = @currentsiteid
			INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = @currentsiteid
			LEFT JOIN Journals J2 on J2.UserID = U2.UserID and J2.SiteID = @currentsiteid
		WHERE ActionID = @actionID
	END

	COMMIT TRANSACTION
	
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	IF (@actiontype IN (1,2))
	BEGIN
		EXEC addtoeventqueueinternal 'ET_CLUBMEMBERAPPLICATIONCHANGE', @clubid, 'IT_CLUB', @actionuser, 'IT_USER', @userid
	END
