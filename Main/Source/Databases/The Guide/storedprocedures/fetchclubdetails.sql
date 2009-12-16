/*
 Gets all the details about a club given the id
*/

/*
PLEASE NOTE:	This looks odd, but splitting the sp into two distinct selects
				makes is easier for the database to choose appropriate
				indexes, optimising performance. Please don't refactor into
				a single select statement.
*/

create procedure fetchclubdetails @clubid int = NULL, @h2g2id int = NULL
as

DECLARE @lastupdated DATETIME
IF @clubid IS NOT NULL
BEGIN

select	C.ClubID, C.Name, C.OwnerTeam, C.MemberTeam,
		C.ClubForum, C.Status, C.Journal, C.SiteID,
		C.h2g2ID, C.ClubForumType, 
		'DateCreated' = ISNULL(C.DateCreated,G.DateCreated),
		'ClubLastUpdated' = C.LastUpdated, 
		'ArticleLastUpdated' = G.LastUpdated,
		'ClubForumLastUpdated' = journallastupdated.lastupdated,
		 G.Hidden,
		'GuideStatus' = G.status,
		'bodytext'= G.text,
		G.Type
from Clubs C
INNER JOIN GuideEntries G ON G.h2g2id = C.h2g2id
LEFT JOIN (
	select forumid, MAX(lastupdated) 'lastupdated' FROM forumlastupdated  f GROUP BY forumid
) AS journallastupdated ON journallastupdated.forumid = C.journal
where	(C.ClubID = @clubid)
		
END
ELSE
BEGIN
select	C.ClubID, C.Name, C.OwnerTeam, C.MemberTeam,
		C.ClubForum, C.Status, C.Journal, C.SiteID,
		C.h2g2ID, C.ClubForumType, 
		'DateCreated' = ISNULL(C.DateCreated,G.DateCreated), 
		'ClubLastUpdated' = C.LastUpdated,
		'ArticleLastUpdated' = G.LastUpdated,
		'ClubForumLastUpdated' =  journallastupdated.lastupdated, 
		G.Hidden,
		'GuideStatus' = G.status,
		'bodytext'= G.text,
		G.Type
from Clubs C
INNER JOIN GuideEntries G ON G.h2g2Id = c.h2g2id
LEFT JOIN (
	select forumid, MAX(lastupdated) 'lastupdated' FROM forumlastupdated  f GROUP BY forumid
) AS journallastupdated ON journallastupdated.forumid = C.journal
where	C.h2g2id = @h2g2id
END