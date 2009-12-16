create procedure createroute @userid int, @siteid int, @iseditor int, @routexml xml
as
begin
	
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
	-- </route>
BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	DECLARE @RouteID INT
		
	INSERT INTO Route (SiteID, UserID, Approved, DateCreated, Title, Description, EntryID)
	SELECT  @siteid as 'SiteID',
			@userid as 'UserID',
			case when @iseditor = 1 then 1 else 0 end as 'Approved',
			getdate() as 'DateCreated',
			d1.c1.value('./ROUTETITLE[1]','nvarchar(256)') as Title,
			d1.c1.value('./ROUTEDESCRIPTION[1]','nvarchar(256)') as Description,
			d1.c1.value('./DESCRIBINGARTICLEID[1]','int') / 10 as EntryID
	FROM @routexml.nodes('/ROUTE') as d1(c1)
	SELECT @RouteID = SCOPE_IDENTITY()
			
	DECLARE @locations TABLE (LocationID int)
	
	INSERT INTO Location (SiteID, Latitude, Longitude, ZoomLevel, UserID, Approved, DateCreated, Title, Description)
	OUTPUT INSERTED.LocationID INTO @locations 
	SELECT  @siteid as 'SiteID',
			d1.c1.value('./LAT[1]','float') as Latitude,
			d1.c1.value('./LONG[1]','float') as Longitude,
			d1.c1.value('./ZOOMLEVEL[1]','int') as ZoomLevel,
			@userid as 'UserID',
			case when @iseditor = 1 then 1 else 0 end as 'Approved',
			getdate() as 'DateCreated',
			d1.c1.value('./TITLE[1]','nvarchar(256)') as title,
			d1.c1.value('./DESCRIPTION[1]','nvarchar(256)') as description
	FROM @routexml.nodes('/ROUTE/LOCATIONS/LOCATION') as d1(c1)

	INSERT INTO RouteLocation (RouteID, LocationID, [Order])
	SELECT @RouteID, LocationID, ROW_NUMBER() OVER (ORDER BY LocationID) FROM @locations
	
	COMMIT TRANSACTION

	EXEC getroute @RouteID, @siteid

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