CREATE PROCEDURE getreviewforums @siteid int = 0
AS

if @siteid > 0
BEGIN
SELECT ReviewForumId, h2g2Id, ForumName, URLFriendlyName, SiteId, Recommend, IncubateTime
 FROM ReviewForums WITH(NOLOCK) WHERE SiteID = @siteid 
END
ELSE
BEGIN
SELECT ReviewForumId, h2g2Id, ForumName, URLFriendlyName, SiteId, Recommend, IncubateTime
 FROM ReviewForums WITH(NOLOCK) --WHERE SiteID = @siteid 
END
return(0)
