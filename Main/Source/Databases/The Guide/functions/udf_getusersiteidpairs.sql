CREATE FUNCTION udf_getusersiteidpairs (@userids VARCHAR(MAX), @siteids VARCHAR(MAX))
RETURNS TABLE
AS
	/*
		Returns a table of userid - siteid pairs. 	*/

	RETURN 
	SELECT	u.element 'userID', 
			s.element 'siteID'
	  FROM	udf_splitvarchar(@userids) u
			INNER JOIN udf_splitvarchar(@siteids) s ON u.pos = s.pos
