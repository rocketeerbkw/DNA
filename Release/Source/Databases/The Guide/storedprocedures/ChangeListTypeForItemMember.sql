CREATE PROCEDURE changelisttypeforitemmember @userid int, @siteid int, @memberid int, @currentlisttype int, @newlisttype int
AS
DECLARE @CurrentListID uniqueidentifier, @NewListID uniqueidentifier
SELECT @CurrentListID = ItemListID FROM ItemList WITH(NOLOCK) WHERE UserID = @userid AND SiteID = @siteid AND ListType = @currentlisttype
SELECT @NewListID = ItemListID FROM ItemList WITH(NOLOCK) WHERE UserID = @userid AND SiteID = @siteid AND ListType = @newlisttype

-- Make sure the user has a current list.
IF (@CurrentListID IS NULL)
BEGIN
	SELECT 'Result' = 0
	RETURN 0
END

-- Make sure the item member belongs to the current list.
DECLARE @ItemID int, @ItemType int, @NotifyType int
SELECT @ItemID = ItemID, @ItemType = ItemType, @NotifyType = NotifyType FROM ItemListMembers WITH(NOLOCK) WHERE ItemListID = @CurrentListID AND MemberID = @memberid
IF ( @ItemID IS NULL )
BEGIN
	SELECT 'Result' = 0
	RETURN 0
END

-- Check to see if the user has the new type of list, if not create it.
DECLARE @Error int, @Description varchar(256), @RemoveOnly int
SELECT @RemoveOnly = 0 -- This is a flag that is used to say that the item already exists in the new list, so just remove it from the current!
BEGIN TRANSACTION
IF (@NewListID IS NULL)
BEGIN
	-- Get the correct description for the new list
	SELECT @Description = CASE WHEN @newlisttype = 2 THEN 'EMailAlertList'
				   WHEN @newlisttype = 3 THEN 'InstantEMailAlertList'
				   ELSE NULL END
	-- If we have a null description, then return as we don't have a type we know about
	IF (@Description IS NULL)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Result' = 0
		RETURN 0
	END

	-- Try to create the new list
	SELECT @NewListID = NewID()
	INSERT INTO ItemList SELECT @NewListID, @userid, @Description, @newlisttype, GetDate(), GetDate(), @siteid
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
	-- Check to see if the item already exists in the new list
	IF EXISTS ( SELECT * FROM ItemListMembers WITH(NOLOCK) WHERE ItemListID = @NewListID AND ItemID = @ItemID AND ItemType = @ItemType AND NotifyType = @NotifyType )
	BEGIN
		SELECT @RemoveOnly = 1
	END
END

-- Check to see if we only want to remove the item? i.e. the item already exists in the new list!
IF ( @RemoveOnly = 0 )
BEGIN
	-- Now remove the item member from the current list and add it to the new list
	INSERT INTO ItemListMembers SELECT @NewListID, @ItemID, @ItemType, @NotifyType
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	-- Update the last updated param so that the list is refreshed correctly
	UPDATE ItemList SET LastUpdated = GetDate() WHERE ItemListID = @NewListID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
END

-- Now remove the item from the old list
DELETE FROM ItemListMembers WHERE MemberID = @memberid
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

-- Update the last updated param so that the list is refreshed correctly
UPDATE ItemList SET LastUpdated = GetDate() WHERE ItemListID = @CurrentListID
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

COMMIT TRANSACTION

SELECT 'Result' = 1
