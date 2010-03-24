CREATE PROCEDURE nntplist 
AS
/*
SELECT 'type' = 'articles', 'id' = g.h2g2ID, MinPost, MaxPost FROM Forums f 
INNER JOIN GuideEntries g ON g.ForumID = f.ForumID
INNER JOIN (SELECT ForumID, 'MinPost' = MIN(EntryID), 'MaxPost' = MAX(EntryID) 
	FROM ThreadEntries WHERE Hidden = 0 OR Hidden IS NULL GROUP BY ForumID) As c ON c.ForumID = f.ForumID
UNION
SELECT 'type' = 'journals', 'id' = u.UserID, MinPost, MaxPost
	FROM Forums f
	INNER JOIN Users u ON u.Journal = f.ForumID
	INNER JOIN (SELECT ForumID, 'MinPost' = MIN(EntryID), 'MaxPost' = MAX(EntryID) 
	FROM ThreadEntries WHERE Hidden = 0 OR Hidden IS NULL GROUP BY ForumID) As c ON c.ForumID = f.ForumID
*/

SELECT f.ForumID, 
		'ID' = CASE WHEN u1.UserID IS NOT NULL THEN u1.UserID WHEN g.h2g2ID IS NOT NULL THEN g.h2g2ID ELSE u.UserID END,
		'Type' = CASE WHEN u1.UserID IS NOT NULL THEN 'personal' WHEN  g.h2g2ID IS NOT NULL THEN 'articles' ELSE 'journals' END,
		MinPost,
		MaxPost,
		Total
		FROM Forums f
INNER JOIN (SELECT ForumID, 'MinPost' = MIN(EntryID), 'MaxPost' = MAX(EntryID), 'Total' = COUNT(*) 
	FROM ThreadEntries WHERE Hidden IS NULL GROUP BY ForumID) As c ON c.ForumID = f.ForumID
		LEFT JOIN GuideEntries g ON g.ForumID = f.ForumID
		LEFT JOIN Users u ON u.Journal = f.ForumID
		LEFT JOIN Users u1 ON u1.Masthead = g.h2g2ID