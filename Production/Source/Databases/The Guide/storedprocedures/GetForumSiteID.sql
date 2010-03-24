Create Procedure getforumsiteid @forumid int, @threadid int
As
if @threadid = 0
BEGIN

	select SiteID, ForumID from Forums F WITH(NOLOCK) where F.ForumID = @forumid 

END
-- use the threadid to get the forum id if it has been provided as that
-- takes precedence
ELSE
BEGIN
		select TOP 1 F.SiteID, F.ForumID from Forums F WITH(NOLOCK)
			INNER JOIN Threads t WITH(NOLOCK) ON F.ForumID = t.ForumID
			WHERE t.ThreadID = @threadid
END