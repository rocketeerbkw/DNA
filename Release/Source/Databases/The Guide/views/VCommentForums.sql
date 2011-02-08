CREATE VIEW VCommentForums
AS
SELECT     cf.UID
	, s.URLName AS sitename
	, cf.Url
	, f.Title
	, f.ForumPostCount +
                          (SELECT     ISNULL(SUM(PostCountDelta), 0) AS Expr1
                            FROM          dbo.ForumPostCountAdjust WITH (NOLOCK)
                            WHERE      (ForumID = f.ForumID)) AS ForumPostCount, f.ModerationStatus, f.DateCreated, cf.ForumCloseDate, 
                            case when flu.lastupdated is null then f.DateCreated else flu.lastupdated end AS LastUpdated, 
                            f.lastposted AS LastPosted
                            
	, 0 AS totalResults
	, 0 AS startindex
	, 0 AS itemsperpage
	, cf.SiteID AS siteId
	, cf.ForumID AS forumId
	, f.canread as canRead
	, f.canWrite as canWrite
	, case when ep.editorpickcount is null then 0 else ep.editorpickcount end as 'editorpickcount'
	, cf.NotSignedInUserId as NotSignedInUserId
	FROM         
	dbo.CommentForums AS cf WITH (NOLOCK) 
	INNER JOIN dbo.Forums AS f WITH (NOLOCK) ON cf.ForumID = f.ForumID 
    INNER JOIN dbo.Sites AS s ON s.SiteID = f.SiteID
    left outer join
      (select max(lastupdated) as lastupdated, forumid
		from ForumLastUpdated
		group by forumid) flu  ON flu.forumid = f.ForumID 
	left outer join (select count(*) as'editorpickcount', forumid from dbo.ThreadEntryEditorPicks group by forumid) ep on ep.forumid = cf.forumid

