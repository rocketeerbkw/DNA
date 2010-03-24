/*
> getthreadlistfromforum @forumid int

	Inputs:	@forumid - id of forum posts to list
	Purpose:	Returns a list of forum posts, in descending date order of creation
				with the subject, person who started the conversation, the date
				it was last posted to, and the number of messages in the thread
*/

Create Procedure getthreadlistfromforum @forumid int
As
DECLARE @Count int
DECLARE @LastReply datetime
SELECT @Count = COUNT(*) FROM ThreadEntries WHERE Hidden = NULL AND ForumID = @forumid
SELECT top 200
	Subject, 
	DatePosted, 
	EntryID, 
	t.ThreadID, 
	t.ForumID,
	'Cnt' = @Count,
	'New' = CASE WHEN t.DatePosted > DATEADD(day,-1,getdate()) THEN 1 ELSE 0 END,
	u.UserID,
	u.UserName,
	u.Area,
	u.FirstNames,
	u.LastName,
	p.Title,
	p.SiteSuffix
	FROM ThreadEntries t
	INNER JOIN Users u ON u.UserID = t.UserID
	INNER JOIN Forums F ON F.ForumID = t.ForumID
	LEFT JOIN Preferences P on (P.UserID = U.UserID) AND (P.SiteID = F.SiteID) 
	WHERE t.ForumID = @forumid AND Hidden = NULL

	ORDER BY t.DatePosted DESC

