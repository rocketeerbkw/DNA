create procedure addnewhierarchytype @typeid int, @description varchar(50), @siteid int 
as

--check that its not already there to avoid bombing out
IF EXISTS(SELECT * FROM HierarchyNodeTypes WHERE NodeType = @typeid AND SiteID = @siteid)
BEGIN
	SELECT 'Duplicate' = 1;
	return 0;
END

INSERT INTO HierarchyNodeTypes (NodeType, Description, SiteID)
VALUES (@typeid, @description, @siteid)

