/*********************************************************************************

	getallallowedurls

	Author:		Steven Francis
	Created:	03/05/2006
	Inputs:		
	Outputs:	
	Purpose:	Returns the all the allowed urls in alphabetical order
	
*********************************************************************************/
CREATE PROCEDURE getallallowedurls
AS
SELECT ID, SiteID, URL
FROM AllowedURLs
ORDER BY SiteID, URL ASC