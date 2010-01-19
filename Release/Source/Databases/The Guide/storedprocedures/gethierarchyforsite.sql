/*********************************************************************************

	create procedure gethierarchyforsite	@siteid int = 16 

	Author:		Steven Francis
	Created:	07/12/2006
	Inputs:		Site id
	Outputs:	Returns the hierarchy node set
	Purpose:	Extract the hierarchy node and tree levels
	
*********************************************************************************/

CREATE PROCEDURE gethierarchyforsite @siteid int = 16
AS
SELECT 'TreeLevel' = h.TreeLevel + 1, h2.ParentID, 'ParentName' = h.DisplayName, 'ParentType' = h.Type, h2.NodeID, h2.DisplayName, h2.Type FROM Hierarchy h 
INNER JOIN Hierarchy h2 on h2.ParentID = h.NodeID
WHERE h2.RedirectNodeID IS NULL AND h.SiteID = @siteid
ORDER BY h.TreeLevel
