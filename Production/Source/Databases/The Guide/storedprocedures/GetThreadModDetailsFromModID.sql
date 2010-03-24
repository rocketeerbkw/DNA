CREATE PROCEDURE getthreadmoddetailsfrommodid @modid int
AS
SELECT	'ForumID' = tm.ForumID,
		'PostID' = tm.PostID,
		'ForumTitle' = f.Title,
		'ThreadID' = ISNULL(tm.ThreadID,0),
		'ThreadSubject' = CASE WHEN ISNULL(tm.ThreadID,0) = 0 THEN ISNULL(pmp.Subject,'') ELSE t.FirstSubject END,
		'IsPremodPosting' = tm.IsPreModPosting
	FROM dbo.ThreadMod tm WITH(NOLOCK)
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = tm.ForumID
		LEFT JOIN dbo.PreModPostings pmp WITH(NOLOCK) ON pmp.ModID = tm.ModID
		LEFT JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = tm.ThreadID
			WHERE tm.ModID = @modid