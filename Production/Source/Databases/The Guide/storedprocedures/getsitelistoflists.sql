CREATE PROCEDURE getsitelistoflists	@siteid int = 1
As
SELECT DISTINCT GroupName, 'Type' = CASE WHEN ForumID IS NULL THEN 'Article' ELSE 'Forum' END FROM TopFives WHERE SiteID = @siteid
