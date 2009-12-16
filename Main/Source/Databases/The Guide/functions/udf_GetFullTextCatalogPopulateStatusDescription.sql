CREATE FUNCTION udf_getfulltextcatalogpopulatestatusdescription (@catalogname sysname)
RETURNS VARCHAR(100)
AS
BEGIN

	RETURN 
		CASE FULLTEXTCATALOGPROPERTY(@CatalogName,'PopulateStatus')
			WHEN 0 THEN 'Idle'
			WHEN 1 THEN 'Full population in progress'
			WHEN 2 THEN 'Paused'
			WHEN 3 THEN 'Throttled'
			WHEN 4 THEN 'Recovering 5 = Shutdown'
			WHEN 6 THEN 'Incremental population in progress'
			WHEN 7 THEN 'Building index'
			WHEN 8 THEN 'Disk is full. Paused.'
			WHEN 9 THEN 'Change tracking'
			ELSE 'Unknown'
		END
END