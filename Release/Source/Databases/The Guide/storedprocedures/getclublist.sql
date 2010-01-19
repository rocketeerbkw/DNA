CREATE PROCEDURE getclublist @siteid int, @orderbylastupdated int = 0
AS

IF @orderbylastupdated = 1
BEGIN
	SELECT 	c.ClubID, 
			c.Name, 
			'DateCreated' = ISNULL(c.DateCreated,g.DateCreated), 
			--If c.LastUpdated IS NULL c.LastUpdated > g.LastUpdated evaluates to false.
			'LastUpdated' = CASE WHEN c.LastUpdated > g.LastUpdated THEN c.LastUpdated ELSE g.LastUpdated END,
			g.ExtraInfo
	FROM	GuideEntries g 	WITH(NOLOCK),
			Clubs c 	WITH(NOLOCK, INDEX=IX_Club_h2g2ID)
	WHERE	g.h2g2ID = c.h2g2ID
			and g.hidden IS NULL
			and (g.Type BETWEEN 1001 AND 2000)
			and c.SiteID = @siteid
	ORDER BY LastUpdated desc
END
ELSE
BEGIN
	SELECT 	c.ClubID, 
			c.Name, 
			'DateCreated' = ISNULL(c.DateCreated,g.DateCreated),
			--If c.LastUpdated IS NULL c.LastUpdated > g.LastUpdated evaluates to false.
			'LastUpdated' = CASE WHEN c.LastUpdated > g.LastUpdated THEN c.LastUpdated ELSE g.LastUpdated END,
			 g.ExtraInfo
	FROM	GuideEntries g 	WITH(NOLOCK),
			Clubs c 	WITH(NOLOCK, INDEX=IX_Club_h2g2ID)
	WHERE	g.h2g2ID = c.h2g2ID
			and g.hidden IS NULL
			and (g.Type BETWEEN 1001 AND 2000)
			and c.SiteID = @siteid
	ORDER BY DateCreated desc
END
