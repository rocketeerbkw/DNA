CREATE PROCEDURE getarticles_generatesortandpageselect 
@sortbylastupdated bit,
@sortbydatecreated bit,
@sortbycaption bit, 
@sortbyrating bit, 
@sortbystartdate bit, 
@sortbyenddate bit, 
@descendingorder bit, 
@entriesintemptable bit, 
@sortbyarticlezeitgeist bit, 
@sortbypostcount bit, 
@sortbybookmarkcount bit, 
@sortbyrange bit, 
@sortbylastposted bit,
@latitude float = 0.0, 
@longitude float = 0.0, 
@sql nvarchar(max) output 
AS

	/* 2. Returns SQL for sorting and paging candidate articles in call to GetArticles */ 
	/* N.B. Candidate entries from step 1 (see calling SP) can be stored in either a CTE (to reduce the number of writes to the db) or a temporary table (to reduce the cost of the count). */

	-- Set correct candidate entry table expression
	DECLARE @CandidateEntryTableName nvarchar(100)
	IF (@entriesintemptable = 1)
	BEGIN
		SELECT @CandidateEntryTableName = '#Entries'
		SELECT @sql = @sql + N'WITH '
	END
	ELSE
	BEGIN
		SELECT @CandidateEntryTableName = 'Entries'
	END

	SELECT @sql = @sql + N'Sorted AS ('

	IF (@sortbyrange = 1)
	BEGIN 
		SELECT @sql = @sql + N'SELECT EntryID, rn, (SELECT count(*) FROM ' + @CandidateEntryTableName + ') AS Total, LocationID FROM ('
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N'SELECT EntryID, rn, (SELECT count(*) FROM ' + @CandidateEntryTableName + ') AS Total FROM ('
	END

	IF @sortbylastupdated = 1
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY g.LastUpdated DESC) rn FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g ON e.EntryID = g.EntryID AND g.SiteID = @siteid'
	END
	
	IF @sortbydatecreated = 1
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY g.DateCreated DESC) rn FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g ON e.EntryID = g.EntryID AND g.SiteID = @siteid'
	END

	IF @sortbycaption = 1
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY g.subject ASC) rn FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g ON e.EntryID = g.EntryID AND g.SiteID = @siteid'
	END

	IF @sortbyrating=1
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY pv.AverageRating DESC, e.EntryID DESC) rn'
		SELECT @sql = @sql + ' FROM ' + @CandidateEntryTableName + ' e INNER HASH JOIN dbo.VVisibleGuideEntries g on e.EntryID = g.EntryID AND g.SiteID = @siteid LEFT HASH JOIN dbo.PageVotes pv ON e.EntryID = pv.itemid/10 and pv.itemtype=1 ' -- Removed join to Votes (unnecessary given dna has only implemted one join type - should be reviewed if other vote types are used) for performance reasons. 
	END

