Create Procedure listforumspostedto @userid int
As
	SELECT f.ForumID, f.Title, f.LastPosted FROM Forums f WHERE f.ForumID IN (SELECT t.ForumID FROM ThreadEntries t WHERE t.UserID = @userid)
	return (0)