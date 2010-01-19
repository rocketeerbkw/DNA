CREATE PROCEDURE cachegethierarchymostrecentupdatetime
AS
SELECT  'DatePosted' = 
	CASE 
	-- when 12 hours is less than diff lastUpdated + now
	WHEN 60*60*12 < DATEDIFF(second, MAX(h.LastUpdated), getdate()) 
	THEN 
		-- 12 hours
		60*60*12 
	ELSE 
		-- get the difference
		DATEDIFF(second, MAX(h.LastUpdated), getdate()) 
	END
FROM Hierarchy h
