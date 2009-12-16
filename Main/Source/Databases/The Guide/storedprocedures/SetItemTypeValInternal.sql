CREATE PROCEDURE setitemtypevalinternal @itemtype varchar(50), @iitemtype int OUTPUT
AS
-- The values set here directly match those defined in the ENUM 
-- in CBaseList.h 
-- !! Make sure both files stay up to date !!

Select @iitemtype = CASE 
	WHEN (@itemtype = 'IT_ALL')				THEN 0
	WHEN (@itemtype = 'IT_NODE')			THEN 1
	WHEN (@itemtype = 'IT_H2G2')			THEN 2
	WHEN (@itemtype = 'IT_CLUB')			THEN 3
	WHEN (@itemtype = 'IT_FORUM')			THEN 4
	WHEN (@itemtype = 'IT_THREAD')			THEN 5
	WHEN (@itemtype = 'IT_POST')			THEN 6
	WHEN (@itemtype = 'IT_USER')			THEN 7
	WHEN (@itemtype = 'IT_VOTE')			THEN 8
	WHEN (@itemtype = 'IT_LINK')			THEN 9
	WHEN (@itemtype = 'IT_TEAM')			THEN 10
	WHEN (@itemtype = 'IT_PRIVATEFORUM')	THEN 11
	WHEN (@itemtype = 'IT_CLUB_MEMBERS')	THEN 12
	WHEN (@itemtype = 'IT_MODID')			THEN 13
	ELSE 2
END