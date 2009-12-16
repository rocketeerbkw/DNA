CREATE PROCEDURE fetchpreviewsitedata @siteid int
AS
-- First make sure that we have a preview row for the given site.
IF NOT EXISTS ( SELECT * FROM dbo.PreviewConfig WHERE SiteID = @siteid)
BEGIN
	-- Make sure we have an active config before trying to create the preview verison
	DECLARE @Error int
	IF NOT EXISTS ( SELECT * FROM dbo.Sites WHERE SiteID = @siteid )
	BEGIN
		RAISERROR('Fetch Preview Site Data - Active site has not been setup yet!',16,1)
		SELECT @Error = 50000
	END

	-- Now create the new row in the preview config table for the given site.	
	BEGIN TRANSACTION
	INSERT INTO dbo.PreviewConfig SELECT SiteID = @siteid, Config = s.Config, EditKey = NewID()
		FROM dbo.Sites s WHERE s.SiteID = @siteid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	COMMIT TRANSACTION
END

SELECT	s.SiteID,
		s.ShortName,
		s.Description,
		s.DefaultSkin,
		s.PreModeration,
		s.NoAutoSwitch,
		s.URLName,
		s.ModeratorsEmail,
		s.EditorsEmail,
		s.FeedbackEmail,
		s.AutoMessageUserID,
		s.Passworded,
		s.Unmoderated,
		s.ArticleForumStyle,
		pc.Config,
		pc.EditKey,
		s.ThreadOrder,
		s.EventEmailSubject,
		s.ThreadEditTimeLimit,
		s.EventAlertMessageUserID,
		s.ModClassID,
		s.AllowRemoveVote,
		p.AgreedTerms,
		k.SkinName,
		'SkinDescription' = k.Description,
		k.UseFrames,
		dp.*
	FROM Sites s 
	INNER JOIN PreviewConfig pc ON pc.SiteID = s.SiteID
	INNER JOIN SiteSkins k ON s.SiteID = k.SiteID
	INNER JOIN Preferences p ON s.SiteID = p.SiteID AND p.UserID = 0
	INNER JOIN DefaultPermissions dp ON s.SiteID = dp.SiteID
	WHERE s.SiteID = @siteid OR @siteid IS NULL
ORDER BY s.SiteID