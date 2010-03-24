CREATE PROCEDURE automod_syncpostmodacrosssites @userid INT, @siteid INT
AS
	/*
		Function: Controls sync of user's mod status when changing to post mod. 

		Params:
			@userid - User to be synced. 
			@siteid - Site to be ignored (i.e. site that already has updated mod status and trust points).

		Results Set: 

		Returns: @@ERROR
	*/

	DECLARE @UpdatedModStatusTrustPoints_Tbl TABLE (SiteID INT, ModStatus UserModStatus, TrustPoints SMALLINT); 

	-- Only sync user's memberships that are in premod to post mod.
	UPDATE dbo.Preferences
	   SET ModStatus = 2, -- Postmod
		   TrustPoints = PostmodThresholdValue
	OUTPUT INSERTED.SiteID, INSERTED.ModStatus, INSERTED.TrustPoints
	  INTO @UpdatedModStatusTrustPoints_Tbl
	  FROM dbo.Preferences p
	 INNER JOIN dbo.Sites s ON p.SiteID = s.SiteID
	 WHERE p.UserID = @userid
	   AND p.SiteID <> @siteid
	   AND p.ModStatus = 1 -- Premoderated

	INSERT	INTO dbo.AutoModAudit (UserID,  SiteID,  ReasonID,  TrustPoints,  ModStatus)
	SELECT	@userid, 
			SiteID, 
			7, -- SyncToPostMod
			TrustPoints, 
			ModStatus
	  FROM	@UpdatedModStatusTrustPoints_Tbl

RETURN @@ERROR