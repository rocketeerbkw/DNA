CREATE PROCEDURE fetchwatchedjournalposts @userid INT, @currentsiteid INT = 0  
AS

-- NOTE: Currently disabled as recommended by Jim
RETURN

	DECLARE @threadcount INT
	
	SELECT	@threadcount = COUNT(*)
	FROM ThreadPostings AS t1 WITH(NOLOCK)
	INNER JOIN ThreadEntries AS t WITH(NOLOCK)	ON t.ThreadID = t1.ThreadID AND t1.UserID = @userid
	INNER JOIN FaveForums AS ff WITH(NOLOCK) ON ff.ForumID = t1.ForumID
	INNER JOIN Users AS u WITH(NOLOCK) ON ff.ForumID = u.Journal
	LEFT JOIN Preferences AS p WITH(NOLOCK) ON (p.userid = u.userid) and (p.siteid = @currentsiteid)
	WHERE ff.UserID = @userid  AND t.Parent IS NULL AND t.Hidden IS NULL
	
	SELECT	 Subject, 
			DatePosted, 
			EntryID, 
			t.ThreadID, 
			'LastReply' = t1.LastPosting,
			'Count' = t1.CountPosts,
			t.UserID,
			u.UserName,
			u.FirstNames,
			u.LastName,
			u.Area,
			u.status,
			u.taxonomynode,
			'Journal' = J.ForumID,
			u.active,			
			p.Title,
			p.SiteSuffix,
			t.ForumID,
			t.Hidden,
			'ThreadCount' = @threadcount,
			t.PostStyle,
			t.text			
		FROM ThreadPostings t1 WITH(NOLOCK) 
		INNER JOIN ThreadEntries t WITH(NOLOCK) ON t.ThreadID = t1.ThreadID AND t1.UserID = @userid
		INNER JOIN FaveForums ff WITH(NOLOCK)  ON ff.ForumID = t1.ForumID
		INNER JOIN Users u WITH(NOLOCK)  ON ff.ForumID = u.Journal
		LEFT JOIN Preferences AS p WITH(NOLOCK) ON (p.userid = u.userid) and (p.siteid = @currentsiteid)
		INNER JOIN Journals J WITH(NOLOCK) on J.UserID = u.UserID and J.SiteID = @currentsiteid
		WHERE ff.UserID = @userid AND t.Parent IS NULL
		ORDER BY t.Hidden, t.DatePosted DESC
