create procedure getclublinks @clubid int, @linkgroup varchar(255), @showprivate int
as

declare @linkcount int
select @linkcount = COUNT(*) FROM Links WHERE SourceType = 'club' AND SourceID = @clubid AND Type = @linkgroup AND Private IN (0, @showprivate)

declare @clubname varchar(255)
declare @siteid int

select @clubname = Name, @siteid = SiteID FROM Clubs WHERE ClubID = @clubid

select 'linkcount' = @linkcount, 'ClubName' = @clubname, 'ClubID' = @clubid, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, 
	l.Type, l.DestinationType, l.DestinationId, l.LinkId, l.TeamId, l.Relationship,	l.Hidden, 
	l.DateLinked, 'Title' = case when l.Title is null then g.Subject else l.Title end, 
	l.LinkDescription, 'URL' = NULL, 'LastUpdated'= g.LastUpdated,
	'AuthorID' = u.UserID, 'AuthorName'	= u.UserName,'AuthorFirstNames'	= u.FirstNames,'AuthorLastName'	= u.LastName,'AuthorArea' = u.Area,'AuthorStatus'= u.Status,'AuthorTaxonomyNode'= u.TaxonomyNode,'AuthorJournal'= J1.ForumID,'AuthorActive'= u.Active,'AuthorSiteSuffix'	= p.SiteSuffix,'AuthorTitle'= p.Title,
	'SubmitterID' = u2.UserID, 'SubmitterName' = u2.UserName, 'SubmitterFirstNames'	= u2.FirstNames, 'SubmitterLastName' = u2.LastName, 'SubmitterArea' = u2.Area, 'SubmitterStatus'= u2.Status, 'SubmitterTaxonomyNode'= u2.TaxonomyNode,'SubmitterJournal'= J2.ForumID, 'SubmitterActive'= u2.Active, 'SubmitterSiteSuffix' = p2.SiteSuffix, 'SubmitterTitle'= p2.Title
	from Links l 
	INNER JOIN GuideEntries g ON l.DestinationType = 'article' AND l.DestinationID = g.h2g2ID
	INNER JOIN Users u ON u.UserID = g.Editor
	LEFT JOIN Preferences p on p.UserID = u.UserID AND p.SiteID = g.SiteID
	LEFT JOIN Users u2 ON u2.UserID = l.SubmitterID
	LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @siteid
	INNER JOIN Journals J1 on J1.UserID = U.UserID and J1.SiteID = @siteid
	LEFT JOIN Journals J2 on J2.UserID = U2.UserID and J2.SiteID = @siteid
where l.SourceType = 'club' AND l.SourceID = @clubid /* AND l.Type = @linkgroup */ 
AND l.private IN (0, @showprivate) AND g.Status != 7 AND g.Hidden IS NULL
UNION
select 'linkcount' = @linkcount, 'ClubName' = @clubname, 'ClubID' = @clubid, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, 
	l.Type, l.DestinationType, l.DestinationId, l.LinkId, l.TeamId, l.Relationship,	l.Hidden, 
	l.DateLinked, 'Title' = case when l.Title is null then h.DisplayName else l.Title end, 
	l.LinkDescription, 'URL' = NULL,
	'AuthorID'			= NULL,
	'AuthorName'		= NULL, 
	'AuthorFirstNames'	= NULL, 
	'AuthorLastName'	= NULL, 
	'AuthorArea'		= NULL, 
	'AuthorStatus'		= NULL, 
	'AuthorTaxonomyNode'= NULL, 
	'AuthorJournal'		= NULL, 
	'AuthorActive'		= NULL, 
	'AuthorSiteSuffix'	= NULL,
	'AuthorTitle'		= NULL,
	'LastUpdated'		= NULL,
	'SubmitterID' = u2.UserID, 'SubmitterName' = u2.UserName, 'SubmitterFirstNames'	= u2.FirstNames, 'SubmitterLastName' = u2.LastName, 'SubmitterArea' = u2.Area, 'SubmitterStatus'= u2.Status, 'SubmitterTaxonomyNode'= u2.TaxonomyNode,'SubmitterJournal'= u2.Journal, 'SubmitterActive'= u2.Active, 'SubmitterSiteSuffix' = p2.SiteSuffix, 'SubmitterTitle'= p2.Title
	from Links l 
	INNER JOIN Hierarchy h ON l.DestinationType = 'category' AND l.DestinationID = h.NodeID
	LEFT JOIN Users u2 ON u2.UserID = l.SubmitterID
	LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @siteid
where l.SourceType = 'club' AND l.SourceID = @clubid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'ClubName' = @clubname, 'ClubID' = @clubid, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, 
	l.Type, l.DestinationType, l.DestinationId, l.LinkId, l.TeamId, l.Relationship,	l.Hidden, 
	l.DateLinked, 'Title' = case when l.Title is null then c.Name else l.Title end, 
	l.LinkDescription, 'URL' = NULL,
	'AuthorID'			= NULL,
	'AuthorName'		= NULL, 
	'AuthorFirstNames'	= NULL, 
	'AuthorLastName'	= NULL, 
	'AuthorArea'		= NULL, 
	'AuthorStatus'		= NULL, 
	'AuthorTaxonomyNode'= NULL, 
	'AuthorJournal'		= NULL, 
	'AuthorActive'		= NULL, 
	'AuthorSiteSuffix'	= NULL,
	'AuthorTitle'		= NULL,
	'LastUpdated'		= NULL,
	'SubmitterID' = u2.UserID, 'SubmitterName' = u2.UserName, 'SubmitterFirstNames'	= u2.FirstNames, 'SubmitterLastName' = u2.LastName, 'SubmitterArea' = u2.Area, 'SubmitterStatus'= u2.Status, 'SubmitterTaxonomyNode'= u2.TaxonomyNode,'SubmitterJournal'= u2.Journal, 'SubmitterActive'= u2.Active, 'SubmitterSiteSuffix' = p2.SiteSuffix, 'SubmitterTitle'= p2.Title
	from Links l 
	INNER JOIN Clubs c ON l.DestinationType = 'club' AND l.DestinationID = c.ClubID
	LEFT JOIN Users u2 ON u2.UserID = l.SubmitterID
	LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @siteid
