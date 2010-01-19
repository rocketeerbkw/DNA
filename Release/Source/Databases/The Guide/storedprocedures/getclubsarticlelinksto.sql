CREATE PROCEDURE getclubsarticlelinksto @articleid int
as
select	l.linkid, 
		l.relationship, 
		l.sourceid as clubid,
		l.destinationid as articleid,
		c.name as title,
		'AuthorID'			= u.UserID,
		'AuthorName'		= u.UserName,
		'AuthorFirstNames'	= u.FirstNames, 
		'AuthorLastName'	= u.LastName, 
		'AuthorArea'		= u.Area, 
		'AuthorStatus'		= u.Status, 
		'AuthorTaxonomyNode'= u.TaxonomyNode, 
		'AuthorJournal'		= J.ForumID, 
		'AuthorActive'		= u.Active, 
		'AuthorSiteSuffix'	= p.SiteSuffix,
		'AuthorTitle'		= p.Title
		from links l WITH(NOLOCK)
		inner join clubs c WITH(NOLOCK) on c.clubid = l.sourceid
		inner join guideentries g WITH(NOLOCK) on g.Entryid = c.h2g2id/10
		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = g.Editor
		LEFT JOIN Preferences p WITH(NOLOCK) on p.UserID = u.UserID AND p.SiteID = g.SiteID 
		INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID AND J.SiteID = g.SiteID
where sourcetype='club'
and destinationtype='article'
and destinationid=@articleid