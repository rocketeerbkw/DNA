/*********************************************************************************

	updateallowedurl

	Author:		Steven Francis
	Created:	04/05/2006
	Inputs:		
	Outputs:	
	Purpose:	Updates an allowed url in the table
	
*********************************************************************************/
CREATE PROCEDURE updateallowedurl @id int, @url varchar(50), @siteid int AS
UPDATE AllowedURLs SET URL = @url, SiteID = @siteid
WHERE ID = @id