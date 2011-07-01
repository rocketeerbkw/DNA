CREATE PROCEDURE createnewsite	@urlname varchar(50),
									@shortname varchar(50),
									@description varchar(255),
									@defaultskin varchar(100),
									@skindescription varchar(255),
									@skinset varchar(255),
									@useframes int,
									@premoderation int,
									@noautoswitch int,
									@customterms int,
									@moderatorsemail varchar(255),
									@editorsemail varchar(255),
									@feedbackemail varchar(255),
									@automessageuserid int,
									@passworded int,
									@unmoderated int,
									@articleforumstyle int,
									@threadorder int,
									@threadedittimelimit int,
									@eventemailsubject varchar(255),
									@eventalertmessageuserid int, 
									@includecrumbtrail int,
									@allowpostcodesinsearch int, 
									@ssoservice varchar(50) = null,
									@siteemergencyclosed int = 0,
									@allowremovevote int = 0,
									@queuepostings int = 0,
									@modclassid int = 1,
									@identitypolicy varchar(255),
									@bbcdivisionid int =0
AS

IF EXISTS (SELECT * FROM Sites WHERE URLName = @urlname)
BEGIN
	SELECT 'SiteID' = 0
END
ELSE
BEGIN
	DECLARE @editorgroup int
	SELECT @editorgroup = GroupID FROM Groups WHERE Name = 'Editor' AND UserInfo = 1
	
	DECLARE @moderatorgroup int
	SELECT @moderatorgroup = GroupID FROM Groups WHERE Name = 'Moderator'
	
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	INSERT INTO Sites (URLName, ShortName, Description, DefaultSkin, SkinSet, PreModeration, 
						noautoswitch, ModeratorsEmail, EditorsEmail, FeedbackEmail,
						AutoMessageUserID, Passworded, Unmoderated, ArticleForumStyle, ThreadOrder,
						ThreadEditTimeLimit, EventEmailSubject, EventAlertMessageUserID, IncludeCrumbtrail, 
						AllowPostCodesInSearch, SiteEmergencyClosed, SSOService, AllowRemoveVote, QueuePostings,
						ModClassId, IdentityPolicy, bbcdivisionid )
		VALUES(@urlname, @shortname, @description, @defaultskin, @skinset, @premoderation, 
				@noautoswitch, @moderatorsemail, @editorsemail, @feedbackemail,
				@automessageuserid, @passworded, @unmoderated, @articleforumstyle, @threadorder,
				@threadedittimelimit, @eventemailsubject, @eventalertmessageuserid, @includecrumbtrail, 
				@allowpostcodesinsearch, @siteemergencyclosed, ISNULL(@ssoservice,@urlname), @allowremovevote,
				@queuepostings, @modclassid, @identitypolicy, @bbcdivisionid )
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'SiteID' = 0
		RETURN @ErrorCode
	END

	declare @siteid int
	SELECT @siteid = @@IDENTITY

	INSERT INTO SiteSkins (SiteID, SkinName, Description, UseFrames)
		VALUES(@siteid, @defaultskin, @skindescription, @useframes)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'SiteID' = 0
		RETURN @ErrorCode
	END

	INSERT INTO Preferences	(UserID, 
							PrefForumStyle, 
							PrefForumThreadStyle, 
							PrefForumShowMaxPosts, 
							PrefReceiveWeeklyMailshot, 
							PrefReceiveDailyUpdates, 
							PrefSkin, 
							PrefUserMode, 
							SiteID, 
							AgreedTerms)
		VALUES(0, 0, 0, 0, 0, 0, NULL, 0, @siteid, 
				CASE WHEN @customterms = 1 THEN NULL ELSE 1 END)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'SiteID' = 0
		RETURN @ErrorCode
	END

	declare @nodeid int
	EXEC @ErrorCode = addnodetohierarchyinternal NULL, 'Top', @siteid, @nodeid OUTPUT
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'SiteID' = 0
		RETURN @ErrorCode
	END

	INSERT INTO DefaultPermissions (SiteID)
		VALUES (@siteid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'SiteID' = 0
		RETURN @ErrorCode
	END

	INSERT INTO GroupMembers (UserID, SiteID, GroupID)
		VALUES(6, @siteid, @editorgroup)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'SiteID' = 0
		RETURN @ErrorCode
	END
	
	-- Add Moderators/Editors / Notables to site.
	IF @modclassid IS NOT NULL
	BEGIN
	    INSERT INTO GroupMembers ( UserId, SiteId, GroupId )
	    SELECT userid, @siteid, GroupId
	    FROM ModerationClassMembers mc
	    WHERE mc.ModClassId = @modclassid
	END

	-- If there is a DNA-SiteBuilder user, make it an editor on this site
	DECLARE @DNASiteBuilderID int
	SELECT @DNASiteBuilderID=UserID FROM Users WHERE LoginName='DNA-SiteBuilder'
	
	IF (@DNASiteBuilderID IS NOT NULL)
	BEGIN
		INSERT INTO GroupMembers (UserID, SiteID, GroupID)
			VALUES(@DNASiteBuilderID, @siteid, @editorgroup)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'SiteID' = 0
			RETURN @ErrorCode
		END
	END

	INSERT INTO HierarchyNodeTypes (NodeType,SiteID,Description)
		VALUES(1,@SiteID,'UnTyped')
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'SiteID' = 0
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	SELECT 'SiteID' = @siteid
END