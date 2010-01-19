/*********************************************************************************

	addnewallowedurl

	Author:		Steven Francis
	Created:	04/05/2006
	Inputs:		
	Outputs:	
	Purpose:	Inserts an allowed url into the table for a particular site
	
*********************************************************************************/
CREATE PROCEDURE addnewallowedurl @url varchar(255), @siteid int
AS
INSERT INTO AllowedURLs (SiteID, URL) VALUES (@siteid, @url)