CREATE PROCEDURE automod_syncpremodacrosssites @userid INT, @siteid INT
AS
	/*
		Function: Controls sync of user's mod status when changing to pre mod. 

		Params:
			@userid - User to be synced. 
			@siteid - Site to be ignored (i.e. site that already has updated mod status and trust points).

		Results Set: 

		Returns: @@ERROR
	*/

	DECLARE @UpdatedModStatusTrustPoints_Tbl TABLE (SiteID INT, ModStatus UserModStatus, TrustPoints SMALLINT); 

	UPDATE dbo.Preferences
	   SET ModStatus = 1, -- Premoderated
		   TrustPoints = PostmodThresholdValue - 1
	OUTPUT INSERTED.SiteID, INSERTED.ModStatus, INSERTED.TrustPoints
	  INTO @UpdatedModStatusTrustPoints_Tbl
	  FROM dbo.Preferences p
	 INNER JOIN dbo.Sites s ON p.SiteID = s.SiteID
	 WHERE p.UserID = @userid
	   AND p.SiteID <> @siteid
	   AND p.TrustPoints >= s.PostmodThresholdValue -- i.e. not users who's trust points already have them in banned or premod zones.
	   AND p.ModStatus <> 4 -- Restricted (aka banned)

	INSERT	INTO dbo.AutoModAudit (UserID,  SiteID,  ReasonID,  TrustPoints,  ModStatus)
	SELECT	@userid, 
			SiteID, 
			11, -- SyncToPremod
			TrustPoints, 
			ModStatus
	  FROM	@UpdatedModStatusTrustPoints_Tbl

RETURN @@ERROR