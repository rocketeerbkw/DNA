CREATE FUNCTION udf_getvisiblesites (@siteid INT)
RETURNS TABLE
AS

	/*
		Function: Returns all sites visible from the site passed in. 

		Params:
			@siteid - current site. 

		Returns: Table 
					SiteID INT

	*/

	RETURN  SELECT @siteid As 'SiteID' -- Current site
			 UNION ALL
			SELECT SiteID
			  FROM dbo.SiteOptions so 
			 WHERE so.Section	= 'General' 
			   AND so.Name		= 'SiteIsPrivate' 
			   AND so.value		= '0'				-- All public sites 
			   AND dbo.udf_getsiteoptionsetting(@siteid, 'PersonalSpace', 'IncludeContentFromOtherSites') = 1 -- If current site includes content from other sites.
			   AND so.SiteID <> @siteid -- ensure current site is not duplicated without resorting to UNION and associated MERGE JOIN. 