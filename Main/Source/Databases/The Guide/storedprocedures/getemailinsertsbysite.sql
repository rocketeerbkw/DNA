CREATE PROCEDURE getemailinsertsbysite @siteid int
AS
BEGIN
declare @modclassid int
select @modclassid = (select modclassid from Sites where SiteID = @siteid)
SELECT @siteid AS RequestedSiteID, 
	e.EmailInsertID, 
	e.SiteID, 
	e.ModClassID, 
	e.InsertName, 
	e.InsertGroup, '' AS DefaultText, 
	e.InsertText,
	m.DisplayName 
	FROM emailinserts e
	inner join ModReason m on m.emailname = e.insertname
	where siteid = @siteid
UNION ALL (
	SELECT @siteid AS RequestedSiteID, 
		e.EmailInsertID, 
		e.SiteID, 
		e.ModClassID, 
		e.InsertName, 
		e.InsertGroup, 
		e.InsertText AS DefaultText, 
		'' AS InsertText,
		m.DisplayName 
		 from emailinserts e 
		inner join ModReason m on m.emailname = e.insertname
		where modclassid = @modclassid)
ORDER BY InsertName, SiteID Desc
END