CREATE PROCEDURE generatebievents @topeventid INT
AS
	-- These are the events we're interested in
	-- ET_POSTTOFORUM             = 19
	-- ET_POSTNEEDSRISKASSESSMENT = 21
	-- ET_MODERATIONDECISION_POST = 23

	INSERT INTO dbo.BIEventQueue (EventType,   ItemID,   ItemType,   ItemID2,   ItemType2,   EventDate,   EventUserID)
		SELECT                 EQ.EventType,EQ.ItemID,EQ.ItemType,EQ.ItemID2,EQ.ItemType2,EQ.EventDate,EQ.EventUserID
			FROM dbo.EventQueue EQ
			WHERE EQ.EventType IN (19,21,23)
			AND EQ.EventID <= @TopEventID