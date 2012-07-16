CREATE VIEW VCommentForums
AS
SELECT	cf.UID,
		s.URLName AS sitename,
		cf.Url,
		f.Title,
		f.ForumPostCount +
        (
			SELECT
				ISNULL(SUM(PostCountDelta), 0) AS Expr1
			FROM
				dbo.ForumPostCountAdjust WITH (NOLOCK)
            WHERE
				(ForumID = f.ForumID)
		) AS ForumPostCount,
		f.ModerationStatus,
		f.DateCreated,
		cf.ForumCloseDate,
		CASE WHEN flu.lastupdated IS NULL THEN f.DateCreated ELSE flu.lastupdated END AS LastUpdated, 
        f.lastposted AS LastPosted,
        0 AS totalResults,
        0 AS startindex,
        0 AS itemsperpage,
        cf.SiteID AS siteId,
        cf.ForumID AS forumId,
        f.canread as canRead,
        f.canWrite as canWrite,
        CASE WHEN ep.editorpickcount IS NULL THEN 0 ELSE ep.editorpickcount END AS 'editorpickcount',
        cf.NotSignedInUserId as NotSignedInUserId,
        cf.IsContactForm
	FROM         
		dbo.CommentForums AS cf WITH (NOLOCK) 
		INNER JOIN dbo.Forums AS f WITH (NOLOCK) ON cf.ForumID = f.ForumID 
		INNER JOIN dbo.Sites AS s ON s.SiteID = f.SiteID
		LEFT OUTER JOIN
		(
			SELECT MAX(lastupdated) as lastupdated, forumid
			FROM ForumLastUpdated
			GROUP BY forumid
		) flu ON flu.forumid = f.ForumID 
		LEFT OUTER JOIN
		(
			SELECT	COUNT(*) AS 'editorpickcount',
					forumid
			FROM dbo.ThreadEntryEditorPicks
			GROUP BY forumid
		) ep on ep.forumid = cf.forumid

