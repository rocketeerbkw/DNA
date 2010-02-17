BEGIN TRANSACTION

-- Set up the topics we want to unarchive
DECLARE @PreviewTopicID int, @ActiveTopicID int
SELECT @PreviewTopicID = 670, @ActiveTopicID = 694

-- Get the Site Builder ID to use as the editoing user
DECLARE @Error int, @ValidID int, @EditorID int
SELECT @EditorID = UserID FROM dbo.Users WITH(NOLOCK) WHERE UserName Like 'DNA-SiteBuilder'
IF (@EditorID <> 0)
BEGIN
	-- Unarchive the preview topic
	EXEC @Error = unarchivetopicinternal @PreviewTopicID, @EditorID, @ValidID OUTPUT
	SELECT @Error = dbo.udf_checkerr(@@ERROR,@Error)
	IF (@Error = 0)
	BEGIN
		-- Now unarchive the active topic
		EXEC @Error = unarchivetopicinternal @ActiveTopicID, @EditorID, @ValidID OUTPUT
		SELECT @Error = dbo.udf_checkerr(@@ERROR,@Error)
	END
END

-- Did we get any errors?
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
END
ELSE
BEGIN
	COMMIT TRANSACTION
END
