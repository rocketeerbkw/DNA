CREATE procedure commentsgetlastupdatebysite @siteid int, @prefix varchar(255) = null

as

if @prefix is null
begin

	select ISNULL(max(lastupdated),cast(convert(char(10),getdate(),121) AS datetime)) as lastupdated
	FROM dbo.ForumLastUpdated flu
    INNER JOIN dbo.CommentForums cf ON cf.ForumID = flu.ForumID
	where  cf.siteid = @siteid

end
else
begin

	select ISNULL(max(lastupdated),cast(convert(char(10),getdate(),121) AS datetime))  as lastupdated
	FROM dbo.ForumLastUpdated flu
    INNER JOIN dbo.CommentForums cf ON cf.ForumID = flu.ForumID
	where  cf.siteid = @siteid
	and cf.uid like @prefix
	OPTION (OPTIMIZE FOR (@prefix='%',@siteId=1))

end