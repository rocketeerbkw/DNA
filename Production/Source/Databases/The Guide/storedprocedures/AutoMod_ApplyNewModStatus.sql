CREATE PROCEDURE automod_applynewmodstatus @userid INT, @siteid INT, @newmodstatus UserModStatus
AS
	/*
		Function: Applies user's new mod status to a site then syncs up other sites as appropriate. 

		Params:
			@userid - user. 
			@siteid - site.
			@modstatus - UserModStatus

		Results Set: 

		Returns: @@ERROR
	*/

	/*
	IF (@modstatus = 4) -- Restricted (aka banned)
	BEGIN
		-- TODO: What should we do here?
	END
	*/
	
	IF (@newmodstatus = 1) -- Premoderated
	BEGIN
		DECLARE @IntoPreModCount_Tbl TABLE (SiteID INT, IntoPreModCount TINYINT, TrustPoints SMALLINT, ModStatus UserModStatus); 

		UPDATE dbo.Preferences
		   SET IntoPreModCount = IntoPreModCount + 1
		OUTPUT INSERTED.SiteID, INSERTED.IntoPreModCount, INSERTED.TrustPoints, INSERTED.ModStatus
		  INTO @IntoPreModCount_Tbl
		 WHERE UserID = @userid
		   AND SiteID = @siteid
		   AND ModStatus <> 1; -- Premoderated

		IF (@@ROWCOUNT > 0)
		BEGIN
			DECLARE @TrustPointsAfterIntoPreModCountIncrement SMALLINT
			DECLARE @ModStatusAfterIntoPreModCountIncrement UserModStatus

			SELECT @TrustPointsAfterIntoPreModCountIncrement	= TrustPoints, 
				   @ModStatusAfterIntoPreModCountIncrement	= ModStatus
			  FROM @IntoPreModCount_Tbl

			EXEC dbo.automodaudit_addrecord @userid			= @userid, 
											@siteid			= @siteid, 
											@reasonid		= 8, -- IncIntoPremod 
											@trustpoints	= @TrustPointsAfterIntoPreModCountIncrement, 
											@modstatus		= @ModStatusAfterIntoPreModCountIncrement

			IF EXISTS (SELECT 1 
						 FROM @IntoPreModCount_Tbl ipmc
						INNER JOIN dbo.Sites s ON ipmc.SiteID = s.SiteID
						WHERE ipmc.IntoPreModCount >= MaxIntoPreModCount)
			BEGIN
				SELECT @newmodstatus = 4; -- Restricted (aka banned) because IntoPreModCount has been passed on a site.

				EXEC dbo.automodaudit_addrecord @userid			= @userid, 
												@siteid			= @siteid, 
												@reasonid		= 9, -- ReachedMaxIntoPremodCount
												@trustpoints	= @TrustPointsAfterIntoPreModCountIncrement, 
												@modstatus		= @ModStatusAfterIntoPreModCountIncrement
			END
		END
	END

	DECLARE @CurrentModStatus UserModStatus; 

	SELECT @CurrentModStatus	= ModStatus
	  FROM dbo.Preferences
	 WHERE UserID = @userid
	   AND SiteID = @siteid

	IF (@CurrentModStatus <> @newmodstatus)
	BEGIN
		DECLARE @NewModStatus_Tbl TABLE (SiteID INT, TrustPoints SMALLINT, ModStatus UserModStatus); 

		UPDATE dbo.Preferences
		   SET ModStatus = @newmodstatus
		OUTPUT INSERTED.SiteID, INSERTED.TrustPoints, INSERTED.ModStatus
		  INTO @NewModStatus_Tbl 
		 WHERE UserID = @userid
		   AND SiteID = @siteid; 

		DECLARE @TrustPointsAfterModStatusUpdate SMALLINT
		DECLARE @ModStatusAfterModStatusUpdate UserModStatus

		SELECT @TrustPointsAfterModStatusUpdate	= TrustPoints, 
			   @ModStatusAfterModStatusUpdate	= ModStatus
		  FROM @NewModStatus_Tbl

		EXEC dbo.automodaudit_addrecord @userid			= @userid, 
										@siteid			= @siteid, 
										@reasonid		= 4, -- ModStatusChange
										@trustpoints	= @TrustPointsAfterModStatusUpdate, 
										@modstatus		= @ModStatusAfterModStatusUpdate

		EXEC dbo.automod_syncmodstatusacrosssites @userid		= @userid,
												  @siteid		= @siteid,
												  @newmodstatus = @newmodstatus
												  
	END

RETURN @@ERROR