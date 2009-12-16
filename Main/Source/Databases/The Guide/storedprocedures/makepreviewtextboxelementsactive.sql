CREATE PROCEDURE makepreviewtextboxelementsactive @siteid int, @editorid INT
AS
DECLARE @TextBoxElementID int
DECLARE @ErrorCode int, @ExecErrorCode int

BEGIN TRANSACTION

	-- Create a cursor to go through the list of elements
	DECLARE Element_Cursor CURSOR DYNAMIC
	
	-- Select all the Preview and ArchivedPreview TextBox Elements
	FOR SELECT te.TextBoxElementID FROM dbo.TextBoxElements te
		INNER JOIN dbo.FrontPageElements fpe ON te.ElementID = fpe.ElementID
		WHERE fpe.SiteID = @SiteID AND fpe.ElementStatus IN (1,4)
	
	-- Open the cursor
	OPEN Element_Cursor

	-- Now Get the FrontPageElementID
	FETCH NEXT FROM Element_Cursor INTO @TextBoxElementID

	-- Loop through the cursor results making each individual element active
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Call the make active procedure for the current element
		EXEC @ErrorCode = MakePreviewTextBoxElementActive @TextBoxElementID, @editorid
		SELECT @ExecErrorCode = @@ERROR
		IF (@ExecErrorCode <> 0) BEGIN SET @ErrorCode = @ExecErrorCode END
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			CLOSE Element_Cursor
			DEALLOCATE Element_Cursor
			RETURN @ErrorCode
			EXEC Error @ErrorCode
		END
						
		-- Get the next element ID
 		FETCH NEXT FROM Element_Cursor INTO @TextBoxElementID
	END

	-- Finish by closing and getting rid of the Cursor
	CLOSE Element_Cursor
	DEALLOCATE Element_Cursor
				
COMMIT TRANSACTION