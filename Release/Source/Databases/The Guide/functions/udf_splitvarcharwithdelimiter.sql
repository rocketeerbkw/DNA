CREATE FUNCTION udf_splitvarcharwithdelimiter(@arr AS VARCHAR(max), @delimiter char)
	RETURNS TABLE
AS
RETURN
  SELECT
    (n - 1) - LEN(REPLACE(LEFT(@arr, n-1), @delimiter, N'')) + 1 AS pos,
    NULLIF(SUBSTRING(@arr, n, CHARINDEX(@delimiter, @arr + @delimiter, n) - n),'') AS element
  FROM dbo.Nums
  WHERE n <= LEN(@arr) + 1
    AND SUBSTRING(@delimiter + @arr, n, 1) = @delimiter;
/*
	Function: Splits delimited string according to the delimiter passed in. 

	Params:
		@arr - string to be split.
		@delimiter - delimiter. 

	Returns: Table 
				pos INT - the position of the element
				element varchar(max) - the split out element
*/
