CREATE Procedure totalapprovedentries @siteid int
AS


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 'cnt' = COUNT(*) FROM GuideEntries WHERE Status = 1 AND SiteID = @siteID