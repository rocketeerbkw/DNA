CREATE PROCEDURE getallsiteoptions
AS
	SELECT SiteID,Section,Name,Value,Type,Description
		FROM SiteOptions
		ORDER BY Section,SiteID,Name
