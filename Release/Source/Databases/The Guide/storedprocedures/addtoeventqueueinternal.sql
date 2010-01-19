CREATE PROCEDURE addtoeventqueueinternal @eventtype varchar(50), @itemid int, @itemtype varchar(50), @itemid2 int = 0, @itemtype2 varchar(50) = 'IT_ALL', @userid int
AS
DECLARE @iEventType int
DECLARE @iItemType int
DECLARE @iItemType2 int
DECLARE @ErrorCode INT

EXEC SetEventTypeValInternal @eventtype, @iEventType OUTPUT
EXEC SetItemTypeValInternal @itemtype, @iItemType OUTPUT
EXEC SetItemTypeValInternal @itemtype2, @iItemType2 OUTPUT

BEGIN TRANSACTION

INSERT INTO EventQueue ( EventType, ItemID, ItemType, ItemID2, ItemType2, EventDate, EventUserID) 
				VALUES (@iEventType, @itemid, @iItemType, @itemid2, @iItemType2, GetDate(), @UserID)
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END
	
COMMIT TRANSACTION
