/*
	Fetches details on all the sub editors - their user details, their
	subbing quota, and the number of articles currently allocated to them
*/

CREATE PROCEDURE fetchsubeditorsdetails @currentsiteid INT,  @skip INT =0, @show INT =20
AS
BEGIN
	-- select user details plus the number of entries currently allocated to the sub
	-- and also the date they were last notified and the subs quota

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @groupid INT
	SELECT @groupid=GroupID FROM Groups WHERE [NAME] = 'Subs'

	set @show = @show + 1 -- add one

	;WITH SubEditors AS
	(
	SELECT u.UserID, ROW_NUMBER() OVER(ORDER BY u.username ASC) n
	FROM Users u
	INNER JOIN GroupMembers AS GM ON GM.UserID = U.UserID AND GM.GroupID = @groupid
	INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = @currentsiteid
	)
	SELECT	
				U.UserID, 
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
				U.Email,
				ISNULL(SD.Quota, 4) AS SubQuota,
				DateLastNotified,
				(SELECT COUNT(EntryID) FROM AcceptedRecommendations WHERE SubEditorID = U.UserID AND Status = 2) AS Allocations
	FROM SubEditors AS se
	INNER JOIN Users U ON U.UserID = se.UserID
	INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = @currentsiteid
	LEFT JOIN Preferences AS P ON (P.UserID = U.UserID) and (P.SiteID = @currentsiteid)
	LEFT OUTER JOIN SubDetails SD ON SD.SubEditorID = u.UserID
	WHERE n > @skip AND n <=(@skip+@show)
	ORDER BY n ASC

RETURN (0)
END
