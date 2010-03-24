CREATE PROCEDURE  fetchentriesresearchers @entryid INT, @siteid INT
AS
BEGIN
	SELECT 
				R.UserID, 
				U.Username, 
				U.FirstNames,
				U.LastName,
				U.Area,
				U.Status,
				U.TaxonomyNode,
				J.ForumID as 'Journal',
				U.Active,				
				P.Title, 
				P.SiteSuffix
	FROM Researchers AS R
	INNER JOIN Users AS U ON U.UserID = R.UserID
	LEFT JOIN Preferences AS P ON (P.UserID = U.UserID) AND (P.SiteID = @siteid)
	LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @siteid
	WHERE R.EntryID = @entryid
	RETURN (0)
END
