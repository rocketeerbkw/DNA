CREATE PROCEDURE processexpiredpremodpostings
AS
BEGIN TRANSACTION

	;WITH ExpiryContenders AS
	(
		-- Find the rows that need their Expiry Time checking
		-- NB It's important to use UPDLOCK within a transaction to prevent moderators picking up expired posts
		SELECT pp.ModId
			  ,DATEADD(minute,CAST(dbo.udf_getsiteoptionsetting(pp.SiteId, 'Moderation', 'ExternalCommentQueuedExpiryTime') AS INT),DatePosted) ExpiryDate
			FROM dbo.PremodPostings pp WITH(UPDLOCK) 
			INNER JOIN ThreadMod tm WITH(UPDLOCK) ON tm.ModId = pp.ModId
			WHERE pp.ApplyExpiryTime=1 AND tm.Status=0 AND tm.LockedBy IS NULL AND
				CAST(dbo.udf_getsiteoptionsetting(pp.SiteId, 'Moderation', 'ExternalCommentQueuedExpiryTime') AS INT) >= 0
	)
	-- Now select the rows that have expired
	SELECT ModId INTO #ExpiryRows
		FROM ExpiryContenders ec
		WHERE DATEDIFF(second,ec.ExpiryDate,GETDATE()) >= 0

	-- Move the expired ThreadMod rows into the Expired table
	DELETE FROM tm
		OUTPUT deleted.* INTO ThreadModExpired
		FROM dbo.ThreadMod tm
		INNER JOIN #ExpiryRows er ON er.ModId = tm.ModId

	-- Move the expired PremodPostings rows into the Expired table
	DELETE FROM pp
		OUTPUT deleted.* INTO PremodPostingsExpired
		FROM dbo.PremodPostings pp
		INNER JOIN #ExpiryRows er ON er.ModId = pp.ModId

COMMIT TRANSACTION
