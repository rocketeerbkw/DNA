exec dbu_createsiteoption 0, 'AutoModeration', 'BannedThresholdValue', '-5' ,0,'The number of trust points the user needs in order to get banned.'
exec dbu_createsiteoption 0, 'AutoModeration', 'PremodThresholdValue', '-3' ,0,'The number of trust points the user needs in order to get premoderated.'
exec dbu_createsiteoption 0, 'AutoModeration', 'PostmodThresholdValue', '0' ,0,'The number of trust points the user needs in order to get postmoderated.'
exec dbu_createsiteoption 0, 'AutoModeration', 'ReactiveThresholdValue', '3' ,0,'The number of trust points the user needs in order to get reactive.'
exec dbu_createsiteoption 0, 'AutoModeration', 'MaxTrustValue', '5' ,0,'The maximum number of trust points a user can accumulate (combats karma whoring).'

exec dbu_createsiteoption 16, 'AutoModeration', 'BannedThresholdValue', '-2' ,0,'The number of trust points the user needs in order to get banned.'
exec dbu_createsiteoption 16, 'AutoModeration', 'PremodThresholdValue', '-1' ,0,'The number of trust points the user needs in order to get premoderated.'
exec dbu_createsiteoption 16, 'AutoModeration', 'PostmodThresholdValue', '0' ,0,'The number of trust points the user needs in order to get postmoderated.'
exec dbu_createsiteoption 16, 'AutoModeration', 'ReactiveThresholdValue', '2' ,0,'The number of trust points the user needs in order to get reactive.'
exec dbu_createsiteoption 16, 'AutoModeration', 'MaxTrustValue', '6' ,0,'The maximum number of trust points a user can accumulate (combats karma whoring).'

exec dbu_createsiteoption 0, 'AutoModeration', 'SeedUserTrustUsingPreviousBehaviour', '1' ,1,'Set new user''s mod status and threshold value according to previous behavior (if no then set according to )'

CREATE FUNCTION dbo.GetSiteModStatus (@SiteID INT)
RETURNS INT 
BEGIN
	DECLARE @SitesModStatus INT;
	SELECT @SitesModStatus = CASE 
								WHEN PreModeration = 1 THEN 1 -- Premoderated
								WHEN PreModeration = 0 AND Unmoderated = 0 THEN 2 -- PostModerated
								WHEN PreModeration = 0 AND Unmoderated = 1 THEN 0 -- Reactive
							  END
	  FROM	dbo.Sites
	 WHERE	SiteID = @SiteID; 

	RETURN @SitesModStatus
END; 


/* Seeding user mod and trust score script. Duration: 3m 30s */

WITH UsersSeededPrefStatus AS
(
	SELECT	UserID, SiteID, 
			CASE 
				WHEN p.PrefStatus = 4 THEN 4 -- Banned
				WHEN p.PrefStatus = 1 OR dbo.GetSiteModStatus(p.SiteID) = 1 THEN 1 -- Premoderated
				WHEN p.PrefStatus = 2 OR dbo.GetSiteModStatus(p.SiteID) = 2 THEN 2 -- Postmoderated
				WHEN p.PrefStatus = 0 AND dbo.GetSiteModStatus(p.SiteID) = 0 THEN 0 -- Reactive
				ELSE -1 
			END AS 'SeededPrefStatus'
	  FROM	dbo.Preferences p 
	 WHERE	p.UserID <> 0
)
SELECT	usps.UserID, 
		usps.SiteID, 
		usps.SeededPrefStatus, 
		CASE
			WHEN SeededPrefStatus = 4 THEN dbo.udf_getsiteoptionsetting (usps.SiteID, 'AutoModeration', 'BannedThresholdValue')
			WHEN SeededPrefStatus = 1 THEN dbo.udf_getsiteoptionsetting (usps.SiteID, 'AutoModeration', 'PremodThresholdValue')
			WHEN SeededPrefStatus = 2 THEN dbo.udf_getsiteoptionsetting (usps.SiteID, 'AutoModeration', 'PostmodThresholdValue')
			WHEN SeededPrefStatus = 3 THEN dbo.udf_getsiteoptionsetting (usps.SiteID, 'AutoModeration', 'ReactiveThresholdValue')
			ELSE 0 -- default's Postmod threshold 
		END AS 'TrustScore'
  INTO	#UserSeededPrefStatus 
  FROM	UsersSeededPrefStatus usps

/* System wide mod stats counts */
SELECT SeededPrefStatus, count(*)
  FROM #UserSeededPrefStatus 
 GROUP BY SeededPrefStatus

SELECT	CASE 
			WHEN n.SeededPrefStatus = 0 THEN 'Reactive'
			WHEN n.SeededPrefStatus = 1 THEN 'Premoderated'
			WHEN n.SeededPrefStatus = 2 THEN 'Postmoderated'
			WHEN n.SeededPrefStatus = 4 THEN 'Banned'
			ELSE 'Unkown'
		END
		, COUNT(*)
  FROM	(
			SELECT	UserID, SiteID, 
					CASE 
						WHEN p.PrefStatus = 4 THEN 4 -- Banned
						WHEN p.PrefStatus = 1 OR dbo.GetSiteModStatus(p.SiteID) = 1 THEN 1 -- Premoderated
						WHEN p.PrefStatus = 2 OR dbo.GetSiteModStatus(p.SiteID) = 2 THEN 2 -- Postmoderated
						WHEN p.PrefStatus = 0 AND dbo.GetSiteModStatus(p.SiteID) = 0 THEN 0 -- Reactive
						ELSE -1 
					END AS 'SeededPrefStatus'
			  FROM	dbo.Preferences p 
			 WHERE	p.UserID <> 0
		) n
 GROUP	BY SeededPrefStatus

/* Site level mod stats counts */
SELECT	s.ShortName, 
		CASE 
			WHEN n.SeededPrefStatus = 0 THEN 'Reactive'
			WHEN n.SeededPrefStatus = 1 THEN 'Premoderated'
			WHEN n.SeededPrefStatus = 2 THEN 'Postmoderated'
			WHEN n.SeededPrefStatus = 4 THEN 'Banned'
			ELSE 'Unkown'
		END
, COUNT(*)
  FROM	(
			SELECT	UserID, SiteID, 
					CASE 
						WHEN p.PrefStatus = 4 THEN 4 -- Banned
						WHEN p.PrefStatus = 1 OR dbo.GetSiteModStatus(p.SiteID) = 1 THEN 1 -- Premoderated
						WHEN p.PrefStatus = 2 OR dbo.GetSiteModStatus(p.SiteID) = 2 THEN 2 -- Postmoderated
						WHEN p.PrefStatus = 0 AND dbo.GetSiteModStatus(p.SiteID) = 0 THEN 0 -- Reactive
						ELSE -1 
					END AS 'SeededPrefStatus'
			  FROM	dbo.Preferences p 
			 WHERE	p.UserID <> 0
		) n
 INNER	JOIN dbo.Sites s on n.SiteID = s.SiteID
 GROUP	BY s.ShortName, SeededPrefStatus
 ORDER	BY s.ShortName ASC 