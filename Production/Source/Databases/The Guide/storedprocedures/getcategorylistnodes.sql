CREATE PROCEDURE getcategorylistnodes @categorylistid uniqueidentifier
AS
	DECLARE @ItemCount INT
	DECLARE @ListDescription VARCHAR(128)

	SELECT @ItemCount = COUNT(*)
	  FROM dbo.CategoryList cl
		   INNER JOIN dbo.CategoryListMembers clm ON clm.CategoryListID = cl.CategoryListID
	 WHERE cl.CategoryListID = @categorylistid
	 
	IF (@ItemCount > 0)
	BEGIN
		SELECT 'ItemCount' = @ItemCount, cl.Description, h.NodeID, h.DisplayName, h.Type, ISNULL(cl.ListWidth, 175) AS 'ListWidth'
		  FROM dbo.CategoryList cl
			   INNER JOIN dbo.CategoryListMembers clm ON clm.CategoryListID = cl.CategoryListID
			   INNER JOIN dbo.Hierarchy h ON h.NodeID = clm.NodeID
		 WHERE cl.CategoryListID = @categorylistid
	END
	ELSE
	BEGIN
		SELECT 'ItemCount' = @ItemCount, cl.Description, 'NodeID' = NULL, 'DisplayName'  = NULL, 'Type' = NULL, ISNULL(cl.ListWidth, 175) AS 'ListWidth'
		  FROM dbo.CategoryList cl
		 WHERE cl.CategoryListID = @categorylistid
	END
	
RETURN 0