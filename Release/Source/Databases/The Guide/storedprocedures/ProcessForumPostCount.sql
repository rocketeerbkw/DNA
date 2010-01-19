create procedure processforumpostcount
as

declare @id int, @forumid int, @delta int
select @id = NULL
select top 1 @id = ID, @forumID = ForumID, @delta = PostCountDelta
 from forumpostcountadjust order by ID

if @id IS NOT NULL
BEGIN
	update Forums Set ForumPostCount = ForumPostCount + @delta WHERE ForumID = @forumid
	delete from ForumPostCountAdjust where ID = @id
END