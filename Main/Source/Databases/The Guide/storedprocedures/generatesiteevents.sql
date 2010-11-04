CREATE PROCEDURE generatesiteevents @topeventid INT
AS
	INSERT INTO dbo.SiteActivityQueue (EventType,   ItemID,   ItemType,   ItemID2,   ItemType2,   EventDate,   EventUserID)
		SELECT                 EQ.EventType,EQ.ItemID,EQ.ItemType,EQ.ItemID2,EQ.ItemType2,EQ.EventDate,EQ.EventUserID
			FROM dbo.EventQueue EQ
			WHERE EQ.EventType > 17 -- everything after this event type
			AND (EQ.EventID <= @TopEventID)
