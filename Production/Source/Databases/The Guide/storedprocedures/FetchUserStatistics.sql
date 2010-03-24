CREATE PROCEDURE fetchuserstatistics @userid int, @mode int = 1, @startdate datetime, @enddate datetime, @recordscount int output
AS

IF @mode = 0
BEGIN
	SELECT TOP 200 u.UserName, f.forumid, t.threadid, te.entryid, f.title, t.firstsubject, te.subject, 
		te.dateposted, te.PostStyle, te.text, f.SiteID, te.hidden
	FROM forums f WITH(NOLOCK) INNER JOIN threads t WITH(NOLOCK) ON f.forumid = t.forumid 
		INNER JOIN threadentries te WITH(NOLOCK) ON te.threadid = t.threadid
		INNER JOIN users u WITH(NOLOCK) ON u.userid = te.userid
	WHERE te.userid = @userid AND te.dateposted BETWEEN @startdate AND @enddate
	ORDER BY f.forumid ASC, t.threadid ASC, te.dateposted DESC
END
ELSE
BEGIN
	SELECT TOP 200 u.UserName, f.forumid, t.threadid, te.entryid, f.title, t.firstsubject, te.subject, 
		te.dateposted, te.PostStyle, te.text, f.SiteID, te.hidden
	FROM forums f WITH(NOLOCK) INNER JOIN threads t WITH(NOLOCK) ON f.forumid = t.forumid 
		INNER JOIN threadentries te WITH(NOLOCK) ON te.threadid = t.threadid
		INNER JOIN users u WITH(NOLOCK) ON u.userid = te.userid
	WHERE te.userid = @userid AND te.dateposted BETWEEN @startdate AND @enddate
	ORDER BY te.dateposted DESC
END

SET @recordscount = @@RowCount
