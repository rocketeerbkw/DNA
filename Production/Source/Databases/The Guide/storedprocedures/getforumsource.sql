Create Procedure getforumsource @forumid int, @threadid int, @currentsiteid int = 0
As
if @threadid = 0
BEGIN
	SELECT TOP 1 'Type' = CASE
							WHEN f.JournalOwner > 0 THEN 0
							WHEN u1.UserID > 0 THEN 2
							WHEN r.ReviewForumID IS NOT NULL THEN 3
							WHEN u2.UserID IS NOT NULL THEN 4
							WHEN c.ClubId IS NOT NULL THEN 5	-- article from club page
							WHEN c1.ClubID IS NOT NULL THEN 6	-- ClubForum
							WHEN c2.ClubID IS NOT NULL THEN 7	-- Journal
							when h.nodeid is not null then 8	-- noticeboard
							when cf.url is not null then 9 -- acs forum
							ELSE 1
						END,
	JournalOwner, 
	'JournalUserName'		= u.UserName,
	'JournalFirstNames'		= U.FIRSTNAMES, 
	'JournalLastName'		= U.LASTNAME, 
	'JournalArea'			= U.AREA, 
	'JournalStatus'			= U.STATUS, 
	'JournalTaxonomyNode'	= U.TAXONOMYNODE, 
	'JournalJournal'		= J.ForumID, 
	'JournalActive'			= U.ACTIVE,
	'JournalSiteSuffix'		= P.SITESUFFIX,
	'JournalTitle'			= P.TITLE,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.UserID			ELSE u2.UserID END		as UserID, 
	CASE WHEN u1.UserID IS NOT NULL THEN u1.UserName		ELSE u2.UserName END	as UserName, 
	CASE WHEN u1.UserID IS NOT NULL THEN u1.FirstNames		ELSE u2.FIRSTNAMES END	as FirstNames,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.LastName		ELSE u2.LASTNAME END	as LastName,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.Area			ELSE u2.Area END		as Area,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.Status			ELSE u2.Status END		as Status,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.TaxonomyNode	ELSE u2.TaxonomyNode END as TaxonomyNode,
	CASE WHEN u1.UserID IS NOT NULL THEN j1.ForumID			ELSE j2.ForumID END		as Journal,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.Active			ELSE u2.Active END		as Active,
	CASE WHEN u1.UserID IS NOT NULL THEN p1.SiteSuffix		ELSE p2.SiteSuffix END	as SiteSuffix,
	CASE WHEN u1.UserID IS NOT NULL THEN p1.Title			ELSE p2.Title END		as Title,
	CASE WHEN g.h2g2ID IS NOT NULL THEN g.h2g2ID ELSE dbo.udf_generateH2G2ID(m1.EntryID) END as h2g2ID,
	CASE WHEN g.Hidden IS NULL THEN g.Subject ELSE 'Hidden' END as Subject,
	g.Status 'ArticleStatus',
	f.SiteID,
	f.ForumID,
	f.AlertInstantly,
	r.ReviewForumID, 
	'ReviewForumName' = r.ForumName, 
	CASE 
		WHEN c.ClubId IS NOT NULL THEN c.ClubID
		WHEN c1.ClubId IS NOT NULL THEN c1.ClubID
		WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
		ELSE NULL
	END as ClubID,
	CASE 
		WHEN c.ClubId IS NOT NULL THEN ( CASE WHEN ClubArticle.Hidden IS NULL THEN c.Name ELSE 'Hidden' END )
		WHEN c1.ClubId IS NOT NULL THEN ( CASE WHEN ClubArticle.Hidden IS NULL THEN c1.Name ELSE 'Hidden' END )
		WHEN c2.ClubID IS NOT NULL THEN ( CASE WHEN ClubArticle.Hidden IS NULL THEN c2.Name ELSE 'Hidden' END )
		ELSE NULL
	END as ClubName, 
	CASE 
		WHEN c.ClubId IS NOT NULL THEN c.h2g2Id
		WHEN c1.ClubId IS NOT NULL THEN c1.h2g2Id
		WHEN c2.ClubId IS NOT NULL THEN c2.h2g2Id
		ELSE NULL
	END as ClubH2G2ID,
	ClubArticle.Hidden AS ClubHiddenStatus,
	ClubArticle.Status	AS ClubArticleStatus,
	CF.URL
	
	FROM Forums f WITH(NOLOCK)
	LEFT JOIN GuideEntries g WITH(NOLOCK) ON g.ForumID = f.ForumID
	LEFT JOIN Mastheads m WITH(NOLOCK) ON g.EntryID = m.EntryID
	LEFT JOIN Users u1 WITH(NOLOCK) ON m.UserID = u1.UserID
	LEFT JOIN Preferences p1 WITH(NOLOCK) on p1.UserID = u1.UserID AND p1.SiteID = @currentsiteid
	LEFT JOIN Users u WITH(NOLOCK) ON u.UserID = f.JournalOwner
	LEFT JOIN Mastheads m1 WITH(NOLOCK) ON u.UserID = m1.UserID AND m1.SiteID = f.SiteID
	LEFT JOIN Preferences p WITH(NOLOCK) on p.UserID = u.UserID AND p.SiteID = @currentsiteid
	LEFT JOIN ReviewForums r WITH(NOLOCK) ON r.h2g2ID = g.h2g2ID
	LEFT JOIN Teams t WITH(NOLOCK) ON t.ForumID = f.ForumID
	LEFT JOIN UserTeams ut WITH(NOLOCK) ON ut.TeamID = t.TeamID
	LEFT JOIN Users u2 WITH(NOLOCK) ON u2.UserID = ut.UserID
	LEFT JOIN Preferences p2 WITH(NOLOCK) on p2.UserID = u2.UserID AND p2.SiteID = @currentsiteid
	LEFT JOIN Clubs c WITH(NOLOCK) ON c.h2g2id = g.h2g2id
	LEFT JOIN Clubs c1 WITH(NOLOCK) ON f.ForumID = c1.ClubForum
	LEFT JOIN Clubs c2 WITH(NOLOCK) ON f.ForumID = c2.Journal
	left join hierarchy h with(nolock) on h.h2g2id = g.h2g2id and h.type = 3
	LEFT JOIN Journals J with(nolock) on j.userid = u.userid and j.siteid = @currentsiteid
	LEFT JOIN Journals J1 with(nolock) on j1.userid = u1.userid and j1.siteid = @currentsiteid
	LEFT JOIN Journals J2 with(nolock) on j2.userid = u2.userid and j2.siteid = @currentsiteid
	LEFT JOIN GuideEntries clubarticle WITH(NOLOCK) ON clubarticle.H2G2ID = ISNULL(c.H2G2Id, ISNULL(c1.H2G2Id,c2.H2G2Id) )
	LEFT JOIN CommentForums CF WITH (NOLOCK) on CF.ForumID = F.ForumID
	WHERE f.ForumID = @forumid
