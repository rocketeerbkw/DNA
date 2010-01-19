CREATE FUNCTION udf_iswithinrange ( @lat1 float , @long1 float , @lat2 float , @long2 float, @range float)
RETURNS BIT
AS
BEGIN

DECLARE @Ans AS float
DECLARE @Miles AS float
DECLARE @MilesPerDegreeLat AS float
DECLARE @MilesPerDegreeLong AS float

--These values are for latitude 51
SET @MilesPerDegreeLat = 69.13
SET @MilesPerDegreeLong = 43.62
SET @Ans = 0
SET @Miles = 0

IF @lat1 is null or @lat1 = 0 or @long1 is null or @long1 = 0 or @lat2 is null or @lat2 = 0 or @long2 is null or @long2 = 0 or @range is null or @range = 0
BEGIN
	RETURN 0
END

DECLARE @DifferenceNorthSouthDegrees AS float
DECLARE @DifferenceEastWestDegrees AS float

SET @DifferenceNorthSouthDegrees = @range / @MilesPerDegreeLat
SET @DifferenceEastWestDegrees = @range / @MilesPerDegreeLong

DECLARE @MostNortherlyPoint AS float
DECLARE @MostSoutherlyPoint AS float

SET @MostNortherlyPoint = @lat1 + @MilesPerDegreeLat
SET @MostSoutherlyPoint = @lat1 - @MilesPerDegreeLat

DECLARE @MostEasterlyPoint AS float
DECLARE @MostWesterlyPoint AS float

--Eastern values postitive and western values negative

SET @MostEasterlyPoint = @long1 + @MilesPerDegreeLong
SET @MostWesterlyPoint = @long1 - @MilesPerDegreeLong

IF ((@lat2 < @MostNortherlyPoint AND @lat2 > @MostSoutherlyPoint) AND
   (@long2 < @MostEasterlyPoint AND @long2 > @MostWesterlyPoint))
BEGIN
	RETURN 1
END

RETURN 0

END
