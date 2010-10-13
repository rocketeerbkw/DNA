CREATE PROCEDURE getbievents @batchsize int = 100
AS
	-- These are the events we're interested in
	-- ET_POSTTOFORUM             = 19
	-- ET_POSTNEEDSRISKASSESSMENT = 21
	WITH Events AS
	(
		SELECT TOP(@batchSize)
			beq.EventId,
			beq.EventType,
			beq.ItemId,
			beq.ItemId2
		FROM dbo.BIEventQueue beq
		ORDER BY beq.EventId
	),
	RiskModEvents AS
	(
		SELECT	e.EventId,
				e.EventType,
				rq.ThreadEntryId,	
				s.ModClassId,
				s.SiteId,
				rq.ForumId,
				rq.ThreadId,
				rq.UserId,
				te.NextSibling,
				te.Parent,
				te.PrevSibling,
				te.FirstChild,
				rq.DatePosted,
				rq.text,
				rq.RiskModThreadEntryQueueId
			FROM Events e
			INNER JOIN dbo.RiskModThreadEntryQueue rq ON rq.RiskModThreadEntryQueueId = e.ItemId
			INNER JOIN dbo.Sites s ON s.siteid = rq.siteid
			LEFT  JOIN dbo.ThreadEntries te ON te.EntryId = rq.ThreadEntryId
			WHERE e.EventType = 21 -- ET_POSTNEEDSRISKASSESSMENT
	),
	NewPostEvents AS
	(
		SELECT	e.EventId,
				e.EventType,
				te.EntryId AS ThreadEntryId,
				s.ModClassId,
				s.SiteId,
				te.ForumId,
				te.ThreadId,
				te.UserId,
				te.NextSibling,
				te.Parent,
				te.PrevSibling,
				te.FirstChild,
				te.DatePosted,
				te.text,
				NULL AS RiskModThreadEntryQueueId
			FROM Events e
			INNER JOIN dbo.ThreadEntries te ON te.EntryId = e.ItemId2
			INNER JOIN dbo.Forums f ON f.ForumId = te.ForumId
			INNER JOIN dbo.Sites s ON s.siteid = f.siteid
			WHERE e.EventType = 19 -- ET_POSTTOFORUM
	)
	SELECT * FROM RiskModEvents
	UNION ALL 
	SELECT * FROM NewPostEvents
	ORDER BY EventId
	