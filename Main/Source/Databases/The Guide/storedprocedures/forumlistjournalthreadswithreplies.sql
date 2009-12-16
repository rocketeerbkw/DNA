/*
	inputs: @forumid = ID of journal forum
			@daysback = number of days to display
*/
Create Procedure forumlistjournalthreadswithreplies @forumid int
As
DECLARE @threadcount int
DECLARE @canread int, @canwrite int, @siteid int, @modstatus int

SELECT @threadcount = COUNT(*) FROM ThreadEntries t WITH(NOLOCK)
		INNER JOIN Threads d WITH(NOLOCK) ON t.ThreadID = d.ThreadID
		INNER JOIN ThreadPostings t1 WITH(NOLOCK) ON t.ThreadID = t1.ThreadID AND t.UserID = t1.UserID
		INNER JOIN Users u WITH(NOLOCK) ON t.userid = u.userid
		WHERE t.ForumID = @forumid AND t.Parent IS NULL
SELECT @canread = CanRead, @canwrite = CanWrite, @siteid = SiteID, @modstatus = ModerationStatus FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid
IF (@threadcount > 0)
BEGIN
	SELECT	Subject, 
			DatePosted, 
			EntryID, 
			'SiteID' = @siteid,
			t.ThreadID, 
			'LastReply' = t1.LastPosting,
			'Cnt' = t1.CountPosts,
			p.Title,
			p.SiteSuffix,
			t.UserID,
			u.UserName,
			u.Area,
			u.FirstNames,
			u.LastName,
			u.Status,
			u.TaxonomyNode,
			'Journal' = j.ForumID,
			u.Active,
			t.Hidden,
			'ThreadCount' = @threadcount,
			'CanRead' = @canread,
			'CanWrite' = @canwrite,
			'ModerationStatus' = @modstatus,
			t.PostStyle,
			t.text,
			d.Type,
			d.EventDate
		FROM ThreadEntries t WITH(NOLOCK)
		INNER JOIN Threads d WITH(NOLOCK) ON t.ThreadID = d.ThreadID
		INNER JOIN ThreadPostings t1 WITH(NOLOCK)
--			(SELECT	'Cnt' = COUNT(*), 
--					'LastReply' = MAX(DatePosted),
--					ThreadID
--				FROM ThreadEntries 
--				WHERE (Hidden <> 1 OR Hidden IS NULL)
--				GROUP BY ThreadID
--			) AS t1 
			ON t.ThreadID = t1.ThreadID AND t.UserID = t1.UserID
		INNER JOIN Users u WITH(NOLOCK) ON t.userid = u.userid
		INNER JOIN Forums f WITH(NOLOCK) ON f.forumid = @forumid
		LEFT JOIN Preferences p WITH(NOLOCK) ON (p.userid = t.userid) AND (p.siteid = f.siteid)
		INNER JOIN Journals j with(nolock) on j.userid = u.userid and j.siteid = f.siteid
		WHERE	t.ForumID = @forumid
				AND t.Parent IS NULL
		ORDER BY t.DatePosted DESC
END
ELSE
BEGIN
		SELECT
			'ThreadCount' = 0,
			'EntryID' = NULL,
			'ThreadID' = NULL,
			'SiteID' = @siteid,
			'CanRead' = @canread,
			'CanWrite' = @canwrite,
			'ModerationStatus' = @modstatus
END

	return (0)