where l.SourceType = 'club' AND l.SourceID = @clubid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'ClubName' = @clubname, 'ClubID' = @clubid, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, 
	l.Type, l.DestinationType, l.DestinationId, l.LinkId, l.TeamId, l.Relationship,	l.Hidden, 
	l.DateLinked, 'Title' = case when l.Title is null then r.ForumName else l.Title end, 
	l.LinkDescription, 'URL' = NULL,
	'AuthorID'			= NULL,
	'AuthorName'		= NULL, 
	'AuthorFirstNames'	= NULL, 
	'AuthorLastName'	= NULL, 
	'AuthorArea'		= NULL, 
	'AuthorStatus'		= NULL, 
	'AuthorTaxonomyNode'= NULL, 
	'AuthorJournal'		= NULL, 
	'AuthorActive'		= NULL, 
	'AuthorSiteSuffix'	= NULL,
	'AuthorTitle'		= NULL,
	'LastUpdated'		= NULL,
	'SubmitterID' = u2.UserID, 'SubmitterName' = u2.UserName, 'SubmitterFirstNames'	= u2.FirstNames, 'SubmitterLastName' = u2.LastName, 'SubmitterArea' = u2.Area, 'SubmitterStatus'= u2.Status, 'SubmitterTaxonomyNode'= u2.TaxonomyNode,'SubmitterJournal'= u2.Journal, 'SubmitterActive'= u2.Active, 'SubmitterSiteSuffix' = p2.SiteSuffix, 'SubmitterTitle'= p2.Title
	from Links l 
	INNER JOIN ReviewForums r ON l.DestinationType = 'reviewforum' AND l.DestinationID = r.ReviewForumID
	LEFT JOIN Users u2 ON u2.UserID = l.SubmitterID
	LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @siteid
where l.SourceType = 'club' AND l.SourceID = @clubid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'ClubName' = @clubname, 'ClubID' = @clubid, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, 
	l.Type, l.DestinationType, l.DestinationId, l.LinkId, l.TeamId, l.Relationship,	l.Hidden, 
	l.DateLinked, 'Title' = case when l.Title is null then u.UserName else l.Title end, 
	l.LinkDescription, 'URL' = NULL,
	'AuthorID'			= NULL,
	'AuthorName'		= NULL, 
	'AuthorFirstNames'	= NULL, 
	'AuthorLastName'	= NULL, 
	'AuthorArea'		= NULL, 
	'AuthorStatus'		= NULL, 
	'AuthorTaxonomyNode'= NULL, 
	'AuthorJournal'		= NULL, 
	'AuthorActive'		= NULL, 
	'AuthorSiteSuffix'	= NULL,
	'AuthorTitle'		= NULL,
	'LastUpdated'		= NULL,
	'SubmitterID' = u2.UserID, 'SubmitterName' = u2.UserName, 'SubmitterFirstNames'	= u2.FirstNames, 'SubmitterLastName' = u2.LastName, 'SubmitterArea' = u2.Area, 'SubmitterStatus'= u2.Status, 'SubmitterTaxonomyNode'= u2.TaxonomyNode,'SubmitterJournal'= u2.Journal, 'SubmitterActive'= u2.Active, 'SubmitterSiteSuffix' = p2.SiteSuffix, 'SubmitterTitle'= p2.Title	
	from Links l 
	INNER JOIN Users u ON l.DestinationType = 'userpage' AND l.DestinationID = u.UserID
	LEFT JOIN Users u2 ON u2.UserID = l.SubmitterID
	LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @siteid
where l.SourceType = 'club' AND l.SourceID = @clubid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'ClubName' = @clubname, 'ClubID' = @clubid, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, 
	l.Type, l.DestinationType, l.DestinationId, l.LinkId, l.TeamId, l.Relationship,	l.Hidden, 
	l.DateLinked, l.Title, l.LinkDescription, eu.URL,
	'AuthorID'			= NULL,
	'AuthorName'		= NULL, 
	'AuthorFirstNames'	= NULL, 
	'AuthorLastName'	= NULL, 
	'AuthorArea'		= NULL, 
	'AuthorStatus'		= NULL, 
	'AuthorTaxonomyNode'= NULL, 
	'AuthorJournal'		= NULL, 
	'AuthorActive'		= NULL, 
	'AuthorSiteSuffix'	= NULL,
	'AuthorTitle'		= NULL,
	'LastUpdated'		= NULL,
	'SubmitterID' = u2.UserID, 'SubmitterName' = u2.UserName, 'SubmitterFirstNames'	= u2.FirstNames, 'SubmitterLastName' = u2.LastName, 'SubmitterArea' = u2.Area, 'SubmitterStatus'= u2.Status, 'SubmitterTaxonomyNode'= u2.TaxonomyNode,'SubmitterJournal'= u2.Journal, 'SubmitterActive'= u2.Active, 'SubmitterSiteSuffix' = p2.SiteSuffix, 'SubmitterTitle'= p2.Title	
	from Links l
	INNER JOIN ExternalURLs eu ON l.DestinationType = 'external' AND l.DestinationID = eu.URLID
	LEFT JOIN Users u2 ON u2.UserID = l.SubmitterID
	LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @siteid
where l.SourceType = 'club' AND l.SourceID = @clubid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
order by selected DESC, l.Type, DateLinked DESC