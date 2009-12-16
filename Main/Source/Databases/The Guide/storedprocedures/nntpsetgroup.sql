/*
0 - regular forum ID
1 - UserID - message centre
2 - UserID - Journal
3 - Article - h2g2ID
*/

CREATE PROCEDURE nntpsetgroup @id int, @type int = 0
 AS
IF @type = 0 -- Regular forum ID
SELECT t.ForumID, 'MaxPost' = MAX(t.EntryID), 'MinPost' = MIN(t.EntryID), 'Total' = COUNT(*) FROM ThreadEntries t WHERE t.ForumID = @id AND (t.Hidden IS NULL) GROUP BY t.ForumID
ELSE IF @type = 1 -- User ID message board
SELECT	t.ForumID, 
		'MaxPost' = MAX(t.EntryID), 
		'MinPost' = MIN(t.EntryID), 
		'Total' = COUNT(*) 
	FROM ThreadEntries t
	INNER JOIN GuideEntries g ON g.ForumID = t.ForumID
	INNER JOIN Users u ON u.MastHead = g.h2g2ID
	WHERE u.UserID = @id AND (t.Hidden IS NULL) 
	GROUP BY t.ForumID
ELSE IF @type = 2 -- User journal
SELECT	ForumID, 
		'MaxPost' = MAX(EntryID), 
		'MinPost' = MIN(EntryID), 
		'Total' = COUNT(*) 
	FROM ThreadEntries t
	INNER JOIN Users u ON u.Journal = t.ForumID
	WHERE u.UserID = @id AND (t.Hidden IS NULL) 
	GROUP BY ForumID
ELSE IF @type = 3 -- Article forum
SELECT	t.ForumID, 
		'MaxPost' = MAX(t.EntryID), 
		'MinPost' = MIN(t.EntryID), 
		'Total' = COUNT(*) 
	FROM ThreadEntries t
	INNER JOIN GuideEntries g ON g.ForumID = t.ForumID
	WHERE g.h2g2ID = @id AND (t.Hidden IS NULL) 
	GROUP BY t.ForumID
