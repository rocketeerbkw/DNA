CREATE PROCEDURE setitemlisttypevalinternal @listtype varchar(50), @ilisttype int OUTPUT
AS
-- The values set here directly match those defined in the ENUM 
-- in CBaseList.h 
-- !! Make sure both files stay up to date !!
SELECT @ilisttype = CASE 
	WHEN (@listtype = 'LT_ANY')					THEN 0
	WHEN (@listtype = 'LT_CATEGORY')			THEN 1
	WHEN (@listtype = 'LT_EMAILALERT')			THEN 2
	WHEN (@listtype = 'LT_INSTANTEMAILALERT')	THEN 3
	ELSE 1
END
