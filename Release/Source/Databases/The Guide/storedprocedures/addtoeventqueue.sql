CREATE PROCEDURE addtoeventqueue @eventtype int, @eventuserid int, @itemid int, @itemtype int, @itemid2 int, @itemtype2 int
AS

DECLARE @ErrorCode INT

BEGIN TRANSACTION

INSERT INTO EventQueue ( EventType, ItemID, ItemType, ItemID2, ItemType2, EventDate, EventUserID) 
				VALUES (@eventtype,@itemid,@itemtype,@itemid2,@itemtype2,GetDate(),@eventuserid)
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END
	
COMMIT TRANSACTION
