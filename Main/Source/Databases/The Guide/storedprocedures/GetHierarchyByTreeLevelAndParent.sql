CREATE  PROCEDURE gethierarchybytreelevelandparent @isiteid int
AS
BEGIN

	DECLARE @count int
	SELECT @count=count(*)
			FROM Hierarchy 
			WHERE SiteID = @isiteid 

	Select 'count'=@count, TreeLevel, ParentID, NodeID, DisplayName, Type
			FROM Hierarchy 
			WHERE SiteID = @isiteid 
			ORDER BY TreeLevel asc
END