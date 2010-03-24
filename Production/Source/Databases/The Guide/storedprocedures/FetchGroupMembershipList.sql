/*
	Fetches details on all the users that belong to the group
	with this name.
*/

CREATE PROCEDURE fetchgroupmembershiplist @groupname VARCHAR(50), @siteid INT , @system INT = 0,
		@skip INT =0, 
		@show INT =10000
AS
BEGIN
	
		;WITH GroupUsers AS
		(
			SELECT U.UserID, ROW_NUMBER() OVER(ORDER BY P.DateJoined ASC) n
			FROM Users AS U
			INNER JOIN GroupMembers AS GM ON GM.UserID = U.UserID
			INNER JOIN Groups AS G on G.GroupID = GM.GroupID
			LEFT JOIN Preferences AS P ON (P.UserID = U.UserID) AND (P.SiteID = @siteid)
			WHERE G.Name = @groupname AND (GM.SiteID = @siteid)
		)
		SELECT U.*,
		P.Title, 
		P.SiteSuffix
		FROM Users U 
		INNER JOIN GroupUsers GU on GU.UserID = U.userid
		LEFT JOIN Preferences  P ON (P.UserID = U.UserID) AND (P.SiteID = @siteid)
		where n > @skip AND n <=(@skip+@show)
	RETURN (0)
END

