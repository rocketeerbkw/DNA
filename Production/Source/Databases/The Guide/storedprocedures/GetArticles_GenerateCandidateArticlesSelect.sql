CREATE PROCEDURE getarticles_generatecandidatearticlesselect 
@keyphraselist VARCHAR(1000), 
@namespacelist VARCHAR(1000), 
@startdate datetime, 
@touchingdaterange bit, 
@assettype int, 
@articlestatus int, 
@articletype int, 
@freetextsearchcondition varchar(1000), 
@siteid int, 
@latitude float = 0.0, 
@longitude float = 0.0, 
@range float = 0.0, 
@sortbyrange bit = null,
@sql nvarchar(max) output, 
@entriesintemptable bit output
AS

	/* 1. Returns SQL for selecting candidate articles in call to GetArticles */ 
	/* Returns to caller @entriesintemptable bit that states if candidates are in a CTE or temporary table (decision based if keyphrases are
	passed in.  */

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF (@keyphraselist IS NOT NULL)
	BEGIN
		-- Phrase count
		SELECT @sql = @sql + N'DECLARE @count INT; SELECT @count = count(*) FROM dbo.udf_splitvarchar(@keyphraselist); '		
		-- Phrase / Namespace pairs
		SELECT @sql = @sql + N'SELECT * INTO #KeyPhraseNamespacePairs FROM dbo.udf_getkeyphrasenamespacepairs (@namespacelist, @keyphraselist) kpns; '
	END

    DECLARE @606SiteId int
	SELECT @606SiteId=siteid FROM Sites WHERE urlname='606'
	
	-- Resrict results to a month for 606.
	IF @siteid=@606SiteId
	BEGIN
		SELECT @sql = @sql + N'
			declare @baseentry int
			select top 1 @baseentry = entryid from guideentries g
			where g.datecreated <= dateadd(mm,-1,getdate()) and siteid=@siteid 
			order by entryid desc; 
			SET @baseentry=ISNULL(@baseentry,1);'
	END

	-- Candidate articles
	SELECT @sql = @sql + N'WITH Entries AS('

	IF (@keyphraselist IS NULL)
	BEGIN
		IF (@assettype IS NULL)
		BEGIN
			SELECT @sql = @sql + N'SELECT va.EntryID FROM dbo.VVisibleGuideEntries va '
		END
		IF (@assettype = 0)
		BEGIN
			SELECT @sql = @sql + N'SELECT va.EntryID FROM dbo.VArticleAssets va '
		END
		IF (@assettype = 1)
		BEGIN
			SELECT @sql = @sql + N'SELECT va.EntryID FROM dbo.VArticleImageAssets va '
		END
		IF (@assettype = 2)
		BEGIN
			SELECT @sql = @sql + N'SELECT va.EntryID FROM dbo.VArticleAudioAssets va '
		END
		IF (@assettype = 3)
		BEGIN
			SELECT @sql = @sql + N'SELECT va.EntryID FROM dbo.VArticleVideoAssets va '
		END
	END
	ELSE
	BEGIN
		-- Articles associated with keyphrase namespace pairs.
		SELECT @sql = @sql + N'SELECT DISTINCT akp.EntryID FROM ( '
		SELECT @sql = @sql + N'SELECT akp.EntryID, akp.SiteID '
		SELECT @sql = @sql + N'FROM #KeyPhraseNamespacePairs kpns '
		SELECT @sql = @sql + N'INNER JOIN dbo.KeyPhrases kp on kpns.Phrase = kp.phrase '
		SELECT @sql = @sql + N'INNER JOIN dbo.NameSpaces ns on kpns.Namespace = ns.Name '
		SELECT @sql = @sql + N'INNER JOIN dbo.PhraseNameSpaces pns ON kp.PhraseID = pns.PhraseID AND ns.NameSpaceID = pns.NameSpaceID '
		SELECT @sql = @sql + N'INNER JOIN dbo.ArticleKeyPhrases akp ON pns.PhraseNameSpaceID = akp.PhraseNameSpaceID '
		IF @siteid=@606SiteId
		BEGIN
			SELECT @sql = @sql + N'and akp.entryid > @baseentry '
		END
		SELECT @sql = @sql + N'UNION ALL '
		SELECT @sql = @sql + N'SELECT akp.EntryID, akp.SiteID '
		SELECT @sql = @sql + N'FROM #KeyPhraseNamespacePairs kpns '
		SELECT @sql = @sql + N'INNER JOIN dbo.KeyPhrases kp on kpns.Phrase = kp.phrase '
		SELECT @sql = @sql + N'INNER JOIN dbo.PhraseNameSpaces pns ON kp.PhraseID = pns.PhraseID AND pns.NameSpaceID IS NULL AND kpns.Namespace IS NULL '
		SELECT @sql = @sql + N'INNER JOIN dbo.ArticleKeyPhrases akp ON pns.PhraseNameSpaceID = akp.PhraseNameSpaceID '
		IF @siteid=@606SiteId
		BEGIN
			SELECT @sql = @sql + N'and akp.entryid > @baseentry '
		END
		SELECT @sql = @sql + N'UNION ALL '
		SELECT @sql = @sql + N'SELECT akp.EntryID, akp.SiteID '
		SELECT @sql = @sql + N'FROM #KeyPhraseNamespacePairs kpns '
		SELECT @sql = @sql + N'INNER JOIN dbo.KeyPhrases kp on kpns.Phrase = kp.phrase '
		SELECT @sql = @sql + N'INNER JOIN dbo.PhraseNameSpaces pns ON kp.PhraseID = pns.PhraseID '
		SELECT @sql = @sql + N'INNER JOIN dbo.ArticleKeyPhrases akp ON pns.PhraseNameSpaceID = akp.PhraseNameSpaceID '
		SELECT @sql = @sql + N'WHERE kpns.Namespace = ''_any'' '
		IF @siteid=@606SiteId
		BEGIN
			SELECT @sql = @sql + N'and akp.entryid > @baseentry '
		END
		SELECT @sql = @sql + N') akp '

		--IF (@assettype IS NULL) Don't want to join to GuideEntries so delay filtering on GuideEntry.Hidden attribute until step 2 (sort and page select). 
		--BEGIN
		--	SELECT @sql = @sql + N' INNER JOIN dbo.VVisibleGuideEntries e ON akp.EntryID = e.EntryID AND e.SiteID = @siteid'
		--END
		IF (@assettype = 0)
		BEGIN
			SELECT @sql = @sql + N' INNER JOIN dbo.VArticleAssets va ON akp.EntryID = va.EntryID AND va.SiteID = @siteid '
		END
		IF (@assettype = 1)
		BEGIN
			SELECT @sql = @sql + N' INNER JOIN dbo.VArticleImageAssets va ON akp.EntryID = va.EntryID AND va.SiteID = @siteid '
		END

		IF (@assettype = 2)
		BEGIN
			SELECT @sql = @sql + N' INNER JOIN dbo.VArticleAudioAssets va ON akp.EntryID = va.EntryID AND va.SiteID = @siteid '
		END

		IF (@assettype = 3)
		BEGIN
			SELECT @sql = @sql + N' INNER JOIN dbo.VArticleVideoAssets va ON akp.EntryID = va.EntryID AND va.SiteID = @siteid '
		END
	END	

	IF (@startdate IS NOT NULL)
	BEGIN
		SELECT @sql = @sql + N' INNER JOIN dbo.ArticleDateRange adr ON '

		IF ((@keyphraselist IS NOT NULL) AND (@assettype IS NULL))
		BEGIN 
			-- We haven't joined to VVisibleGuideEntries for performance reasons so join on akp.EntryID. 
			SELECT @sql = @sql + N'akp.EntryID = adr.EntryID '
		END
		ELSE
		BEGIN
			SELECT @sql = @sql + N'va.EntryID = adr.EntryID '
		END

		IF (@touchingdaterange = 1)
		BEGIN
			SELECT @sql = @sql + N'AND NOT(adr.StartDate >= @enddate) AND NOT(adr.EndDate <= @startdate) '
		END
		ELSE
		BEGIN
			SELECT @sql = @sql + N'AND adr.StartDate >= @startdate AND adr.EndDate <= @enddate '
		END	
	END

	IF (@freetextsearchcondition IS NOT NULL)
	BEGIN
		DECLARE @fulltextindex VARCHAR(255);
		SELECT @fulltextindex = dbo.udf_getguideentryfulltextcatalogname(@siteid);


		SELECT @sql = @sql + N' INNER JOIN CONTAINSTABLE('+@fulltextindex+',(subject,text),@freetextsearchcondition,2000) KeyTable ON '

		IF ((@keyphraselist IS NOT NULL) AND (@assettype IS NULL))
		BEGIN 
			-- We haven't joined to VVisibleGuideEntries for performance reasons so join on akp.EntryID. 
			SELECT @sql = @sql + N'akp.EntryID = KeyTable.[key] '
		END
		ELSE
		BEGIN
			SELECT @sql = @sql + N'va.EntryID = KeyTable.[key] '
		END
	END
	
	IF (@latitude <> 0.0 AND @longitude <> 0.0 AND @range <> 0.0)
	BEGIN 
		SELECT @sql = @sql + N' INNER JOIN dbo.ArticleLocation al ON '
		IF ((@keyphraselist IS NOT NULL) AND (@assettype IS NULL))
		BEGIN 
			-- We haven't joined to VVisibleGuideEntries for performance reasons so join on akp.EntryID. 
			SELECT @sql = @sql + N' akp.EntryID = al.EntryID INNER JOIN dbo.Location l ON l.LocationID = al.LocationID AND dbo.udf_calcdistance(@latitude, @longitude, l.latitude, l.longitude) < @range '
		END
		ELSE
		BEGIN
			SELECT @sql = @sql + N' va.EntryID = al.EntryID INNER JOIN dbo.Location l ON l.LocationID = al.LocationID AND dbo.udf_calcdistance(@latitude, @longitude, l.latitude, l.longitude) < @range '
		END
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N' LEFT JOIN dbo.ArticleLocation al ON '
		IF ((@keyphraselist IS NOT NULL) AND (@assettype IS NULL))
		BEGIN 
			-- We haven't joined to VVisibleGuideEntries for performance reasons so join on akp.EntryID. 
			SELECT @sql = @sql + N' akp.EntryID = al.EntryID LEFT JOIN dbo.Location l ON l.LocationID = al.LocationID '
		END
		ELSE
		BEGIN
			SELECT @sql = @sql + N' va.EntryID = al.EntryID LEFT JOIN dbo.Location l ON l.LocationID = al.LocationID '
		END
	END
	--ADD NEW JOIN CLAUSES HERE


	--MAKE SURE THIS ONE IS THE LAST JOIN
	IF ((@articlestatus IS NOT NULL) OR (@articletype IS NOT NULL))
	BEGIN 
		-- Filtering on GuideEntry attributes so ensure that we have a join to GuideEntry table.
		IF (@keyphraselist IS NULL AND @assettype IS NULL)
		BEGIN
			-- Already working with VVisibleGuideEntries
			SELECT @sql = @sql + N' WHERE 1 = 1 '

			IF (@articlestatus IS NOT NULL)
			BEGIN
				SELECT @sql = @sql + N' AND va.Status = @articlestatus '
			END
			
			IF (@articletype IS NOT NULL)
			BEGIN
				SELECT @sql = @sql + N' AND va.Type = @articletype '
			END

			SELECT @sql = @sql + N' AND va.SiteID = @siteid '
		END
		ELSE
		BEGIN
			-- Have been working with specific media assets type so no join to GuideEntries has been made yet. 		
			SELECT @sql = @sql + N' INNER JOIN dbo.VVisibleGuideEntries e ON '

			IF ((@keyphraselist IS NOT NULL) AND (@assettype IS NULL))
			BEGIN
				SELECT @sql = @sql + N'akp.EntryID = e.EntryID and e.SiteID = @siteid '
			END
			ELSE
			BEGIN
				SELECT @sql = @sql + N'va.EntryID = e.EntryID and e.SiteID = @siteid '
			END

			SELECT @sql = @sql + N' WHERE 1 = 1 '

			IF (@articlestatus IS NOT NULL)
			BEGIN
				SELECT @sql = @sql + N' AND e.Status = @articlestatus '
			END
			
			IF (@articletype IS NOT NULL)
			BEGIN
				SELECT @sql = @sql + N' AND e.Type = @articletype '
			END
		END
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N' WHERE 1 = 1 '

		IF (@keyphraselist IS NULL)
		BEGIN
			SELECT @sql = @sql + N' AND va.SiteID = @siteid ' 
		END 
	END
	
	--SELECT @sql = @sql + N' WHERE e.SiteId = @siteid'


	IF (@keyphraselist IS NOT NULL)
	BEGIN
		SELECT @sql = @sql + N' AND akp.SiteId = @siteid GROUP BY akp.EntryID HAVING count(*) = @count '
	END

	IF ((@keyphraselist IS NOT NULL) OR (@freetextsearchcondition IS NOT NULL))
	BEGIN
		SELECT @sql = @sql +  N')'
		SELECT @sql = @sql +  N'SELECT * INTO #Entries FROM Entries; '
		SELECT @entriesintemptable = 1
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N' AND va.SiteId = @siteid '
		SELECT @sql = @sql +  N'), '
		SELECT @entriesintemptable = 0
	END

RETURN @@ERROR