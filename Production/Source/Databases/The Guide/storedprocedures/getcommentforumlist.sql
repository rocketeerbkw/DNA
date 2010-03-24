CREATE PROCEDURE getcommentforumlist @skip int = 0, @show int = 20
AS
BEGIN
	DECLARE @total int
	
	SELECT @total = COUNT(*) FROM Forums f WITH(NOLOCK) 
	INNER JOIN CommentForums cf WITH(NOLOCK) on cf.ForumID = f.ForumID;

WITH CTE_COMMENTFORUMLIST AS
(
	SELECT ROW_NUMBER() OVER(ORDER BY f.ForumID ASC) AS 'n', cf.Uid
	FROM Forums f WITH(NOLOCK) 
	INNER JOIN CommentForums cf WITH(NOLOCK) on cf.ForumID = f.ForumID
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
	f.LastPosted 'LastUpdated'
	FROM CTE_COMMENTFORUMLIST tmp WITH(NOLOCK) 
	INNER JOIN CommentForums cf WITH(NOLOCK) on tmp.Uid = cf.Uid
	INNER JOIN Forums f WITH(NOLOCK) on cf.ForumID = f.ForumID
	WHERE n > @skip AND n <= @skip + @show
	ORDER BY n
END