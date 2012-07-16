CREATE PROCEDURE getcommentforumlistbysite @siteid int, @skip int = 0, @show int = 20
AS
BEGIN
	DECLARE @total int
	
	SELECT @total = COUNT(*) FROM Forums f WITH(NOLOCK) 
	INNER JOIN CommentForums cf WITH(NOLOCK) on cf.ForumID = f.ForumID
	WHERE cf.SiteID = @siteid
	AND ISNULL(cf.IsContactForm,0) = 0;

WITH CTE_COMMENTFORUMLIST AS
(
	SELECT ROW_NUMBER() OVER(ORDER BY f.ForumID desc) AS 'n', cf.Uid
	FROM Forums f WITH(NOLOCK) 
	INNER JOIN CommentForums cf WITH(NOLOCK) on cf.ForumID = f.ForumID
	WHERE cf.SiteID = @siteid
)
	SELECT 
	cf.Uid,
	cf.SiteID,
	cf.ForumID, 
	cf.Url, 
	f.Title,
	f.CanWrite,
	'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = f.ForumID),
	f.ModerationStatus,
	f.DateCreated, 
	cf.ForumCloseDate 'ForumCloseDate', 
	@total 'CommentForumListCount',
	f.LastPosted 'LastUpdated',
	case when fmf.forumid is null then 0 else 1 end 'fastmod'
	FROM CTE_COMMENTFORUMLIST tmp WITH(NOLOCK) 
	INNER JOIN CommentForums cf WITH(NOLOCK) on tmp.Uid = cf.Uid
	INNER JOIN Forums f WITH(NOLOCK) on cf.ForumID = f.ForumID
	left join fastmodforums fmf on fmf.forumid = f.forumID
	WHERE n > @skip AND n <= @skip + @show
	ORDER BY n
END