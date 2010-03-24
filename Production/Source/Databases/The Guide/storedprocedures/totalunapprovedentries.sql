CREATE PROCEDURE totalunapprovedentries  @siteid int
	
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT COUNT(*) as 'cnt'
	FROM GuideEntries
	where SiteID = @siteid
	AND Status = 3

