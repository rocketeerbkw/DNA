create procedure getcommentdetails @uniqueid varchar(255)
as
	SELECT ForumID, Url FROM CommentForums WITH(NOLOCK) WHERE UID = @uniqueid
