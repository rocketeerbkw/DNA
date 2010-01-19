/*********************************************************************************

	deleteallowedurl

	Author:		Steven Francis
	Created:	04/05/2006
	Inputs:		
	Outputs:	
	Purpose:	Deletes an allowed url from the table
	
*********************************************************************************/
CREATE PROCEDURE deleteallowedurl @id int
AS
DELETE FROM AllowedURLs WHERE ID = @id