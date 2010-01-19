CREATE   PROCEDURE threadlistpostheaders2 @threadid int, @start int = 0, @end int = 2100000000

/*

Simpler Ripley-specific forum post fetcher

*/

AS
declare @numposts int
SELECT @numposts = MAX(PostIndex)+1 FROM ThreadEntries t WITH(NOLOCK)
INNER JOIN Threads th WITH(NOLOCK) ON th.ThreadID = t.ThreadID
WHERE t.ThreadID = @threadid AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL)

-- For any given Thread, the SiteID is constant, so look it up now and use it below to help the optimiser
DECLARE @SiteID int
SELECT @SiteID = f.SiteID
	FROM Threads th WITH(NOLOCK)
	INNER JOIN Forums f ON th.ForumID = f.ForumID
	WHERE th.ThreadID = @threadid

		SELECT 
			t.ForumID, 
			t.ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.Status, u.TaxonomyNode, 'Journal' = J.ForumID, u.Active,
			'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END, 
			'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			Hidden,
			'Interesting' = NULL,
			'Total' = @numposts,
			th.CanRead,
			th.CanWrite,
			u.Area,
			P.Title,
			p.SiteSuffix,
			f.ForumPostCount
	FROM ThreadEntries t WITH(NOLOCK)
	INNER JOIN Users u WITH(NOLOCK) on t.UserID = u.UserID
	INNER JOIN Threads th WITH(NOLOCK) on t.ThreadID = th.ThreadID
	INNER JOIN Forums F WITH(NOLOCK) on th.ForumID = F.ForumID
	LEFT JOIN Preferences P WITH(NOLOCK) on (P.UserID = U.UserID) and (P.SiteID = @SiteID)
	INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @SiteID
	WHERE t.ThreadID = @threadid AND t.PostIndex >= @start AND t.PostIndex <= @end  AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL)
	ORDER BY DatePosted
