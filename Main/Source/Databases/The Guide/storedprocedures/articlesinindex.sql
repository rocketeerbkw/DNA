CREATE Procedure articlesinindex @char varchar(4), 
									@siteid int,
                                    @showapproved int = 1,
                                    @showsubmitted int = 1,
                                    @showunapproved int = 1,
									@type1 int = NULL,
									@type2 int = NULL,
									@type3 int = NULL,
									@type4 int = NULL,
									@type5 int = NULL,
									@type6 int = NULL,
									@type7 int = NULL,
									@type8 int = NULL,
									@type9 int = NULL,
									@group varchar(32) = NULL,
									@orderby int = NULL
									/*
										OrderBy values...
										NULL OR None of the below = Sort by Subject
										1 = Sort by Date Created
										2 = Sort By Last Updated
									*/

As

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF (@char <> '' AND @type1 IS NULL AND @group IS NULL)
BEGIN
	-- Performance tuning showed that this was the most common form of use
	-- so it's been specially coded

	WITH Articles AS
	(
		SELECT	a.EntryID, a.Subject, a.Status, a.UserID, a.SortSubject, 
				g.DateCreated, g.LastUpdated, g.h2g2id, g.extrainfo
			FROM ArticleIndex a
			INNER JOIN GuideEntries g ON a.EntryID = g.EntryID AND g.SiteID = @siteid
			WHERE a.IndexChar = @char
				AND a.SiteID = @siteid
				AND
				(	(a.Status = 1 AND @showapproved = 1) OR
					(a.Status IN (4, 5, 6, 8, 11, 12, 13) AND @showsubmitted = 1 ) OR
					(a.Status = 3 AND @showunapproved = 1)	)
	),
	ArticlesWithSortCols AS
	(
		SELECT	a.*,
				CASE WHEN @orderby=1 THEN a.DateCreated END AS DateCreated_Sort,
				CASE WHEN @orderby=2 THEN a.LastUpdated END AS LastUpdated_Sort,
				CASE WHEN ISNULL(@orderby,0)=0 THEN a.SortSubject END AS SortSubject_Sort
			FROM Articles a
	)
	SELECT 	'Count' = (select count(*) FROM Articles), 
			s.Subject, 
			s.EntryID, 
			s.h2g2ID, 
			s.Status, 
			s.UserID, 
			s.extrainfo, 
			s.DateCreated, 
			s.LastUpdated, 
			siuidm.IdentityUserID, 
			'IdentityUserName' = u.LoginName, 
			u.UserName, 
			u.FirstNames, 
			u.LastName, 
			u.Area, 
			u.Status, 
			u.TaxonomyNode, 
			u.Active
		FROM ArticlesWithSortCols s
		LEFT JOIN Users u ON u.UserID = s.UserID
		LEFT JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
		ORDER BY s.DateCreated_Sort, s.LastUpdated_Sort DESC, s.SortSubject_Sort

	RETURN 0;
END
ELSE
BEGIN
	-- This is the general case that caters for all other ways of calling the SP

	WITH Articles AS
	(
		SELECT	a.EntryID, a.Subject, a.Status, a.UserID, a.SortSubject, g.DateCreated,
				g.LastUpdated, g.h2g2id, g.extrainfo
			FROM ArticleIndex a
			INNER JOIN GuideEntries g ON a.EntryID = g.EntryID AND g.SiteID = @siteid
			WHERE (a.IndexChar = @char OR @char = '')
				AND a.SiteID = @siteid
				AND
				(	(a.Status = 1 AND @showapproved = 1) OR
					(a.Status IN (4, 5, 6, 8, 11, 12, 13) AND @showsubmitted = 1 ) OR
					(a.Status = 3 AND @showunapproved = 1)
				)
				AND
				(
					@Type1 IS NULL OR 
					g.Type IN (@Type1,@Type2,@Type3,@Type4,@Type5,@Type6,@Type7,@Type8,@Type9)
				)
				AND
				(
					@group IS NULL OR
					g.Editor IN
					( SELECT gm.UserID FROM GroupMembers gm WITH(NOLOCK) WHERE gm.SiteID = @siteid AND gm.GroupID IN
						( SELECT m.GroupID FROM Groups m WITH(NOLOCK) WHERE m.Name = @group) )
				)
	),
	ArticlesWithSortCols AS
	(
		SELECT	a.*,
				CASE WHEN @orderby=1 THEN a.DateCreated END DateCreated_Sort,
				CASE WHEN @orderby=2 THEN a.LastUpdated END LastUpdated_Sort,
				CASE WHEN ISNULL(@orderby,0)=0 THEN a.SortSubject END SortSubject_Sort
			FROM Articles a
	)
	SELECT 	'Count' = (select count(*) FROM Articles), 
			s.Subject, 
			s.EntryID, 
			s.h2g2ID, 
			s.Status, 
			s.UserID, 
			s.extrainfo, 
			s.DateCreated, 
			s.LastUpdated, 
			siuidm.IdentityUserID, 
			'IdentityUserName' = u.LoginName, 
			u.UserName, 
			u.FirstNames, 
			u.LastName, 
			u.Area, 
			u.Status, 
			u.TaxonomyNode, 
			u.Active
		FROM ArticlesWithSortCols s
		LEFT JOIN Users u ON u.UserID = s.UserID
		LEFT JOIN SignInUserIDMapping siuidm ON u.UserID = siuidm.DnaUserID
		ORDER BY s.DateCreated_Sort, s.LastUpdated_Sort DESC, s.SortSubject_Sort

	RETURN 0;
END
