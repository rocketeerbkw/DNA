create procedure getcommentforumlistbyuidprefix @prefix varchar(255), @count int, @siteid INT
as
begin
	IF @prefix='movabletype%'
		RETURN	

	IF @prefix='[_]%'
		RETURN

if charindex(',',@prefix) > 0
	set @prefix=substring(@prefix,charindex(',',@prefix)+1,len(@prefix))

	-- @prefix must include the the '%' wildcard for the like clause appended to prefix
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	with CTE_COMMENTFORUMLIST as
	(
		select TOP(@count) cf.uid
		from CommentForums cf
		inner join Forums f on f.ForumID = cf.ForumID
		inner join Threads t on t.ForumID = cf.ForumID
		where uid like @prefix -- AND cf.siteid = @siteid
--		and (f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WHERE ForumID = f.ForumID)) <> 0
		and f.canread=1
		order by t.LastPosted desc
	)
	select 
		cf.Uid,
		cf.SiteID,
		cf.ForumID, 
		cf.Url,
		f.Title,
		f.CanWrite,
		'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WHERE ForumID = f.ForumID),
		f.ModerationStatus,
		f.DateCreated, 
		cf.ForumCloseDate 'ForumCloseDate',
		'CommentForumListCount' = (select count(*) from CTE_COMMENTFORUMLIST),
		f.LastPosted 'LastUpdated',
		case when fmf.forumid is null then 0 else 1 end 'fastmod'
	from CTE_COMMENTFORUMLIST tmp 
	inner join CommentForums cf on tmp.Uid = cf.Uid
	inner join Forums f on f.ForumID = cf.ForumID
	left join fastmodforums fmf on fmf.forumid = f.forumID

end