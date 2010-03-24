CREATE FUNCTION udf_calcdistance ( @lat1 float , @long1 float , @lat2 float , @long2 float)
RETURNS FLOAT
AS
BEGIN

DECLARE @DegToRad AS float
DECLARE @Ans AS float
DECLARE @Miles AS float

SET @DegToRad = 57.29577951
SET @Ans = 0
SET @Miles = 0

IF @lat1 is null or @lat1 = 0 or @long1 is null or @long1 = 0 or @lat2 is null or @lat2 = 0 or @long2 is null or @long2 = 0
BEGIN
	RETURN ( @Miles )
END

SET @Ans = SIN(@lat1 / @DegToRad) * SIN(@lat2 / @DegToRad) + COS(@lat1 / @DegToRad ) * COS( @lat2 / @DegToRad ) * COS(ABS(@long2 - @long1 )/@DegToRad)

SET @Miles = 3959 * ATAN(SQRT(1 - SQUARE(@Ans)) / @Ans)

--SET @Miles = CEILING(@Miles)

RETURN ( @Miles )

END