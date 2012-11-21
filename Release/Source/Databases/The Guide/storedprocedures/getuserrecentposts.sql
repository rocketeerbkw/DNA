/*
TODO: TOP can't be given a variable value so need a hack to get round this, such
as building the entire query as a string. For the time being always return TOP 10
*/

CREATE Procedure getuserrecentposts @userid int, @maxnumber int
As

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT TOP 10
	'ForumID' = t.ForumID, 
	'ThreadID' = c.ThreadID, 
	'Subject' = CASE WHEN t.FirstSubject = '' THEN 'No Subject' ELSE t.FirstSubject END, 
	'Date' = c.MostRecent, 
	'Newer' = c1.LastReply, 
	'Replies' = CASE 
				WHEN c.MostRecent >= c1.LastReply 
				THEN 0 
				ELSE 1 
				END
FROM Threads t
INNER JOIN (SELECT ThreadID, 'MostRecent' = MAX(DatePosted) FROM ThreadEntries
		WHERE UserID = @userid AND (Hidden IS NULL)
		GROUP BY ThreadID)
	AS c ON c.ThreadID = t.ThreadID
INNER JOIN (SELECT ThreadID, 'LastReply' = MAX(DatePosted) FROM ThreadEntries
		WHERE Hidden IS NULL
		/* WHERE DatePosted > @after AND DatePosted < @before */
		GROUP BY ThreadID)
	AS c1 ON c1.ThreadID = t.ThreadID
/*INNER JOIN Users u ON u.UserID = @userid */
ORDER BY /*Replies DESC,*/ c1.LastReply DESC
