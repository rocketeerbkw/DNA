CREATE PROCEDURE makeinstantitemmemberanormalalert @userid int, @siteid int, @memberid int
AS
-- Get the List ID for sanity checking
DECLARE @InstantListID uniqueidentifier
SELECT @InstantListID = InstantEMailAlertListID FROM dbo.InstantEMailAlertList WHERE UserID = @UserID AND SiteID = @SiteID

-- Get the item details so we can check to make sure we don't duplicate into the instant list
DECLARE @ItemID int, @ItemType int, @AlertGroupID int
SELECT @ItemID = ItemID, @ItemType = ItemType, @AlertGroupID = AlertGroupID FROM dbo.EmailAlertListMembers WHERE EmailAlertListID = @InstantListID AND MemberID = @MemberID

-- Check to see if the Item exists
IF ( @ItemID IS NULL )
BEGIN
	-- The Member either does not belong to the users list or is not a normal alert!
	SELECT 'Result' = 0
	RETURN 0
END

-- Done the investigation, start the transaction phase
BEGIN TRANSACTION

-- Now Get the Users InstantEmailAlertList
DECLARE @ListID uniqueidentifier, @Error int, @DoMoveItem int
SELECT @ListID = EMailAlertListID FROM dbo.EMailAlertList WHERE UserID = @UserID
IF ( @ListID IS NULL )
BEGIN
	-- Create the new list for the user
	SELECT @ListID = NewID()
	INSERT INTO dbo.EMailAlertList (EmailAlertListID, UserID, CreatedDate, LastUpdated, SiteID)
		VALUES (@ListID, @UserID, GetDate(), GetDate(), @SiteID)
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	-- set the flag that states we need to insert the item into the instant list
	SET @DoMoveItem = 1
END
ELSE
BEGIN
	-- Check to make sure they don't have the item already in their instant list already
	SET @DoMoveItem = CASE WHEN EXISTS ( SELECT * FROM dbo.EmailAlertListMembers WHERE ItemID = @ItemID AND ItemType = @ItemType AND AlertGroupID = @AlertGroupID AND EmailAlertListID = @ListID ) THEN 0 ELSE 1 END
END

-- Do we need to move the item into the instant list
IF ( @DoMoveItem > 0 )
BEGIN
	-- Move the item by changing the EMailLaertListID to the Instant one!
	UPDATE dbo.EmailalertListMembers SET EmailAlertListID = @ListID WHERE MemberID = @MemberID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
END

-- update the lastupdated values for the normal and instant lists	
UPDATE dbo.EmailAlertList SET LastUpdated = GetDate() WHERE EMailAlertlistID = @ListID
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

-- update the lastupdated values for the normal and instant lists	
UPDATE dbo.InstantEmailAlertList SET LastUpdated = GetDate() WHERE InstantEMailAlertlistID = @InstantListID
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

COMMIT TRANSACTION

SELECT 'Result' = 1
/*
DECLARE @ItemID int
DECLARE @ItemType int
DECLARE @InstantEMailAlertListID uniqueidentifier
DECLARE @EMailAlertListID uniqueidentifier
DECLARE @NotifyType int
DECLARE @Error int

-- Make sure the member exists
SELECT @InstantEMailAlertListID = InstantEMailAlertListID, @ItemType = ItemType, @ItemID = ItemID, @NotifyType = NotifyType FROM dbo.InstantEMailAlertListMembers WHERE MemberID = @memberid
IF ( @InstantEMailAlertListID IS NULL )
BEGIN
	SELECT 'Result' = 0
	RETURN 0
END

-- Now make sure the user already owns the member
DECLARE @ListOwnerID int
SELECT @ListOwnerID = UserID FROM dbo.InstantEMailAlertList WHERE InstantEMailAlertListID = @InstantEMailAlertListID
IF (@ListOwnerID <> @userid)
BEGIN
	SELECT 'Result' = 0
	RETURN 0
END

-- Now we definatly have something to do! Start the transaction
BEGIN TRANSACTION

-- Now make sure the the item does not already exist in the Instant members
IF NOT EXISTS (	SELECT * FROM dbo.EmailAlertListMembers iem
			INNER JOIN dbo.EMailAlertList iel ON iel.EmailAlertListID = iem.EmailAlertListID
			WHERE iem.ItemID = @ItemID AND iem.ItemType = @ItemType AND iel.UserID = @userid AND iel.SiteID = @siteid )
BEGIN
	-- Now check to see if the user already has an Instant EMail Alert List
	SELECT @EMailAlertListID = EmailAlertListID FROM dbo.EmailAlertList WHERE UserID = @userid AND SiteID = @siteid
	IF ( @EMailAlertListID IS NULL )
	BEGIN
		-- Create the new instant list for the user
		SELECT @EMailAlertListID = NewID()
		INSERT INTO dbo.EMailAlertList (EmailAlertListID,UserID,CreatedDate,LastUpdated,SiteID)
			VALUES (@EMailAlertListID,@userid,GetDate(),GetDate(),@siteid)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	END
	ELSE
	BEGIN
		-- Update the Last updated field for the list
		UPDATE dbo.EMailAlertList SET LastUpdated = GetDate()
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	END

	-- Now Just add the member to the EMailAlertListMembers table
	INSERT INTO dbo.EmailAlertListMembers ( EMailAlertListID, ItemID, ItemType, NotifyType )
		VALUES ( @EMailAlertListID, @ItemID, @ItemType, @NotifyType )
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
END

-- Now remove it from the normal list!
DELETE FROM dbo.InstantEmailAlertListMembers WHERE MemberID = @memberid
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC error @Error
	RETURN @Error
END

-- Everything is now done!
COMMIT TRANSACTION
SELECT 'Result' = 1
*/