create procedure getvotelinks @voteid int, @linkgroup varchar(255), @showprivate int
as

declare @linkcount int
select @linkcount = COUNT(*) FROM Links WHERE SourceType = 'vote' AND SourceID = @voteid /* AND Type = @linkgroup */ AND Hidden IN (0, @showprivate)

select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = g.Subject from Links l 
	INNER JOIN GuideEntries g ON l.DestinationType = 'article' AND l.DestinationID = g.h2g2ID
where l.SourceType = 'vote' AND l.SourceID = @voteid /* AND l.Type = @linkgroup */ AND l.Hidden IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = h.DisplayName from Links l 
	INNER JOIN Hierarchy h ON l.DestinationType = 'category' AND l.DestinationID = h.NodeID
where l.SourceType = 'vote' AND l.SourceID = @voteid /* AND l.Type = @linkgroup */ AND l.Hidden IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = c.Name from Links l 
	INNER JOIN Clubs c ON l.DestinationType = 'club' AND l.DestinationID = c.ClubID
where l.SourceType = 'vote' AND l.SourceID = @voteid /* AND l.Type = @linkgroup */ AND l.Hidden IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = r.ForumName from Links l 
	INNER JOIN ReviewForums r ON l.DestinationType = 'reviewforum' AND l.DestinationID = r.ReviewForumID
where l.SourceType = 'vote' AND l.SourceID = @voteid /* AND l.Type = @linkgroup */ AND l.Hidden IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = u.UserName from Links l 
	INNER JOIN Users u ON l.DestinationType = 'userpage' AND l.DestinationID = u.UserID
where l.SourceType = 'vote' AND l.SourceID = @voteid /* AND l.Type = @linkgroup */ AND l.Hidden IN (0, @showprivate)
order by selected DESC, l.Type, DateLinked DESC
