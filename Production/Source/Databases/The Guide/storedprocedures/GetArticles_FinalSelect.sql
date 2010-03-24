CREATE PROCEDURE getarticles_finalselect 
@siteid	int, 
@includezeitgeistscore bit, 
@sortbyrangeflag bit = 0, 
@latitude float = 0.0, 
@longitude float = 0.0, 
@range float = 0.0, 
@sql nvarchar(max) output
AS

	/*
		Function: 3. Returns SQL for final results set  

		Params:
			@siteid - SiteID.
			@section - Section the SiteOption is in. 
			@name - Name of SiteOption.

		Returns: 2 result sets: 1st - Articles with associated keyphrase namespace pairs. 
								2nd - Articles + article related information. 

	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--	SELECT @sql = @sql + N' SELECT * FROM @Sorted; '
	
	-- KEY PHRASE SELECT
	SELECT @sql = @sql + N'SELECT srt.EntryID, ge.h2g2ID, kp.PhraseId, kp.phrase, ns.NameSpaceID, ns.Name as Namespace '
	SELECT @sql = @sql + N'FROM @Sorted srt '
	SELECT @sql = @sql + N'INNER JOIN dbo.GuideEntries ge ON srt.EntryID = ge.EntryID '
	SELECT @sql = @sql + N'LEFT JOIN dbo.ArticleKeyPhrases akp ON srt.EntryID = akp.EntryID AND akp.siteid = @siteid '
	SELECT @sql = @sql + N'LEFT JOIN dbo.PhraseNameSpaces pns ON akp.PhraseNameSpaceID = pns.PhraseNameSpaceID '
	SELECT @sql = @sql + N'LEFT JOIN dbo.KeyPhrases kp ON pns.PhraseID = kp.PhraseID '
	SELECT @sql = @sql + N'LEFT JOIN dbo.NameSpaces ns ON pns.NameSpaceID = ns.NameSpaceID '
	SELECT @sql = @sql + N'ORDER BY srt.EntryID; '

	-- Create final record set
	SELECT @sql = @sql + N' SELECT srt.EntryID, '
		SELECT @sql = @sql + N'ge.h2g2ID, ' 
		SELECT @sql = @sql + N'ge.subject, '
		SELECT @sql = @sql + N'ge.editor, '
		SELECT @sql = @sql + N'ge.extrainfo, '
		SELECT @sql = @sql + N'ge.datecreated, '
		SELECT @sql = @sql + N'ge.lastupdated, '
		SELECT @sql = @sql + N'ge.Type, '
		SELECT @sql = @sql + N'ge.Status, '
		SELECT @sql = @sql + N'(select count(*) FROM @Sorted) as ''count'', '
		SELECT @sql = @sql + N'(select TOP 1 Total FROM @Sorted) as ''total'', '
		SELECT @sql = @sql + N'ama.MediaAssetID, '
		SELECT @sql = @sql + N'ge.SiteID, '
		SELECT @sql = @sql + N'ma.Caption, '
		SELECT @sql = @sql + N'ma.Filename, '
		SELECT @sql = @sql + N'ma.MimeType, '
		SELECT @sql = @sql + N'ma.ContentType, '
		SELECT @sql = @sql + N'ma.ExtraElementXML, '
		SELECT @sql = @sql + N'ma.OwnerID, '
		SELECT @sql = @sql + N'ma.DateCreated ''MADateCreated'', '
		SELECT @sql = @sql + N'ma.LastUpdated ''MALastUpdated'', '
		SELECT @sql = @sql + N'ma.Description, '
		SELECT @sql = @sql + N'ma.Hidden, '
		SELECT @sql = @sql + N'ma.ExternalLinkURL, '
		SELECT @sql = @sql + N'pv.voteid CRPollID, '
		SELECT @sql = @sql + N'pv.AverageRating CRAverageRating, '
		SELECT @sql = @sql + N'pv.VoteCount CRVoteCount, '
		SELECT @sql = @sql + N'ge.Hidden ''ArticleHidden'', '
		SELECT @sql = @sql + N'adr.StartDate, '
		SELECT @sql = @sql + N'adr.EndDate, ' 
		SELECT @sql = @sql + N'adr.TimeInterval, '
		SELECT @sql = @sql + N'u.UserName, '
		SELECT @sql = @sql + N'u.FirstNames, '
		SELECT @sql = @sql + N'u.LastName, '
		SELECT @sql = @sql + N'u.Status, '
		SELECT @sql = @sql + N'u.Active, '
		SELECT @sql = @sql + N'u.Postcode, '
		SELECT @sql = @sql + N'u.Area, '
		SELECT @sql = @sql + N'u.TaxonomyNode, '
		SELECT @sql = @sql + N'u.UnreadPublicMessageCount, '
		SELECT @sql = @sql + N'u.UnreadPrivateMessageCount, '
		SELECT @sql = @sql + N'u.Region, '
		SELECT @sql = @sql + N'u.HideLocation, '
		SELECT @sql = @sql + N'u.HideUserName, '
		SELECT @sql = @sql + N'f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = f.ForumID) as ''ForumPostCount'', '
		SELECT @sql = @sql + N'f.LastPosted, '
		SELECT @sql = @sql + N'al.LocationID, '
		SELECT @sql = @sql + N'l.Latitude, '
		SELECT @sql = @sql + N'l.Longitude, '
		IF (@latitude <> 0.0 AND @longitude <> 0.0 AND @range <> 0.0)
		BEGIN
			SELECT @sql = @sql + N'(select ROUND(dbo.udf_calcdistance (@latitude, @longitude, l.Latitude, l.Longitude), 5)) as ''Distance'', '
		END
		ELSE
		BEGIN
			SELECT @sql = @sql + N'Distance = CAST(0.0 as float), '
		END
		SELECT @sql = @sql + N'l.Title ''LocationTitle'', '
		SELECT @sql = @sql + N'l.Description ''LocationDescription'', '
		SELECT @sql = @sql + N'l.ZoomLevel ''LocationZoomLevel'', '
		SELECT @sql = @sql + N'l.UserID ''LocationUserID'', '
		SELECT @sql = @sql + N'l.DateCreated ''LocationDateCreated'' '
		IF (@IncludeZeitgeistScore = 1)
		BEGIN
			SELECT @sql = @sql + N', csa.Score as ''ZeitgeistScore'' '
		END
		IF (dbo.udf_getsiteoptionsetting(@siteid, 'GuideEntries', 'IncludeBookmarkCount') = 1)
		BEGIN
			SELECT @sql = @sql + N', lnk.[Count] as ''BookmarkCount'' '
		END 
	SELECT @sql = @sql + N'FROM @Sorted srt '
	SELECT @sql = @sql + N'INNER JOIN dbo.GuideEntries ge ON srt.EntryID = ge.EntryID '
	SELECT @sql = @sql + N'INNER JOIN dbo.Forums f ON f.ForumID = ge.ForumID '
	SELECT @sql = @sql + N'INNER JOIN dbo.Users u ON u.Userid = ge.editor '
	SELECT @sql = @sql + N'LEFT JOIN dbo.ArticleMediaAsset ama ON srt.EntryID = ama.EntryID '
	SELECT @sql = @sql + N'LEFT JOIN dbo.MediaAsset ma ON ama.MediaAssetID = MA.ID '
	SELECT @sql = @sql + N'LEFT JOIN dbo.PageVotes pv on ge.h2g2id = pv.itemid and pv.itemtype=1 '
	SELECT @sql = @sql + N'LEFT JOIN dbo.ArticleDateRange adr ON srt.EntryID = adr.EntryID '
	IF (@sortbyrangeflag = 1)
	BEGIN
		SELECT @sql = @sql + N'LEFT JOIN dbo.ArticleLocation al ON srt.EntryID = al.EntryID AND srt.LocationID = al.LocationID '
		SELECT @sql = @sql + N'LEFT JOIN dbo.Location l ON al.LocationID = l.LocationID '
	END
	ELSE
	BEGIN
		SELECT @sql = @sql + N'LEFT JOIN dbo.ArticleLocation al ON srt.EntryID = al.EntryID '
		SELECT @sql = @sql + N'LEFT JOIN dbo.Location l ON al.LocationID = l.LocationID '
	END
	IF (@IncludeZeitgeistScore = 1)
	BEGIN
		SELECT @sql = @sql + N'LEFT JOIN dbo.ContentSignifArticle csa ON ge.EntryID = csa.EntryID '
	END

	IF (dbo.udf_getsiteoptionsetting(@siteid, 'GuideEntries', 'IncludeBookmarkCount') = 1)
	BEGIN
		SELECT @sql = @sql + N'LEFT JOIN dbo.VLinkCounts lnk ON ge.h2g2ID = lnk.DestinationID '
	END 
	
	IF (@latitude <> 0.0 AND @longitude <> 0.0 AND @range <> 0.0)
	BEGIN
		SELECT @sql = @sql + N'WHERE dbo.udf_calcdistance(@latitude, @longitude, l.latitude, l.longitude) < @range '
	END



	SELECT @sql = @sql + N'ORDER BY srt.rn, srt.EntryID DESC; '

RETURN @@ERROR