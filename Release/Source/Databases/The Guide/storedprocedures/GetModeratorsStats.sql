CREATE PROCEDURE getmoderatorsstats @siteids varchar(max), @userids varchar(max), @startdate datetime, @enddate datetime
AS
	/*
		Function: Gets moderation stats for list of moderators passed. 

		Params:
			@siteids - comma separated list of SiteIDs.
			@userids - comma separated list of user ids. 
			@startdate - start of range. 
			@enddate - end of range. 

		Results Set: 	UserID			INT 
						SiteID			INT 
						PostsPassed		INT 
						PostsFailed		INT 
						PostsRefered	INT 
						PostsTotal		INT 
						ArticlePassed	INT 
						ArticleFailed	INT 
						ArticleRefered	INT 
						ArticleTotal	INT 
						NicknamePassed	INT 
						NicknameFailed	INT 
						NicknameTotal	INT 

		Returns: @@ERROR
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT	CAST(element AS INT) AS 'UserID'
	  INTO	#Moderators
	  FROM	dbo.udf_splitvarcharwithdelimiter(@userids, ',');

	SELECT	CAST(element AS INT) AS 'SiteID'
	  INTO	#Sites
	  FROM	dbo.udf_splitvarcharwithdelimiter(@siteids, ',');

	CREATE TABLE #ModStats 
	(
		UserID INT, 
		UserName varchar(255), 
		SiteID INT,
		SiteName varchar(50),
		PostsPassed INT NULL,
		PostsFailed INT NULL, 
		PostsRefered INT NULL, 
		PostsTotal INT NULL, 
		ArticlePassed INT NULL, 
		ArticleFailed INT NULL, 
		ArticleReferred INT NULL, 
		ArticleTotal INT NULL, 
		NicknamePassed INT NULL, 
		NicknameFailed INT NULL, 
		NicknameTotal INT NULL
	)

	INSERT INTO #ModStats (UserID, UserName, SiteID, SiteName)
	SELECT m.UserID, u.UserName, s.SiteID, s.ShortNAme
	  FROM	#Moderators m
			cross join #Sites ps 
			INNER JOIN dbo.Sites s ON ps.SiteID = s.SiteID
			INNER JOIN dbo.Users u ON m.UserID = u.UserID;

	WITH SummedThreadModStats (ModeratorID, SiteID, Status, [Count]) AS 
	(
			SELECT	tmcube.UserID, tmcube.SiteID, tmcube.Status, SUM([count])
			  FROM	#Moderators m
					INNER JOIN dbo.ThreadModCube tmcube on m.UserID = tmcube.UserID
					INNER JOIN #Sites s on tmcube.SiteID = s.SiteID
			 WHERE	tmcube.Date >= @startdate
			   AND	tmcube.Date < @enddate
			   AND	tmcube.Status IS NOT NULL 
			 GROUP	BY tmcube.UserID, tmcube.SiteID, tmcube.Status
	),
	CollapsedThreadModStats (UserID, SiteID, PostsPassed, PostsFailed, PostsTotal) AS
	(
		SELECT	t.ModeratorID, 
				t.SiteID, 
				SUM(CASE t.Status WHEN 3 THEN t.[Count] END),
				SUM(CASE t.Status WHEN 4 THEN t.[Count] END),
				SUM(CASE t.Status WHEN 3 THEN t.[Count] WHEN 4 THEN t.[Count] END)
		  from	#ModStats
				INNER JOIN SummedThreadModStats t ON #ModStats.UserID = t.ModeratorID AND #ModStats.SiteID = t.SiteID
		 group by t.ModeratorID, t.SiteID
	)
	UPDATE #ModStats
	   SET	PostsPassed = s.PostsPassed,
			PostsFailed = s.PostsFailed,
			PostsTotal = s.PostsTotal
	  FROM	#ModStats 
			INNER JOIN CollapsedThreadModStats s ON #ModStats.UserID = s.UserID AND #ModStats.SiteID = s.SiteID;

	WITH SummedThreadModReferralsStats (ModeratorID, SiteID, [Count]) AS 
	(
			SELECT	tmrcube.UserID, tmrcube.SiteID, SUM([count])
			  FROM	#Moderators m
					INNER JOIN dbo.ThreadModReferralsCube tmrcube on m.UserID = tmrcube.UserID
					INNER JOIN #Sites s on tmrcube.SiteID = s.SiteID
			 WHERE	tmrcube.Date >= @startdate
			   AND	tmrcube.Date < @enddate 
			   AND  tmrcube.Status IS NULL 
			 GROUP	BY tmrcube.UserID, tmrcube.SiteID
	),
	CollapsedThreadModReferralsStats (UserID, SiteID, PostsRefered) AS
	(
		SELECT	t.ModeratorID, 
				t.SiteID, 
				SUM(t.[Count])
		  from	#ModStats
				INNER JOIN SummedThreadModReferralsStats t ON #ModStats.UserID = t.ModeratorID AND #ModStats.SiteID = t.SiteID
		 group	by t.ModeratorID, t.SiteID
	)
	UPDATE #ModStats
	   SET	PostsRefered = s.PostsRefered
	  FROM	#ModStats 
			INNER JOIN CollapsedThreadModReferralsStats s ON #ModStats.UserID = s.UserID AND #ModStats.SiteID = s.SiteID;

	WITH SummedArticleModStats (ModeratorID, SiteID, Status, [Count]) AS 
	(
			SELECT	amcube.UserID, amcube.SiteID, amcube.Status, SUM([count])
			  FROM	#Moderators m
					INNER JOIN dbo.ArticleModCube amcube on m.UserID = amcube.UserID
					INNER JOIN #Sites s on amcube.SiteID = s.SiteID
			 WHERE	amcube.Date >= @startdate
			   AND	amcube.Date < @enddate
			   AND	amcube.Status IS NOT NULL 
			 GROUP	BY amcube.UserID, amcube.SiteID, amcube.Status
	),
	CollapsedArticleModStats (UserID, SiteID, ArticlePassed, ArticleFailed, ArticleTotal) AS
	(
		SELECT	a.ModeratorID, 
				a.SiteID, 
				SUM(CASE a.Status WHEN 3 THEN a.[Count] END),
				SUM(CASE a.Status WHEN 4 THEN a.[Count] END),
				SUM(CASE a.Status WHEN 3 THEN a.[Count] WHEN 4 THEN a.[Count] END)
		  from #ModStats
				INNER JOIN SummedArticleModStats a ON #ModStats.UserID = a.ModeratorID AND #ModStats.SiteID = a.SiteID
		 group by a.ModeratorID, a.SiteID
	)
	UPDATE	#ModStats
	   SET	ArticlePassed = s.ArticlePassed,
			ArticleFailed = s.ArticleFailed,
			ArticleTotal = s.ArticleTotal
	  FROM	#ModStats
			INNER JOIN CollapsedArticleModStats s ON #ModStats.UserID = s.UserID AND #ModStats.SiteID = s.SiteID;;

	WITH SummedArticleModReferralsStats (ModeratorID, SiteID, [Count]) AS 
	(
			SELECT	amcube.UserID, amcube.SiteID, SUM([count])
			  FROM	#Moderators m
					INNER JOIN dbo.ArticleModReferralsCube amcube on m.UserID = amcube.UserID
					INNER JOIN #Sites s on amcube.SiteID = s.SiteID
			 WHERE	amcube.Date >= @startdate
			   AND	amcube.Date < @enddate
			   AND	amcube.Status IS NOT NULL 
			 GROUP	BY amcube.UserID, amcube.SiteID, amcube.Status
	),
	CollapsedArticleModReferralsStats (UserID, SiteID, ArticleReferred) AS
	(
		SELECT	a.ModeratorID, 
				a.SiteID, 
				SUM(a.[Count])
		  from #ModStats
				INNER JOIN SummedArticleModReferralsStats a ON #ModStats.UserID = a.ModeratorID AND #ModStats.SiteID = a.SiteID
		 group by a.ModeratorID, a.SiteID
	)
	UPDATE	#ModStats
	   SET	ArticleReferred = s.ArticleReferred
	  FROM	#ModStats
			INNER JOIN CollapsedArticleModReferralsStats s ON #ModStats.UserID = s.UserID AND #ModStats.SiteID = s.SiteID;;

	WITH SummedNicknameModStats (ModeratorID, SiteID, Status, [Count]) AS 
	(
			SELECT	nnmcube.UserID, nnmcube.SiteID, nnmcube.Status, SUM([count])
			  FROM	#Moderators m
					INNER JOIN dbo.NicknameModCube nnmcube on m.UserID = nnmcube.UserID
					INNER JOIN #Sites s on nnmcube.SiteID = s.SiteID
			 WHERE	nnmcube.Date >= @startdate
			   AND	nnmcube.Date < @enddate
			   AND	nnmcube.Status IS NOT NULL 
			 GROUP	BY nnmcube.UserID, nnmcube.SiteID, nnmcube.Status
	),
	CollapsedNicknameModStats (UserID, SiteID, NicknamePassed, NicknameFailed, NicknameTotal) AS
	(
		SELECT	a.ModeratorID, 
				a.SiteID, 
				SUM(CASE a.Status WHEN 3 THEN a.[Count] END),
				SUM(CASE a.Status WHEN 4 THEN a.[Count] END),
				SUM(CASE a.Status WHEN 3 THEN a.[Count] WHEN 4 THEN a.[Count] END)
		  from #ModStats
				INNER JOIN SummedNicknameModStats a ON #ModStats.UserID = a.ModeratorID AND #ModStats.SiteID = a.SiteID
		 group by a.ModeratorID, a.SiteID
	)
	UPDATE #ModStats
	   SET	NicknamePassed = s.NicknamePassed,
			NicknameFailed = s.NicknameFailed,
			NicknameTotal = s.NicknameTotal
	  FROM	#ModStats
			INNER JOIN CollapsedNicknameModStats s ON #ModStats.UserID = s.UserID AND #ModStats.SiteID = s.SiteID;;

	SELECT	UserName, 
			SiteName AS 'ShortName',
			ISNULL(PostsPassed, 0) AS 'PostsPassed',
			ISNULL(PostsFailed, 0) AS 'PostsFailed',
			ISNULL(PostsRefered, 0) AS 'PostsRefered',
			ISNULL(PostsTotal, 0) AS 'PostsTotal',
			ISNULL(ArticlePassed, 0) AS 'ArticlePassed',
			ISNULL(ArticleFailed, 0) AS 'ArticleFailed',
			ISNULL(ArticleReferred, 0) AS 'ArticleRefered',
			ISNULL(ArticleTotal, 0) AS 'ArticleTotal',
			ISNULL(NicknamePassed, 0) AS 'NicknamePassed',
			ISNULL(NicknameFailed, 0) AS 'NicknameFailed',
			ISNULL(NicknameTotal, 0) AS 'NicknameTotal'
	  FROM	#ModStats
     ORDER BY UserName ASC

-- getmoderatorsstats2 @siteids = '54', @userids = '5315600, 3002916', @startdate = '2007-04-01', @enddate = '2008-03-17'
-- getmoderatorsstats '10,12,15', '1097995, 1079371262', '2001/01/01', '2002/01/01'