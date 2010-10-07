CREATE PROCEDURE generatebievents @topeventid INT
AS
	-- These are the events we're interested in
	-- ET_POSTNEEDSRISKASSESSMENT = 21

	INSERT INTO dbo.BIEventQueue (EventType,   ItemID,   ItemType,   ItemID2,   ItemType2,   EventDate,   EventUserID)
		SELECT                 EQ.EventType,EQ.ItemID,EQ.ItemType,EQ.ItemID2,EQ.ItemType2,EQ.EventDate,EQ.EventUserID
			FROM dbo.EventQueue EQ
			WHERE EQ.EventType IN (21)
			AND EQ.EventID <= @TopEventID
