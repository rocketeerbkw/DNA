CREATE PROCEDURE automod_syncbannedacrosssites @userid INT, @siteid INT
AS
	/*
		Function: Controls sync of user's mod status when user has been banned. 

		Params:
			@userid - User to be synced. 
			@siteid - Site to be ignored (i.e. site that already has updated mod status and trust points).

		Results Set: 

		Returns: @@ERROR

	*/

	DECLARE @UpdatedModStatusTrustPoints_Tbl TABLE (SiteID INT, ModStatus UserModStatus, TrustPoints SMALLINT); 

	-- Make user premoderated across all sites they are a member of and are not already banned. 
	UPDATE dbo.Preferences
	   SET ModStatus = 1, -- Premod
		   TrustPoints = PostmodThresholdValue - 1
	OUTPUT INSERTED.SiteID, INSERTED.ModStatus, INSERTED.TrustPoints
	  INTO @UpdatedModStatusTrustPoints_Tbl
	  FROM dbo.Preferences p
	 INNER JOIN dbo.Sites s ON p.SiteID = s.SiteID
	 WHERE p.UserID = @userid
	   AND p.SiteID <> @siteid
	   AND p.ModStatus <> 4 -- Restricted (aka banned)
	   AND p.TrustPoints >= PostmodThresholdValue

	INSERT	INTO dbo.AutoModAudit (UserID,  SiteID,  ReasonID,  TrustPoints,  ModStatus)
	SELECT	@userid, 
			SiteID, 
			12, -- SyncToBanned
			TrustPoints, 
			ModStatus
	  FROM	@UpdatedModStatusTrustPoints_Tbl

RETURN @@ERROR