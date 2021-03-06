USE TheGuide

DECLARE @Id					int
DECLARE @TwitterUserID		nvarchar(40)
DECLARE @TwitterScreenName  nvarchar(255)
DECLARE @TwitterName		nvarchar(255)
DECLARE @DNAUserID			int
DECLARE @SiteID				int
DECLARE @Count				int

SELECT @SiteID = SiteID FROM [dbo].[Sites] WHERE URLName = 'newscorrespondentstweets'

IF (@SiteID IS NOT NULL)
BEGIN
	SET @Count = 50
	WHILE (SELECT COUNT(*) FROM [dbo].[AtheletesDetails] WHERE Processed = 0) > 0 AND @Count > 0
	BEGIN

		SELECT TOP 1 @Id = ID FROM [dbo].[AtheletesDetails] WHERE Processed = 0

		SELECT @TwitterUserID	  = TwitterUserID FROM [dbo].[AtheletesDetails] WHERE ID = @Id
		SELECT @TwitterScreenName = TwitterScreenName FROM [dbo].[AtheletesDetails] WHERE ID = @Id
		SELECT @TwitterName		  = Name FROM [dbo].[AtheletesDetails] WHERE ID = @Id
		
		--Register the twitteruser
		EXEC createnewuserfromtwitteruserid @TwitterUserID, @TwitterScreenName, @TwitterName

		SELECT @DNAUserID = DnaUserID FROM [dbo].[SignInUserIDMapping] WHERE TwitterUserID = @twitteruserid

		-- Sitesuffix is set on tweet ingestion
		
		-- Setting the user as trusted - editor, notables, trusted
		EXEC addusertogroup @DNAUserID, @siteid, 'notables'
		
		-- if more than one group 
		
		--EXEC addusertogroups @userid = @DNAUserID, @siteid = 1, @groupname1 = 'notables', @groupname2 = 'editor', @groupname3 = 'trusted'

		UPDATE [dbo].[AtheletesDetails] SET Processed = 1 WHERE ID = @Id

		SET @Count = @Count - 1
	END
END
ELSE
BEGIN
	PRINT 'No siteid found!'
END

