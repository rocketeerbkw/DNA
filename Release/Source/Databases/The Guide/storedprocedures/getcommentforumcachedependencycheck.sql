create procedure getcommentforumcachedependencycheck @prefix varchar(255), @siteid INT
as
begin
	IF @prefix='movabletype%'
		RETURN
			
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	select TOP 1 t.LastPosted as 'LastUpdated'
	from dbo.CommentForums cf
	inner join dbo.Forums f on f.ForumID = cf.ForumID
	inner join Threads t ON f.forumid = t.forumid
	where cf.Uid like @prefix
	and (f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WHERE ForumID = f.ForumID)) <> 0
	order by t.LastPosted desc
	
end