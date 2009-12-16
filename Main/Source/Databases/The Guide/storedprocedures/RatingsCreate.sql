CREATE procedure ratingscreate @entryid int, 
								@uid varchar(255), 
								@rating tinyint, 
								@userid int, 
								@siteid int
as

declare @forumid int
select @forumid = forumid from dbo.commentforums where uid = @uid and siteid=@siteid

insert into
dbo.ForumReview
(entryid, forumid, rating, userid)
values
(@entryid, @forumid, @rating, @userid)