END
ELSE
BEGIN

	SELECT TOP 1 'Type' = CASE
							WHEN f.JournalOwner > 0 THEN 0
							WHEN u1.UserID > 0 THEN 2
							WHEN r.ReviewForumID IS NOT NULL THEN 3
							WHEN u2.UserID IS NOT NULL THEN 4
							WHEN c.ClubId IS NOT NULL THEN 5
							WHEN c1.ClubID IS NOT NULL THEN 6
							WHEN c2.ClubID IS NOT NULL THEN 7
							when h.nodeid is not null then 8
							when cf.url is not null then 9 -- acs forum
							ELSE 1
						END,
	JournalOwner, 
	'JournalUserName'		= u.UserName,
	'JournalFirstNames'		= U.FIRSTNAMES, 
	'JournalLastName'		= U.LASTNAME, 
	'JournalArea'			= U.AREA, 
	'JournalStatus'			= U.STATUS, 
	'JournalTaxonomyNode'	= U.TAXONOMYNODE, 
	'JournalJournal'		= J.ForumID, 
	'JournalActive'			= U.ACTIVE,
	'JournalSiteSuffix'		= P.SITESUFFIX,
	'JournalTitle'			= P.TITLE,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.UserID			ELSE u2.UserID END		as UserID, 
	CASE WHEN u1.UserID IS NOT NULL THEN u1.UserName		ELSE u2.UserName END	as UserName, 
	CASE WHEN u1.UserID IS NOT NULL THEN u1.FirstNames		ELSE u2.FIRSTNAMES END	as FirstNames,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.LastName		ELSE u2.LASTNAME END	as LastName,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.Area			ELSE u2.Area END		as Area,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.Status			ELSE u2.Status END		as Status,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.TaxonomyNode	ELSE u2.TaxonomyNode END as TaxonomyNode,
	CASE WHEN u1.UserID IS NOT NULL THEN j1.ForumID			ELSE j2.ForumID END		as Journal,
	CASE WHEN u1.UserID IS NOT NULL THEN u1.Active			ELSE u2.Active END		as Active,
	CASE WHEN u1.UserID IS NOT NULL THEN p1.SiteSuffix		ELSE p2.SiteSuffix END	as SiteSuffix,
	CASE WHEN u1.UserID IS NOT NULL THEN p1.Title			ELSE p2.Title END		as Title,
	CASE WHEN g.h2g2ID IS NOT NULL THEN g.h2g2ID ELSE dbo.udf_generateH2G2ID(m1.EntryID) END as h2g2ID,
	CASE WHEN g.Hidden IS NULL THEN g.Subject ELSE 'Hidden' END as Subject,
	g.Status 'ArticleStatus',
	f.SiteID,
	f.ForumID,
	f.AlertInstantly, 
	r.ReviewForumID, 
	'ReviewForumName' = r.ForumName, 
	CASE 
		WHEN c.ClubId IS NOT NULL THEN c.ClubID
		WHEN c1.ClubId IS NOT NULL THEN c1.ClubID
		WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
		ELSE NULL
	END as ClubID,
	CASE 
		WHEN c.ClubId IS NOT NULL THEN c.Name
		WHEN c1.ClubId IS NOT NULL THEN c1.Name
		WHEN c2.ClubID IS NOT NULL THEN c2.Name
		ELSE NULL
	END as ClubName,
	CASE 
		WHEN c.ClubId IS NOT NULL THEN c.h2g2Id
		WHEN c1.ClubId IS NOT NULL THEN c1.h2g2Id
		WHEN c2.ClubId IS NOT NULL THEN c2.h2g2Id
		ELSE NULL
	END as ClubH2G2ID,
	ClubArticle.Hidden AS ClubHiddenStatus,
	ClubArticle.Status AS ClubArticleStatus,
	CF.URL
	
	FROM Forums f WITH(NOLOCK)
	LEFT JOIN GuideEntries g WITH(NOLOCK) ON g.ForumID = f.ForumID
	LEFT JOIN Mastheads m WITH(NOLOCK) ON g.EntryID = m.EntryID
	LEFT JOIN Users u1 WITH(NOLOCK) ON m.UserID = u1.UserID
	LEFT JOIN Preferences p1 WITH(NOLOCK) on p1.UserID = u1.UserID AND p1.SiteID = @currentsiteid
	LEFT JOIN Users u WITH(NOLOCK) ON u.UserID = f.JournalOwner
	LEFT JOIN Mastheads m1 WITH(NOLOCK) ON u.UserID = m1.UserID AND m1.SiteID = f.SiteID
	LEFT JOIN Preferences p WITH(NOLOCK) on p.UserID = u.UserID AND p.SiteID = @currentsiteid
	LEFT JOIN ReviewForums r WITH(NOLOCK) ON r.h2g2ID = g.h2g2ID
	LEFT JOIN Teams t WITH(NOLOCK) ON t.ForumID = f.ForumID
	LEFT JOIN UserTeams ut WITH(NOLOCK) ON ut.TeamID = t.TeamID
	LEFT JOIN Users u2 WITH(NOLOCK) ON u2.UserID = ut.UserID
	LEFT JOIN Preferences p2 WITH(NOLOCK) on p2.UserID = u2.UserID AND p2.SiteID = @currentsiteid
	LEFT JOIN Clubs c WITH(NOLOCK) ON c.h2g2id = g.h2g2id
	LEFT JOIN Clubs c1 WITH(NOLOCK) ON f.ForumID = c1.ClubForum
	LEFT JOIN Clubs c2 WITH(NOLOCK) ON f.ForumID = c2.Journal
	left join hierarchy h with(nolock) on h.h2g2id = g.h2g2id and h.type = 3
	LEFT JOIN Journals J with(nolock) on j.userid = u.userid and j.siteid = @currentsiteid
	LEFT JOIN Journals J1 with(nolock) on j1.userid = u1.userid and j1.siteid = @currentsiteid
	LEFT JOIN Journals J2 with(nolock) on j2.userid = u2.userid and j2.siteid = @currentsiteid
	LEFT JOIN GuideEntries clubarticle WITH(NOLOCK) ON clubarticle.H2G2ID = ISNULL(c.H2G2Id, ISNULL(c1.H2G2Id,c2.H2G2Id) )
	LEFT JOIN CommentForums CF WITH(NOLOCK) on CF.ForumID = F.ForumID
	WHERE f.ForumID IN (SELECT ForumID FROM Threads WITH(NOLOCK) WHERE ThreadID = @threadid)
END
	return (0)