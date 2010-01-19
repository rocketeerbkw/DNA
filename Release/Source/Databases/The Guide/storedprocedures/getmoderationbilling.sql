CREATE PROCEDURE getmoderationbilling @startdate datetime, @enddate datetime, @forcerecalculation int = 0, @siteid INT = null
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Uses a ModerationBilling cache table.
-- Work out whether the report results are available in the cache.
IF EXISTS ( SELECT s.siteid  FROM Sites s
			LEFT JOIN ModerationBilling mb ON mb.SiteId = s.SiteId AND StartDate = @startdate AND EndDate = @enddate
			WHERE s.siteid = ISNULL(@siteid,s.siteid) AND mb.SiteId IS NULL ) OR @forcerecalculation != 0
BEGIN

	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	DELETE FROM ModerationBilling WHERE StartDate = @startdate AND EndDate = @enddate AND SiteId = ISNULL(@siteid,SiteId)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO ModerationBilling (SiteID, StartDate, EndDate)
		SELECT SiteID, @startdate, @enddate 
		FROM Sites
		WHERE siteid = ISNULL(@siteid,siteid)
		
		
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode 
	END
 
		UPDATE ModerationBilling
		SET ThreadTotal = (SELECT COUNT(*) FROM ThreadEntries te WITH(NOLOCK) 
		INNER JOIN Forums f ON f.forumId = te.forumId
		WHERE (te.DatePosted BETWEEN @startdate AND @enddate) AND f.SiteID = ModerationBilling.SiteID),
			ThreadModTotal = (SELECT COUNT(*) FROM ThreadMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID),
			ThreadPassed = (SELECT COUNT(*) FROM ThreadMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND Status = 3),
			ThreadFailed = (SELECT COUNT(*) FROM ThreadMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND Status = 4),
			ThreadReferred = (SELECT COUNT(*) FROM ThreadMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND ReferredBy IS NOT NULL),
			ThreadComplaint = (SELECT COUNT(*) FROM ThreadMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND ComplainantID IS NOT NULL),
			ArticleModTotal = (SELECT COUNT(*) FROM ArticleMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID),
			ArticlePassed = (SELECT COUNT(*) FROM ArticleMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND t.Status = 3),
			ArticleFailed = (SELECT COUNT(*) FROM ArticleMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND t.Status = 4),
			ArticleReferred = (SELECT COUNT(*) FROM ArticleMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND ReferredBy IS NOT NULL),
			ArticleComplaint = (SELECT COUNT(*) FROM ArticleMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID AND ComplaintText IS NOT NULL),
			GeneralModTotal = (SELECT COUNT(*) FROM GeneralMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.SiteID = ModerationBilling.SiteID),
			GeneralPassed = (SELECT COUNT(*) FROM GeneralMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.Status = 3 AND t.SiteID = ModerationBilling.SiteID),
			GeneralFailed = (SELECT COUNT(*) FROM GeneralMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND t.Status = 4 AND t.SiteID = ModerationBilling.SiteID),
			GeneralReferred = (SELECT COUNT(*) FROM GeneralMod t WITH(NOLOCK) WHERE (t.DateCompleted BETWEEN @startdate AND @enddate) AND ReferredBy IS NOT NULL AND t.SiteID = ModerationBilling.SiteID)
		WHERE StartDate = @startdate AND EndDate = @enddate AND SiteId = ISNULL(@siteid,SiteId)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION
END

SELECT * from ModerationBilling
	WHERE StartDate = @startdate AND EndDate = @enddate AND siteid = ISNULL(@siteid,siteid)