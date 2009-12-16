create procedure setguideentrylocation @entryid int, @userid int, @locationxml xml
as
begin
	
	-- @locationxml type expected format
	--	<location locationid="0">
	--		<lat>2.1</lat>
	--		<long>3.2</long>
	--		<title>This is the title</title>
	--		<description>This is the description</description>
	--		<zoomlevel>0</zoomlevel>
	--	</location>
	BEGIN TRY
	BEGIN TRANSACTION
		
	declare @siteid int
	declare @editor int	
	declare @entryidreal int	
	
	SELECT	@SiteID = ge.SiteID, 
			@Editor = Editor,
			@entryidreal = EntryID
		  FROM	dbo.GuideEntries ge
		 WHERE	ge.h2g2id = @entryid

		/*** FIRST INSERT THE NEW LOCATIONS ***/
		DECLARE @newlocations table (	LocationID int )
		
		INSERT INTO Location (SiteID, Latitude, Longitude, ZoomLevel, UserID, Approved, DateCreated, Title, Description)
			OUTPUT INSERTED.LocationID INTO @newlocations 
		SELECT  @siteid as 'SiteID',
				d1.c1.value('./lat[1]','float') as Latitude,
				d1.c1.value('./long[1]','float') as Longitude,
				d1.c1.value('./zoomlevel[1]','int') as ZoomLevel,
				@userid as 'UserID',
				case when @editor = @userid then 1 else 0 end as 'Approved',
				getdate() as 'DateCreated',
				d1.c1.value('./title[1]','nvarchar(256)') as title,
				d1.c1.value('./description[1]','nvarchar(256)') as description
		FROM @locationxml.nodes('/location[@locationid="0"]') as d1(c1)

		INSERT INTO ArticleLocation (EntryID, LocationID)
		SELECT @entryidreal, LocationID FROM @newlocations
		
		/*** AND NOW THE UPDATING OF EXISTING LOCATIONS ***/
		declare @existinglocations table ( LocationID int )

		UPDATE Location 
		SET SiteID = temprt.SiteID, 
			Latitude = temprt.Latitude, 
			Longitude = temprt.Longitude, 
			ZoomLevel = temprt.ZoomLevel, 
			UserID = temprt.UserID, 
			Approved = temprt.Approved, 
			Title = temprt.Title, 
			Description = temprt.Description
		OUTPUT INSERTED.LocationID INTO @existinglocations 
		FROM (
		SELECT  @siteid as 'SiteID',
				d1.c1.value('./lat[1]','float') as Latitude,
				d1.c1.value('./long[1]','float') as Longitude,
				d1.c1.value('./zoomlevel[1]','int') as ZoomLevel,
				@userid as 'UserID',
				case when @editor = @userid then 1 else 0 end as 'Approved',
				getdate() as 'DateCreated',
				d1.c1.value('./title[1]','nvarchar(256)') as Title,
				d1.c1.value('./description[1]','nvarchar(256)') as Description,
				d1.c1.value('./@locationid[1]','int') as TmpLocationID
			FROM @locationxml.nodes('/location[@locationid!="0"]') as d1(c1)) as temprt
		WHERE LocationID = temprt.TmpLocationID
		
		DELETE FROM ArticleLocation
		WHERE EntryID = @entryidreal AND LocationID NOT IN (SELECT LocationID FROM @newlocations UNION ALL SELECT LocationID FROM @existinglocations)

		COMMIT TRANSACTION

		SELECT 'Success' = 1
		RETURN 0
		-- If we reach here, success!
	END TRY
	BEGIN CATCH
	 -- Whoops, there was an error
	  IF @@TRANCOUNT > 0
		 ROLLBACK TRANSACTION

	  -- Raise an error with the details of the exception
	  DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	  SELECT @ErrMsg = ERROR_MESSAGE(),
			 @ErrSeverity = ERROR_SEVERITY()

	  RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
END
