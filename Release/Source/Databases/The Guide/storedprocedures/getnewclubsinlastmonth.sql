CREATE PROCEDURE getnewclubsinlastmonth
AS
BEGIN

--SELECT c.ClubID, c.Name, g.DateCreated, c.SiteID FROM GuideEntries g, Clubs c 
--WHERE g.h2g2ID = c.h2g2ID and g.Type = 1001 and g.DateCreated > dateadd(mm, -1, getdate()) 
--ORDER BY g.DateCreated

SELECT c.ClubID, c.Name, g.DateCreated, g.ExtraInfo FROM GuideEntries g, Clubs c 
WHERE g.h2g2ID = c.h2g2ID and (g.Type BETWEEN 1001 AND 2000) and g.DateCreated > dateadd(mm, -1, getdate()) 
ORDER BY g.DateCreated

END

