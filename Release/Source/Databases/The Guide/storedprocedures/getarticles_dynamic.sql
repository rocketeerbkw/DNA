CREATE PROCEDURE getarticles_dynamic @siteid int, 
@firstindex int, 
@lastindex int, 
@keyphraselist VARCHAR(1000) = null, 
@namespacelist VARCHAR(1000) = null, 
@startdate datetime = null, 
@enddate datetime = null, 
@touchingdaterange bit = 0, 
@sortbycaption bit = null, 
@sortbyrating bit = null, 
@sortbystartdate bit = null, 
@sortbybookmarkcount bit = null, 
@descendingorder bit = 1, 
@assettype int = null, 
@articlestatus int = null, 
@articletype int = null, 
@sortbyarticlezeitgeist bit = null, 
@sortbypostcount bit = null, 
@freetextsearchcondition varchar(1000) = null, 
@latitude float = 0.0, 
@longitude float = 0.0, 
@range float = 0.0, 
@sortbyrange bit = null,
@sortbylastupdated bit = null,
@sortbylastposted bit = null,
@sortbyenddate bit = null
AS

	/*
	 *	The retrieval of articles is broked down into 3 stages: 
	 *		1. Select candidate articles (informing caller if results are to be in CTE or temporary table)
	 *		2. Sorting (according to sort params) & paging articles (according to @firstindex and @lastindex)
	 *		3. Returning final results sets
	 *
	 *	The following procedures build up parameterised dynamic SQL following the 3 stages outlined. 
	 *	The final result sets are then returned to the caller. 
	 */

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @sortbydatecreated bit
	SET @sortbydatecreated = 0

	-- Set correct sort order
	IF @sortbycaption = 1
	BEGIN
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
	END
	ELSE IF @sortbyrating = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
	END
	ELSE IF @sortbystartdate = 1 
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
		SET @sortbyenddate = 0
	END
	ELSE IF @sortbyarticlezeitgeist = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
	END
	ELSE IF @sortbypostcount = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
	END
	ELSE IF @sortbyrange = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
	END
	ELSE IF @sortbybookmarkcount = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
	END
	ELSE IF @sortbylastupdated = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 1
	END
	ELSE IF @sortbylastposted = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyenddate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastupdated = 0
	END
	ELSE IF @sortbyenddate = 1
	BEGIN
		SET @sortbycaption = 0
		SET @sortbyrating = 0
		SET @sortbystartdate = 0
		SET @sortbyarticlezeitgeist = 0
		SET @sortbypostcount = 0
		SET @sortbyrange = 0
		SET @sortbybookmarkcount = 0
		SET @sortbylastposted = 0
		SET @sortbylastupdated = 0
	END
	ELSE
	BEGIN
		SET @sortbydatecreated = 1
	END

	DECLARE @Error int
	DECLARE @EntriesInTempTable bit
	DECLARE @sql nvarchar(max)

	/* replace any single quotes with double single quotes, otherwise they will break the query */
	-- set @freetextsearchcondition = replace(@freetextsearchcondition, '''', '''''')

	DECLARE @keyphrasecount INT
	SELECT @keyphrasecount = count(*)
	  FROM dbo.udf_splitvarchar(@keyphraselist)

	IF (@namespacelist IS NULL)
	BEGIN
		SELECT @namespacelist = ''

		DECLARE @i INT
		SELECT @i = 0

		WHILE (@i < @keyphrasecount)
		BEGIN
			SELECT @namespacelist = @namespacelist + '|'
			SELECT @i = @i + 1
		END
	END

	SELECT @sql = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;'

	IF (@sortbyrange = 1)
	BEGIN
		SELECT @sql = @sql + N'DECLARE @Sorted TABLE(EntryID INT, rn INT, Total INT, LocationID INT);'
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N'DECLARE @Sorted TABLE(EntryID INT, rn INT, Total INT);'
	END

    DECLARE @606SiteId int
	SELECT @606SiteId=siteid FROM Sites WHERE urlname='606'

	-- 606 now uses the C# code which defaults to @descendingorder=0.  However, the 606 skin relies 
	-- on the C++ default of @descendingorder=1.  The initial bodge was to ignore @descendingorder
	-- in the IF statement, but this broken memoryshare (and upset all 5 users)
	-- The fix is to bodge up @descendingorder only in the "606 Indexed View" case
	IF @siteid=@606SiteId AND
		(@sortbydatecreated = 1) AND
		@keyphraselist IS NOT NULL AND @assettype IS NULL AND @articlestatus IS NULL AND 
		@articletype IS NULL AND @freetextsearchcondition IS NULL AND
		@startdate IS NULL AND @enddate IS NULL AND
		@latitude = 0.0 AND @longitude = 0.0 AND @range = 0.0
	BEGIN
		SET @descendingorder=1
	END
	
	-- Restored "@descendingorder=1" to the strict criteria needed to use the indexed view path
	IF (@sortbydatecreated = 1) AND
		@keyphraselist IS NOT NULL AND @assettype IS NULL AND @articlestatus IS NULL AND 
		@articletype IS NULL AND @freetextsearchcondition IS NULL AND
		@startdate IS NULL AND @enddate IS NULL AND @descendingorder=1 AND
		@latitude = 0.0 AND @longitude = 0.0 AND @range = 0.0
	BEGIN
		EXEC @Error = dbo.getarticles_generatearticlessortedwithindexedviews @keyphraselist		= @keyphraselist OUTPUT, 
																	  @namespacelist		= @namespacelist, 
																	  @sortbyrating		    = @sortbyrating,
																	  @siteid				= @siteid, 
																	  @sql					= @sql output
		SET @EntriesInTempTable=0
	END
	ELSE
	BEGIN
		/* 1. Select candidate articles */ 
		EXEC @Error = dbo.getarticles_generatecandidatearticlesselect @keyphraselist		= @keyphraselist, 
																	  @namespacelist		= @namespacelist, 
																	  @startdate			= @startdate, 
																	  @touchingdaterange	= @touchingdaterange, 
																	  @assettype			= @assettype, 
																	  @articlestatus		= @articlestatus, 
																	  @articletype			= @articletype,
																	  @freetextsearchcondition	= @freetextsearchcondition, 
																	  @siteid				= @siteid, 
																	  @latitude				= @latitude,
																	  @longitude			= @longitude,
																	  @range				= @range,
																	  @sql					= @sql output, 
																	  @entriesintemptable	= @EntriesInTempTable output
		--SELECT @sql --Used to check the output for debugging

		/* 2. Sorting & paging articles */
		EXEC @Error = dbo.getarticles_generatesortandpageselect @sortbylastupdated		= @sortbylastupdated,
		                                                        @sortbydatecreated      = @sortbydatecreated,
																@sortbycaption			= @sortbycaption, 
																@sortbyrating			= @sortbyrating, 
																@sortbystartdate		= @sortbystartdate,
																@sortbyenddate			= @sortbyenddate,
																@sortbyarticlezeitgeist	= @sortbyarticlezeitgeist,
																@sortbypostcount		= @sortbypostcount, 
																@sortbybookmarkcount	= @sortbybookmarkcount, 
																@sortbylastposted       = @sortbylastposted,
																@descendingorder		= @descendingorder,
																@entriesintemptable		= @EntriesInTempTable,
																@sortbyrange			= @sortbyrange,
																@latitude				= @latitude,
																@longitude				= @longitude,
																@sql					= @sql output
	END
    --SELECT @sql --Used to check the output for debugging

	IF (@sortbyrange = 1)
	BEGIN
		SELECT @sql = @sql + N'INSERT INTO @Sorted SELECT EntryID, rn, Total, LocationID FROM Sorted OPTION(KEEPFIXED PLAN); '
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N'INSERT INTO @Sorted SELECT EntryID, rn, Total FROM Sorted OPTION(KEEPFIXED PLAN); '
	END

	/* 3. Returning final results sets */ 
	EXEC @Error = dbo.getarticles_finalselect @siteid					= @siteid, 
											  @includezeitgeistscore	= @sortbyarticlezeitgeist,
											  @sortbyrangeflag			= @sortbyrange,
											  @latitude					= @latitude,
											  @longitude				= @longitude,
											  @range					= @range,
											  @sql = @sql output

	IF (@EntriesInTempTable = 1)
	BEGIN
		SELECT @sql = @sql + N'DROP TABLE #Entries; '
	END
    --SELECT @sql --Used to check the output for debugging
    --PRINT @sql --Used to check the output for debugging

	EXECUTE sp_executesql @sql, 
							N'@siteid INT, 
							@firstindex int, 
							@lastindex int, 
							@keyphraselist VARCHAR(8000) = null, 
							@namespacelist VARCHAR(8000) = null, 
							@startdate datetime = null, 
							@enddate datetime = null, 
							@articlestatus int = null, 
							@articletype int = null, 
							@freetextsearchcondition varchar(1000) = null, 
							@latitude float = 0.0, 
							@longitude float = 0.0, 
							@range float = 0.0', 
							@siteid = @siteid, 
							@firstindex = @firstindex, 
							@lastindex = @lastindex, 
							@keyphraselist = @keyphraselist, 
							@namespacelist = @namespacelist, 
							@startdate = @startdate, 
							@enddate = @enddate, 
							@articlestatus = @articlestatus, 
							@articletype = @articletype, 
							@freetextsearchcondition = @freetextsearchcondition,
						    @latitude				= @latitude,
						    @longitude			    = @longitude,
						    @range				    = @range
							

RETURN @Error