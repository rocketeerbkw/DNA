create procedure getcommentforumlistbydnauids @dnauids xml
as
begin
	-- @dnauids type expected format
	--	<dnauid>
	--		dnauid
	--	<dnauid>
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
				
	with CTE_COMMENTFORUMLIST as
	(
		select d1.c1.value('.','varchar(256)') uid
		from @dnauids.nodes('/dnauid') as d1(c1)
	)	
	select 
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
		'CommentForumListCount' = (select count(*) from CTE_COMMENTFORUMLIST),
		f.LastPosted 'LastUpdated' 
	from CTE_COMMENTFORUMLIST tmp 
	inner join CommentForums cf on tmp.Uid = cf.Uid
	inner join Forums f on f.ForumID = cf.ForumID	
	
	return 0;
end