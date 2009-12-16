CREATE PROCEDURE getusersfornode @nodeid INT, @siteid INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Get the Details of the User

DECLARE @ErrorCode INT

SELECT 		u.UserID, 
		u.UserName, 
		u.FirstNames, 
		u.LastName, 
		u.Area,
		u.Status,
		u.TaxonomyNode,
		'Journal' = J.ForumID,
		u.Active,
		p.Title,
		p.SiteSuffix,
		hh.DisplayName

FROM Users u 
INNER JOIN [dbo].HierarchyUserMembers h ON h.UserId = u.UserId
INNER JOIN [dbo].Hierarchy hh ON hh.NodeId = h.NodeId AND hh.SiteId = @siteid
LEFT  JOIN [dbo].Preferences p on p.UserID = u.UserID AND p.SiteID = @siteid
INNER JOIN dbo.Journals J on J.UserID = U.UserID and J.SiteID = @siteid
WHERE h.NodeId = @nodeid

SET @ErrorCode = @@ERROR

RETURN @ErrorCode