CREATE PROCEDURE createboardpromoelement @siteid int, @userid int, @elementstatus int = 0, @elementlinkid int = 0, @frontpageposition int = 0
AS
DECLARE @Error int, @ElementID int, @BoardPromoElementID int, @Position int
-- Check to see if we've been given a frontpage pos?
IF (@frontpageposition > 0)
BEGIN
	-- Set the position to the one passed in
	SELECT @Position = @frontpageposition
END
ELSE
BEGIN
	-- Get the highest current position
	SELECT @Position = MAX(fpe.FrontPagePosition) FROM dbo.FrontPageElements fpe
		INNER JOIN dbo.BoardPromoElements bpe ON bpe.ElementID = fpe.ElementID
		WHERE fpe.SiteID = @siteid AND fpe.ElementStatus = @elementstatus

	-- Make sure it's not null, and add 1
	SELECT @Position = ISNULL(@Position,0) + 1
END

-- Create a new EditKey for the Element
DECLARE @EditKey uniqueidentifier
SELECT @EditKey = NEWID()

-- Now see if we have any deleted elements that we can re-use. Get the first ID with status = deleted
SELECT TOP 1 @ElementID = bpe.ElementID, @BoardPromoElementID = bpe.BoardPromoElementID FROM dbo.BoardPromoElements bpe
INNER JOIN dbo.FrontPageElements fpe ON fpe.ElementID = bpe.ElementID
WHERE fpe.ElementStatus = 2 ORDER BY fpe.ElementID ASC

--SELECT TOP 1 @ElementID = fpe.ElementID FROM dbo.FrontPageElements WHERE ElementStatus = 2 ORDER BY ElementID ASC
BEGIN TRANSACTION
	IF (@ElementID IS NULL)
	BEGIN
		INSERT INTO dbo.FrontPageElements (SiteID,ElementLinkID,ElementStatus,TemplateType,FrontPagePosition,Title,[Text],TextBoxType,TextBorderType,ImageName,DateCreated, LastUpdated,UserId,EditKey)
								VALUES (@siteid,@elementlinkid,@elementstatus,0,@Position,'','',0,0,NULL,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,@userid, @EditKey)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		SELECT @ElementID = @@IDENTITY

		INSERT INTO dbo.BoardPromoElements (ElementID,[Name]) VALUES (@ElementID,'New')
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		SELECT @BoardPromoElementID = @@IDENTITY
	END
	ELSE
	BEGIN
		--Reuse deleted front page element
		UPDATE dbo.FrontPageElements SET	SiteID = @siteid,
											ElementLinkID = @elementlinkid,
											ElementStatus = @elementstatus,
											FrontPagePosition = @Position,
											DateCreated = CURRENT_TIMESTAMP,
											LastUpdated = CURRENT_TIMESTAMP,
											UserId = @userid,
											EditKey = @EditKey
		WHERE ElementID = @ElementID
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	END
COMMIT TRANSACTION

-- Now return the new element in the results.
SELECT bpe.BoardPromoElementID, bpe.Name, fpe.* FROM dbo.FrontPageElements fpe
INNER JOIN dbo.BoardPromoElements bpe ON bpe.ElementID = fpe.ElementID
WHERE bpe.BoardPromoElementID = @BoardPromoElementID