/*	IF @sortbyrating=1
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY CASE WHEN pv.voteid=v.voteid THEN pv.AverageRating ELSE NULL END DESC, e.EntryID DESC) rn'
		SELECT @sql = @sql + ' FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g on e.EntryID = g.EntryID AND g.SiteID = @siteid LEFT JOIN dbo.PageVotes pv ON e.EntryID = pv.itemid/10 and pv.itemtype=1 LEFT JOIN dbo.Votes v ON pv.voteid = v.voteid AND v.type = 3'
	END
*/
	IF @sortbyarticlezeitgeist=1
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY csa.Score DESC, e.EntryID DESC) rn'
		SELECT @sql = @sql + ' FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g on e.EntryID = g.EntryID AND g.SiteID = @siteid LEFT JOIN dbo.ContentSignifArticle csa ON g.EntryID = csa.EntryID'
	END

	IF (@sortbystartdate = 1)
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY adr.StartDate '
		+ CASE WHEN @descendingorder = 1 THEN N'DESC' ELSE N'ASC' END 
		+ N') rn FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g on e.EntryID = g.EntryID AND g.SiteID = @siteid LEFT JOIN dbo.ArticleDateRange adr ON e.EntryID  = adr.EntryID'
	END
	
	IF (@sortbyenddate = 1)
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY adr.EndDate '
		+ CASE WHEN @descendingorder = 1 THEN N'DESC' ELSE N'ASC' END 
		+ N') rn FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g on e.EntryID = g.EntryID AND g.SiteID = @siteid LEFT JOIN dbo.ArticleDateRange adr ON e.EntryID  = adr.EntryID'
	END
	
	IF (@sortbylastposted = 1)
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY gefplp.HasPosts DESC, gefplp.LastPosted DESC, gefplp.EntryID DESC) rn'
		SELECT @sql = @sql + ' FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VGuideEntryForumLastPosted gefplp WITH (NOEXPAND) ON e.EntryID = gefplp.EntryID'
	END

	IF (@sortbypostcount = 1)
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY gefpc.ForumPostCount DESC, gefpc.EntryID DESC) rn'
		SELECT @sql = @sql + ' FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VGuideEntryForumPostCount gefpc WITH (NOEXPAND) ON e.EntryID = gefpc.EntryID'
	END

	IF (@sortbyrange = 1)
	BEGIN
		--SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY dbo.udf_calcdistance(@latitude, @longitude, al.latitude, al.longitude) ASC, e.EntryID DESC) rn, AL.ID'
		--SELECT @sql = @sql + ' FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g on e.EntryID = g.EntryID AND g.SiteID = @siteid INNER JOIN dbo.ArticleLocation AL ON g.EntryID = AL.EntryID '
		--SELECT @sql = @sql + ' WHERE dbo.udf_calcdistance(@latitude, @longitude, al.latitude, al.longitude) < @range '

		--SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY dbo.udf_calcdistance(@latitude, @longitude, Latitude, Longitude) ASC, e.EntryID DESC) rn, LocationID'
		--SELECT @sql = @sql + ' FROM  ' + @CandidateEntryTableName + ' e INNER JOIN '		
		--SELECT @sql = @sql + ' (SELECT DISTINCT EntryID, LocationID, Latitude, Longitude FROM '		
		--SELECT @sql = @sql + ' (SELECT vg.EntryID, AL.ID AS LocationID, Latitude, Longitude '
		--SELECT @sql = @sql + ' FROM dbo.VVisibleGuideEntries vg '
		--SELECT @sql = @sql + ' INNER JOIN dbo.ArticleLocation AL ON vg.EntryID = AL.EntryID AND vg.SiteID = @siteid '
		--SELECT @sql = @sql + ' WHERE dbo.udf_calcdistance(@latitude, @longitude, AL.latitude, AL.longitude) < @range)  AS AA ) AS Temp ON e.EntryID = Temp.EntryID' 


		SELECT @sql = @sql + '	SELECT DISTINCT e.EntryID,  rn, LocationID '
		SELECT @sql = @sql + '	FROM ' + @CandidateEntryTableName + ' e INNER JOIN '  
		SELECT @sql = @sql + '	( '
		SELECT @sql = @sql + '		SELECT EntryID, LocationID, Latitude, Longitude, ROW_NUMBER() OVER(ORDER BY dbo.udf_calcdistance(@latitude, @longitude, Latitude, Longitude) ASC, EntryID DESC) rn '
		SELECT @sql = @sql + '		FROM '  
		SELECT @sql = @sql + '		( '
		SELECT @sql = @sql + '				SELECT DISTINCT vg.EntryID, AL.LocationID, L.Latitude, L.Longitude '  
		SELECT @sql = @sql + '				FROM dbo.VVisibleGuideEntries vg '  
		SELECT @sql = @sql + '				INNER JOIN dbo.ArticleLocation AL ON vg.EntryID = AL.EntryID AND vg.SiteID = @siteid '  
		SELECT @sql = @sql + '				INNER JOIN dbo.Location L ON L.LocationID = AL.LocationID '  
		SELECT @sql = @sql + '				WHERE dbo.udf_calcdistance(@latitude, @longitude, L.latitude, L.longitude) < @range '
		SELECT @sql = @sql + '		) '  
		SELECT @sql = @sql + '		AS AA ' 
		SELECT @sql = @sql + '	) ' 
		SELECT @sql = @sql + '	AS Temp ON e.EntryID = Temp.EntryID ' 
	END

	IF (@sortbybookmarkcount = 1)
	BEGIN
		SELECT @sql = @sql + 'SELECT e.EntryID, ROW_NUMBER() OVER(ORDER BY lnk.[Count] DESC, e.EntryID DESC) rn '
		SELECT @sql = @sql + ' FROM ' + @CandidateEntryTableName + ' e INNER JOIN dbo.VVisibleGuideEntries g on e.EntryID = g.EntryID AND g.SiteID = @siteid LEFT JOIN dbo.VLinkCounts lnk on g.h2g2ID = lnk.DestinationID ' 
	END
	
	SELECT @sql = @sql + N' ) AS S WHERE (rn BETWEEN @firstindex AND @lastindex) )'
	
RETURN @@ERROR 
