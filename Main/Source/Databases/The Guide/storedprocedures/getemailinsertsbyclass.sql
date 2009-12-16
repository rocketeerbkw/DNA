CREATE PROCEDURE getemailinsertsbyclass @modclassid int
AS
BEGIN
DECLARE @siteid int
IF (@modclassid = -1)
BEGIN 
	SET @modclassid = (SELECT ModClassID FROM ModerationClass WHERE Name = 'general')
	SET @siteid = (SELECT TOP 1 SiteID FROM Sites WHERE ModClassID = @modclassid ORDER BY ShortName ASC)
	EXEC getemailinsertsbysite @siteid
END
ELSE
BEGIN
	SELECT 0 AS RequestedSiteID, 
		e.EmailInsertID, 
		e.SiteID, 
		e.ModClassID, 
		e.InsertName, 
		e.InsertGroup, 
		e.InsertText AS DefaultText, 
		'' AS InsertText ,
		m.DisplayName 
		from EmailInserts e
		inner join ModReason m on e.insertname = m.emailname
		where e.ModClassId = @modclassid
	ORDER BY InsertName, SiteID Desc
END
END