CREATE PROCEDURE updateroute @routeid int, @userid int, @siteid int, @iseditor int, @routexml xml
AS
BEGIN
	-- @routexml type expected format
	-- <route>
	--		<title>This is the route title</title>
	--		<description>This is the route description</description>
	--		<describingarticleid>6</describingarticleid>
	--		<locations>
	--			<location locationid="1" order="1">
	--				<lat>2.1</lat>
	--				<long>3.2</long>
	--				<title>This is the location title</title>
	--				<description>This is the location description</description>
	--				<zoomlevel>0</zoomlevel>
	--			</location>
	--			...
	--		</locations>
	-- <route>
	BEGIN TRY

	BEGIN TRANSACTION
		
		/*** UPDATE OVERSEEING ROUTE INFO ***/	
		UPDATE [Route]
		SET Title = temprt.Title, 
			Description = temprt.Description, 
			EntryID = temprt.EntryID
		FROM (
		SELECT  d1.c1.value('./ROUTETITLE[1]','nvarchar(256)') as Title,
				d1.c1.value('./ROUTEDESCRIPTION[1]','nvarchar(256)') as Description,
				d1.c1.value('./DESCRIBINGARTICLEID[1]','int') / 10 as EntryID
		FROM @routexml.nodes('/ROUTE') as d1(c1)) as temprt
		WHERE Routeid = @routeid and SiteID = @siteid
		
		/***NOW DEAL WITH THE LOCATIONS ***/
		
		/*** FIRST INSERT THE NEW LOCATIONS ***/
		DECLARE @newlocations table (RouteID int, 
										LocationID int, 
										SiteID int, 
										Latitude float, 
										Longitude float,
										ZoomLevel int, 
										UserID int, 
										Approved int, 
										Title varchar(255), 
										Description varchar(255),
										[Order] int)
		
		INSERT INTO Location (SiteID, Latitude, Longitude, ZoomLevel, UserID, Approved, DateCreated, Title, Description)
			OUTPUT @routeid, 
					INSERTED.LocationID, 
					INSERTED.SiteID, 
					INSERTED.Latitude, 
					INSERTED.Longitude,
					INSERTED.ZoomLevel, 
					INSERTED.UserID, 
					INSERTED.Approved, 
					INSERTED.Title, 
					INSERTED.Description, 
					0 INTO @newlocations 
		SELECT  @siteid as 'SiteID',
				d1.c1.value('./LAT[1]','float') as Latitude,
				d1.c1.value('./LONG[1]','float') as Longitude,
				d1.c1.value('./ZOOMLEVEL[1]','int') as ZoomLevel,
				@userid as 'UserID',
				case when @iseditor = 1 then 1 else 0 end as 'Approved',
				getdate() as 'DateCreated',
				d1.c1.value('./TITLE[1]','nvarchar(256)') as Title,
				d1.c1.value('./DESCRIPTION[1]','nvarchar(256)') as Description
		FROM @routexml.nodes('/ROUTE/LOCATIONS/LOCATION[@LOCATIONID="0"]') as d1(c1)

		UPDATE @newlocations
		SET [Order] = temprt.[Order]
		FROM (
			SELECT  @siteid as TmpSiteID,
				d1.c1.value('./LAT[1]','float') as TmpLatitude,
				d1.c1.value('./LONG[1]','float') as TmpLongitude,
				d1.c1.value('./ZOOMLEVEL[1]','int') as TmpZoomLevel,
				@userid as TmpUserID,
				case when @iseditor = 1 then 1 else 0 end as TmpApproved,
				d1.c1.value('./TITLE[1]','nvarchar(256)') as TmpTitle,
				d1.c1.value('./DESCRIPTION[1]','nvarchar(256)') as TmpDescription,
				d1.c1.value('./@LOCATIONID[1]','int') as TmpChangedLocationID,
				d1.c1.value('./@ORDER[1]','int') as [Order]
			FROM @routexml.nodes('/ROUTE/LOCATIONS/LOCATION[@LOCATIONID=''0'']') as d1(c1)) As temprt
			WHERE RouteID = @routeid 
				AND Latitude = temprt.TmpLatitude 
				AND Longitude = temprt.TmpLongitude
				AND SiteID = temprt.TmpSiteID 
				AND ZoomLevel = temprt.TmpZoomLevel 
				AND UserID = temprt.TmpUserID 
				AND Approved = temprt.TmpApproved 
				AND Title = temprt.TmpTitle 
				AND Description = temprt.TmpDescription 

		INSERT INTO RouteLocation (RouteID, LocationID, [Order])
		SELECT @RouteID, LocationID, [Order] FROM @newlocations
		
		/*** AND NOW THE UPDATING OF EXISTING LOCATIONS ***/
		declare @existinglocations table (LocationID int, [Order] int)

		UPDATE Location 
		SET SiteID = temprt.TmpSiteID, 
			Latitude = temprt.TmpLatitude, 
			Longitude = temprt.TmpLongitude, 
			ZoomLevel = temprt.TmpZoomLevel, 
			UserID = temprt.TmpUserID, 
			Approved = temprt.TmpApproved, 
			Title = temprt.TmpTitle, 
			Description = temprt.TmpDescription
		OUTPUT INSERTED.LocationID, temprt.[Order] INTO @existinglocations 
		FROM (
			SELECT  @siteid as TmpSiteID,
				d1.c1.value('./LAT[1]','float') as TmpLatitude,
				d1.c1.value('./LONG[1]','float') as TmpLongitude,
				d1.c1.value('./ZOOMLEVEL[1]','int') as TmpZoomLevel,
				@userid as TmpUserID,
				case when @iseditor = 1 then 1 else 0 end as TmpApproved,
				d1.c1.value('./TITLE[1]','nvarchar(256)') as TmpTitle,
				d1.c1.value('./DESCRIPTION[1]','nvarchar(256)') as TmpDescription,
				d1.c1.value('./@LOCATIONID[1]','int') as TmpLocationID,
				d1.c1.value('./@ORDER[1]','int') as [Order]
			FROM @routexml.nodes('/ROUTE/LOCATIONS/LOCATION[@LOCATIONID!=''0'']') as d1(c1)) as temprt
		WHERE LocationID = temprt.TmpLocationID

		UPDATE RouteLocation 
		SET [Order] = temprl.[Order]
		FROM
			(SELECT LocationID AS tmpLocationID, [Order] FROM @existinglocations) AS temprl
		WHERE RouteID = @RouteID AND LocationID = temprl.tmpLocationID
		
		DELETE FROM RouteLocation
		WHERE RouteID = @RouteID AND LocationID NOT IN (SELECT LocationID FROM @newlocations UNION ALL SELECT LocationID FROM @existinglocations)

		COMMIT TRANSACTION
		
		EXEC getroute @routeid, @siteid
		
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

