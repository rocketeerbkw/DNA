Create Procedure isforumareviewforum @forumid int
As

select ReviewForumID from ReviewForums r WITH(NOLOCK) inner join GuideEntries g WITH(NOLOCK) on g.h2g2id=r.h2g2id 
where g.forumid = @forumid 

return (0)
