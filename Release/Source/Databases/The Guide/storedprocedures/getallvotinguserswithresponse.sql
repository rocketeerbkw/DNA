CREATE PROCEDURE getallvotinguserswithresponse @ivoteid INT, @iresponse INT, @siteid INT
AS
BEGIN
	SELECT v.*, u.UserName, u.FirstNames, u.LastName, u.Area, u.status, u.taxonomynode, 'Journal' = J.ForumID, u.active, p.Title, p.SiteSuffix 
	FROM VoteMembers AS v
	INNER JOIN Users AS u ON v.UserID = u.UserID
	LEFT JOIN Preferences AS P ON (P.UserID = U.UserID) AND (P.SiteID = @siteid)
	INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = @siteid
	WHERE v.VoteID = @ivoteid AND v.Response = @iresponse 
	UNION 
	( 
		SELECT v.*, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
		FROM VoteMembers AS v
		WHERE VoteID = @ivoteid AND Response = @iresponse AND UserID = 0 
	)
END
