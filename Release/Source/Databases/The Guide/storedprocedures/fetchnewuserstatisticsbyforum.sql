CREATE PROCEDURE fetchnewuserstatisticsbyforum @userid int, @siteid int, @skip int, @show int, @mode int = 1, @startdate datetime, @enddate datetime, @recordscount int output
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		@userid, 
		u1.UserName,
		u1.FirstNames,
		u1.LastName,
		u1.Status,
		u1.Active,
		u1.Postcode,
		u1.Area,
		u1.TaxonomyNode,
		u1.UnreadPublicMessageCount,
		u1.UnreadPrivateMessageCount,
		u1.Region,
		u1.HideLocation,
		u1.HideUserName,
		u1.AcceptSubscriptions,
		ISNULL(csu1.Score, 0.0) AS 'ZeitgeistScore'
	FROM dbo.Users u1
	LEFT JOIN dbo.ContentSignifUser csu1 WITH(NOLOCK) ON u1.Userid = csu1.Userid AND csu1.SiteID = @siteid
	WHERE u1.UserID = @userid ;
	
	WITH CTE_USERSTATISTICS AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY f.forumid ASC, t.threadid ASC, te.dateposted DESC) AS 'n', 
		f.forumid, 
		t.threadid, 
		te.entryid, 
		f.title, 
		t.firstsubject, 
		te.subject, 
		te.dateposted, 
		te.PostIndex, 
		te.PostStyle, 
		te.text, 
		f.SiteID,
		s.URLName, 
		cf.Url,
		te.hidden
		FROM forums f WITH(NOLOCK) 
		INNER JOIN [threads] t WITH(NOLOCK) ON f.forumid = t.forumid 
		INNER JOIN threadentries te WITH(NOLOCK) ON te.threadid = t.threadid
		INNER JOIN users u WITH(NOLOCK) ON u.userid = te.userid
		INNER JOIN sites s WITH(NOLOCK) ON s.siteid = f.siteid
		LEFT JOIN commentforums cf WITH(NOLOCK) ON f.forumid = cf.forumid
		WHERE te.userid = @userid AND te.dateposted BETWEEN @startdate AND @enddate
	)
	SELECT 
		tmp.forumid, 
		tmp.threadid, 
		tmp.entryid, 
		tmp.title, 
		tmp.firstsubject, 
		tmp.subject, 
		tmp.dateposted, 
		tmp.PostIndex, 
		tmp.PostStyle, 
		tmp.text, 
		tmp.SiteID, 
		tmp.URLName, 
		tmp.Url,
		tmp.hidden
	FROM CTE_USERSTATISTICS tmp WITH(NOLOCK) 
	WHERE n > @skip AND n <= @skip + @show
	ORDER BY n

SET @recordscount = @@RowCount