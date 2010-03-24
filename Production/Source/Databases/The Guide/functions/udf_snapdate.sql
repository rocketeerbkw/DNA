CREATE FUNCTION udf_snapdate(@date datetime, @snap varchar(20))
RETURNS datetime
AS
BEGIN
	IF @snap = 'year'
		RETURN DATEADD(year, DATEDIFF(year, '1 jan 2006', @date), '1 jan 2006')
		
	IF @snap = 'month'
		RETURN DATEADD(month, DATEDIFF(month, '1 jan 2006', @date), '1 jan 2006')
		
	IF @snap = 'day'
		RETURN DATEADD(day, DATEDIFF(day, '1 jan 2006', @date), '1 jan 2006')
		
	IF @snap = 'hour'
		RETURN DATEADD(hour, DATEDIFF(hour, '1 jan 2006', @date), '1 jan 2006')

	IF @snap = 'minute'
		RETURN DATEADD(minute, DATEDIFF(minute, '1 jan 2006', @date), '1 jan 2006')
		
	RETURN @date
END