CREATE PROCEDURE updatesitedetails	@siteid int,
										@shortname varchar(255),
										@description varchar(255),
										@defaultskin varchar(255),
										@skinset varchar(255),
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
										@allowremovevote int, 
										@includecrumbtrail int,
										@allowpostcodesinsearch int,
										@queuepostings int,	
										@ssoservice varchar(50) = null,					
										@siteemergencyclosed int = 0,
										@identitypolicy varchar(255) = null,
										@bbcdivisionid int =0
As
if EXISTS (SELECT * FROM SiteSkins WHERE SiteID = @siteid AND SkinName = @defaultskin)
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	update sites 
		SET shortname				= @shortname,
			Description				= @description,
			DefaultSkin				= @defaultskin,
			SkinSet                 = @skinset,
			PreModeration			= @premoderation,
			NoAutoSwitch			= @noautoswitch,
			ModeratorsEmail			= @moderatorsemail,
			EditorsEmail			= @editorsemail,
			FeedbackEmail			= @feedbackemail,
			AutoMessageUserID		= @automessageuserid,
			Passworded				= @passworded,
			Unmoderated				= @unmoderated,
			ArticleForumStyle		= @articleforumstyle,
			ThreadOrder				= @threadorder,
			ThreadEditTimeLimit		= @threadedittimelimit,
			EventEmailSubject		= @eventemailsubject,
			EventAlertMessageUserID = @eventalertmessageuserid,
			AllowRemoveVote			= @allowremovevote, 
			IncludeCrumbtrail		= @includecrumbtrail,
			AllowPostCodesInSearch	= @allowpostcodesinsearch,
			QueuePostings			= @queuepostings,
			SSOService				= ISNULL(@ssoservice,urlname),
			SiteEmergencyClosed		= siteemergencyclosed,
			IdentityPolicy			= ISNULL(@identitypolicy,IdentityPolicy),
			BBCDivisionID			= @bbcdivisionid
		WHERE SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Result' = 1, 'Error' = 'Internal error' 
		RETURN @ErrorCode
	END

	update Preferences
		SET AgreedTerms = CASE WHEN @customterms = 1 THEN NULL ELSE 1 END
		WHERE SiteID = @siteid AND UserID = 0
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Result' = 1, 'Error' = 'Internal error' 
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	SELECT 'Result' = 0
END
ELSE
BEGIN
	SELECT 'Result' = 1, 'Error' = 'Default skin does not belong to site' 
END