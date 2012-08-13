CREATE PROCEDURE generatebievents @topeventid INT
AS
	-- These are the events we're interested in
	-- ET_POSTTOFORUM             = 19
	-- ET_POSTNEEDSRISKASSESSMENT = 21
	-- ET_MODERATIONDECISION_POST = 23

	INSERT INTO dbo.BIEventQueue (EventType,   ItemID,   ItemType,   ItemID2,   ItemType2,   EventDate,   EventUserID)
		SELECT                 EQ.EventType,EQ.ItemID,EQ.ItemType,EQ.ItemID2,EQ.ItemType2,EQ.EventDate,EQ.EventUserID
			FROM dbo.EventQueue EQ
			WHERE 
			(
				EQ.EventType IN (21,23)
				OR EQ.ItemID IN 
				(
					SELECT EQ2.ItemID
						FROM dbo.EventQueue EQ2
						INNER JOIN dbo.Forums f on f.forumid = EQ2.ItemID
						INNER JOIN dbo.RiskModerationState rms on rms.id = f.siteid
						WHERE EQ.EventType = 19 AND rms.idtype='S' AND rms.Ison = 1
				)
			)
			AND EQ.EventID <= @TopEventID
