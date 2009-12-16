/*
 Gets the team members for a given team
*/

CREATE PROCEDURE getallteammembers @teamid INT, @siteid INT
AS
BEGIN
	SELECT
				'User' = T.UserID, 
				U.Username, 
				U.FirstNames, 
				U.LastName, 
				U.Area, 
				U.Status,
				U.TaxonomyNode,
				'Journal' = J.ForumID, 
				U.Active,
				P.Title, 
				P.SiteSuffix, 
				'Role' = T.Role, 			
				T.DateJoined		
	FROM TeamMembers AS T
	INNER JOIN Users AS U ON  T.UserID = U.UserID 
	LEFT JOIN Preferences AS P ON (P.UserID = U.UserID) AND (P.SiteID = @siteid)
	INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = @siteid
	WHERE T.TeamID = @teamid
	RETURN  (0)
END