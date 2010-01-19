create procedure getuserlinks @userid int, @linkgroup varchar(255), @showprivate int
as

declare @linkcount int
select @linkcount = COUNT(*) FROM Links WITH(NOLOCK) WHERE SourceType = 'userpage' AND SourceID = @userid /* AND Type = @linkgroup */ AND Hidden IN (0, @showprivate)

select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = g.Subject from Links l WITH(NOLOCK) 
	INNER JOIN GuideEntries g WITH(NOLOCK) ON l.DestinationType = 'article' AND l.DestinationID = g.h2g2ID
where l.SourceType = 'userpage' AND l.SourceID = @userid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = h.DisplayName from Links l WITH(NOLOCK) 
	INNER JOIN Hierarchy h WITH(NOLOCK) ON l.DestinationType = 'category' AND l.DestinationID = h.NodeID
where l.SourceType = 'userpage' AND l.SourceID = @userid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = c.Name from Links l WITH(NOLOCK) 
	INNER JOIN Clubs c WITH(NOLOCK) ON l.DestinationType = 'club' AND l.DestinationID = c.ClubID
where l.SourceType = 'userpage' AND l.SourceID = @userid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = r.ForumName from Links l WITH(NOLOCK) 
	INNER JOIN ReviewForums r WITH(NOLOCK) ON l.DestinationType = 'reviewforum' AND l.DestinationID = r.ReviewForumID
where l.SourceType = 'userpage' AND l.SourceID = @userid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
UNION
select 'linkcount' = @linkcount, 'selected' = CASE WHEN l.Type = @linkgroup THEN 1 ELSE 0 END, l.*, 'Title' = u.UserName from Links l WITH(NOLOCK) 
	INNER JOIN Users u WITH(NOLOCK) ON l.DestinationType = 'userpage' AND l.DestinationID = u.UserID
where l.SourceType = 'userpage' AND l.SourceID = @userid /* AND l.Type = @linkgroup */ AND l.Private IN (0, @showprivate)
order by selected DESC, l.Type, DateLinked DESC
