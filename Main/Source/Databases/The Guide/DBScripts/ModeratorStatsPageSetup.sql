/* Moderation stats is only available on ops-dna1. These scripts need to be run on NewGuide after a restore of the backup from live to populate the cubes for the moderation stats page. */

DELETE FROM ThreadModCube; 

INSERT INTO ThreadModCube
(
	UserID, 
	SiteID, 
	Status, 
	Date, 
	[Count]
)	
SELECT	tm.LockedBy, 
		tm.SiteID, 
		tm.Status, 
		CAST(CONVERT(char(9), tm.DateCompleted, 112) AS DATETIME), -- Group and set all DateCompleted dates to midnight.
		count(*)
  FROM	dbo.ThreadMod tm 
 WHERE	tm.LockedBy IS NOT NULL 
   AND	tm.SiteID IS NOT NULL 
   AND	tm.Status IS NOT NULL
   AND	tm.DateCompleted IS NOT NULL
   --	Limit by date e.g. dateadd(yy, -1, getdate() ???
 GROUP	BY tm.LockedBy, tm.SiteID, tm.Status, CAST(CONVERT(char(9), tm.DateCompleted, 112) AS DATETIME)
  WITH	CUBE;

DELETE FROM ThreadModReferralsCube; 

INSERT INTO ThreadModReferralsCube
(
	UserID, 
	SiteID, 
	Status, 
	Date, 
	[Count]
)	
SELECT	tm.ReferredBy, 
		tm.SiteID, 
		tm.Status, 
		CAST(CONVERT(char(9), tm.DateCompleted, 112) AS DATETIME), -- Group and set all DateCompleted dates to midnight.
		count(*)
  FROM	dbo.ThreadMod tm 
 WHERE	tm.ReferredBy IS NOT NULL 
   AND	tm.SiteID IS NOT NULL 
   AND	tm.Status IS NOT NULL
   AND	tm.DateCompleted IS NOT NULL
   --	Limit by date e.g. dateadd(yy, -1, getdate() ???
 GROUP	BY tm.ReferredBy, tm.SiteID, tm.Status, CAST(CONVERT(char(9), tm.DateCompleted, 112) AS DATETIME)
  WITH	CUBE;

DELETE FROM ArticleModCube; 

INSERT INTO ArticleModCube
(
	UserID, 
	SiteID, 
	Status, 
	Date, 
	[Count]
)	
SELECT	am.LockedBy, 
		am.SiteID, 
		am.Status, 
		CAST(CONVERT(char(9), am.DateCompleted, 112) AS DATETIME) AS 'Date', -- Group and set all DateCompleted dates to midnight.
		count(*) AS 'Count'
  FROM	dbo.ArticleMod am 
 WHERE	am.LockedBy IS NOT NULL 
   AND	am.SiteID IS NOT NULL 
   AND	am.Status IS NOT NULL
   AND	am.DateCompleted IS NOT NULL
   --	Limit by date e.g. dateadd(yy, -1, getdate() ???
 GROUP	BY am.LockedBy, am.SiteID, am.Status, CAST(CONVERT(char(9), am.DateCompleted, 112) AS DATETIME)
  WITH	CUBE;

DELETE FROM ArticleModReferralsCube; 

INSERT INTO ArticleModReferralsCube
(
	UserID, 
	SiteID, 
	Status, 
	Date, 
	[Count]
)	
SELECT	am.ReferredBy, 
		am.SiteID, 
		am.Status, 
		CAST(CONVERT(char(9), am.DateCompleted, 112) AS DATETIME) AS 'Date', -- Group and set all DateCompleted dates to midnight.
		count(*) AS 'Count'
  FROM	dbo.ArticleMod am 
 WHERE	am.ReferredBy IS NOT NULL 
   AND	am.SiteID IS NOT NULL 
   AND	am.Status IS NOT NULL
   AND	am.DateCompleted IS NOT NULL
   --	Limit by date e.g. dateadd(yy, -1, getdate() ???
 GROUP	BY am.ReferredBy, am.SiteID, am.Status, CAST(CONVERT(char(9), am.DateCompleted, 112) AS DATETIME)
  WITH	CUBE;

DELETE FROM NicknameModCube;

INSERT INTO NicknameModCube
(
	UserID, 
	SiteID, 
	Status, 
	Date, 
	[Count]
)	
SELECT	nnm.LockedBy, 
		nnm.SiteID, 
		nnm.Status, 
		CAST(CONVERT(char(9), nnm.DateCompleted, 112) AS DATETIME) AS 'Date', -- Group and set all DateCompleted dates to midnight.
		count(*) AS 'Count'
  FROM	dbo.NicknameMod nnm
 WHERE	nnm.LockedBy IS NOT NULL 
   AND	nnm.SiteID IS NOT NULL 
   AND	nnm.Status IS NOT NULL
   AND	nnm.DateCompleted IS NOT NULL
 GROUP	BY nnm.LockedBy, nnm.SiteID, nnm.Status, CAST(CONVERT(char(9), nnm.DateCompleted, 112) AS DATETIME)
  WITH	CUBE;