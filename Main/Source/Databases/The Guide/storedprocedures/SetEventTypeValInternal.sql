CREATE PROCEDURE seteventtypevalinternal @eventtype varchar(50), @ieventtype int OUTPUT
AS

-- The values set here directly match those defined in the ENUM 
-- in CEventQueue.h 
-- !! Make sure both files stay up to date !!
SELECT @ieventtype = CASE 
	WHEN (@eventtype = 'ET_ARTICLEEDITED')					THEN 0
	WHEN (@eventtype = 'ET_CATEGORYARTICLETAGGED')			THEN 1
	WHEN (@eventtype = 'ET_CATEGORYARTICLEEDITED')			THEN 2
	WHEN (@eventtype = 'ET_FORUMEDITED')					THEN 3
	WHEN (@eventtype = 'ET_NEWTEAMMEMBER')					THEN 4
	WHEN (@eventtype = 'ET_POSTREPLIEDTO')					THEN 5
	WHEN (@eventtype = 'ET_POSTNEWTHREAD')					THEN 6
	WHEN (@eventtype = 'ET_CATEGORYTHREADTAGGED')			THEN 7
	WHEN (@eventtype = 'ET_CATEGORYUSERTAGGED')				THEN 8
	WHEN (@eventtype = 'ET_CATEGORYCLUBTAGGED')				THEN 9
	WHEN (@eventtype = 'ET_NEWLINKADDED')					THEN 10
	WHEN (@eventtype = 'ET_VOTEADDED')						THEN 11
	WHEN (@eventtype = 'ET_VOTEREMOVED')					THEN 12
	WHEN (@eventtype = 'ET_CLUBOWNERTEAMCHANGE')			THEN 13
	WHEN (@eventtype = 'ET_CLUBMEMBERTEAMCHANGE')			THEN 14
	WHEN (@eventtype = 'ET_CLUBMEMBERAPPLICATIONCHANGE')	THEN 15
	WHEN (@eventtype = 'ET_CLUBEDITED')						THEN 16
	WHEN (@eventtype = 'ET_CATEGORYHIDDEN')					THEN 17
	WHEN (@eventtype = 'ET_EXMODERATIONDECISION')			THEN 18
	WHEN (@eventtype = 'ET_POSTTOFORUM')					THEN 19
	WHEN (@eventtype = 'ET_POSTREVOKE')						THEN 20
	WHEN (@eventtype = 'ET_POSTNEEDSRISKASSESSMENT')		THEN 21
	ELSE NULL
END