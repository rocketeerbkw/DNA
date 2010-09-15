CREATE PROCEDURE getemailinsertsbysite2 @siteid int
AS
DECLARE @modclassid int
SELECT @modclassid = (select modclassid from Sites where SiteID = @siteid)

SELECT @siteid AS RequestedSiteID, 
	ISNULL(e2.EmailInsertID, e.EmailInsertID) as EmailInsertID, 
	ISNULL(e2.SiteID, e.SiteID) as SiteID, 
	e.ModClassID,
	e.InsertName, 
	e.InsertGroup, 
	ISNULL(e.InsertText, '') AS DefaultText, 
	ISNULL(e2.InsertText, '') AS InsertText,
	m.DisplayName 
	FROM emailinserts e 
	INNER JOIN ModReason m on m.emailname = e.insertname
	LEFT JOIN emailinserts e2 on m.emailname = e2.insertname and e2.siteid = @siteid
	WHERE e.modclassid = @modclassid
ORDER BY InsertName, SiteID Desc