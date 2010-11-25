CREATE PROCEDURE getbievents @batchsize int = 100
AS
	-- These are the events we're interested in
	-- ET_POSTTOFORUM             = 19
	-- ET_POSTNEEDSRISKASSESSMENT = 21
	-- ET_MODERATIONDECISION_POST = 23

	DECLARE @true BIT, @false BIT;
	SELECT @true = 1,  @false = 0;

	WITH Events AS
	(
		SELECT TOP(@batchSize)
			beq.EventId,
			beq.EventType,
			beq.ItemId,
			beq.ItemId2,
			beq.EventDate
		FROM dbo.BIEventQueue beq
		ORDER BY beq.EventId
	),
	RiskModEvents AS
	(
		SELECT	e.EventId,
				e.EventType,
				e.EventDate,
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
				rq.RiskModThreadEntryQueueId,
				NULL AS ModDecisionStatus,
				NULL AS IsComplaint
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
				e.EventDate,
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
				NULL AS RiskModThreadEntryQueueId,
				NULL AS ModDecisionStatus,
				NULL AS IsComplaint
			FROM Events e
			INNER JOIN dbo.ThreadEntries te ON te.EntryId = e.ItemId2
			INNER JOIN dbo.Forums f ON f.ForumId = te.ForumId
			INNER JOIN dbo.Sites s ON s.siteid = f.siteid
			WHERE e.EventType = 19 -- ET_POSTTOFORUM
	),
	PostModDecisionEvents AS
	(
		SELECT	e.EventId,
				e.EventType,
				e.EventDate,
				te.EntryId AS ThreadEntryId,
				NULL AS ModClassId,
				NULL AS SiteId,
				NULL AS ForumId,
				NULL AS ThreadId,
				NULL AS UserId,
				NULL AS NextSibling,
				NULL AS Parent,
				NULL AS PrevSibling,
				NULL AS FirstChild,
				NULL AS DatePosted,
				NULL AS text,
				NULL AS RiskModThreadEntryQueueId,
				tmh.Status AS ModDecisionStatus,
				CASE WHEN tm.ComplaintText IS NULL THEN @false ELSE @true END AS IsComplaint
			FROM Events e
			INNER JOIN dbo.ThreadEntries te ON te.EntryId = e.ItemId2
			INNER JOIN dbo.ThreadModHistory tmh ON tmh.HistoryModId = e.ItemId
			INNER JOIN dbo.ThreadMod tm ON tm.ModId = tmh.ModId
			WHERE e.EventType = 23 -- ET_MODERATIONDECISION_POST
	)
	SELECT * FROM RiskModEvents
	UNION ALL 
	SELECT * FROM NewPostEvents
	UNION ALL 
	SELECT * FROM PostModDecisionEvents
	ORDER BY EventId
	