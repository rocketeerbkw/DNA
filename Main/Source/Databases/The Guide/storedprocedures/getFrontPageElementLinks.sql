create procedure getfrontpageelementlinks @elementid int, @showprivate int
as

select  l.*, 'Title' = g.Subject from Links l 
	INNER JOIN GuideEntries g ON l.DestinationType = 'article' AND l.DestinationID = g.h2g2ID
where l.SourceType = 'frontpageelement' AND l.SourceID = @elementid AND l.Hidden IN (0, @showprivate)
UNION
select l.*, 'Title' = h.DisplayName from Links l 
	INNER JOIN Hierarchy h ON l.DestinationType = 'category' AND l.DestinationID = h.NodeID
where l.SourceType = 'frontpageelement' AND l.SourceID = @elementid AND l.Hidden IN (0, @showprivate)
UNION
select l.*, 'Title' = c.Name from Links l 
	INNER JOIN Clubs c ON l.DestinationType = 'club' AND l.DestinationID = c.ClubID
where l.SourceType = 'frontpageelement' AND l.SourceID = @elementid AND l.Hidden IN (0, @showprivate)
UNION
select  l.*, 'Title' = r.ForumName from Links l 
	INNER JOIN ReviewForums r ON l.DestinationType = 'reviewforum' AND l.DestinationID = r.ReviewForumID
where l.SourceType = 'frontpageelement' AND l.SourceID = @elementid AND l.Hidden IN (0, @showprivate)
UNION
select 	l.*, 'Title' = u.UserName from Links l 
	INNER JOIN Users u ON l.DestinationType = 'userpage' AND l.DestinationID = u.UserID
where l.SourceType = 'frontpageelement' AND l.SourceID = @elementid AND l.Hidden IN (0, @showprivate)
order by l.Type, DateLinked DESC