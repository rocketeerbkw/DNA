CREATE PROCEDURE getcurrentguideentriesinbatch @ifirst int, @dmorerecentthan datetime = NULL
AS
BEGIN

	DECLARE @EntryId INT, @ErrorCode INT
	SELECT 	@EntryId = 0

	-- Find the first entry that 
	IF(@dmorerecentthan IS NOT NULL)
	BEGIN
		SELECT TOP 1 @EntryID = EntryID FROM GuideEntries
		WHERE EntryID >= @ifirst AND LastUpdated > @dmorerecentthan
		AND Type != 3001
	END
	ELSE
	BEGIN
		SELECT TOP 1 @EntryID = EntryID FROM GuideEntries WHERE EntryID >= @ifirst
	END
		
	DECLARE @BatchSize INT
	SELECT @BatchSize = 50

	IF(@EntryID > 0)
	BEGIN
		-- we've got at least an entry to return
		-- get the first entry in the batch the one found belongs to
		SELECT @ifirst = (@EntryID/@BatchSize)*@BatchSize

		DECLARE @count INT
		SELECT @count = COUNT(EntryId) FROM GuideEntries
		WHERE EntryID >= @ifirst AND EntryID < (@ifirst + @BatchSize)
		AND Type != 3001	-- we don't want user pages
		AND Status != 7 AND Status < 10

		IF(@Count > 0)
		BEGIN
			-- we have entries that meet the condition
			SELECT 'BatchStatus' = 0, 'BatchFirst' = @ifirst, h2g2id FROM GuideEntries
			WHERE EntryID >= @ifirst AND EntryID < (@ifirst + @BatchSize)
			AND Type != 3001	-- we don't want user pages
			AND Status != 7 AND Status < 10 AND Hidden IS NULL
		END
		ELSE IF (@Count <=0 AND @ifirst > 0)
		BEGIN
			-- We have a batch of entries, none of which meet the condition
			SELECT 'BatchStatus' = 2, 'BatchFirst' = @ifirst, 'H2G2ID' = NULL
		END
	END
	ELSE
	BEGIN
		-- There are no entries left in the table to return  
		SELECT 'BatchStatus' = 1, 'BatchFirst' = NULL, 'H2G2ID' = NULL
	END	
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	
END
