CREATE FUNCTION udf_splitvarchar(@arr AS VARCHAR(max))
 RETURNS TABLE
AS
RETURN
  SELECT
	(n - 1) - LEN(REPLACE(LEFT(@arr, n-1), '|', N'')) + 1 AS pos,
	NULLIF(SUBSTRING(@arr, n, CHARINDEX('|', @arr + '|', n) - n),'') AS element
  FROM dbo.Nums
  WHERE n <= LEN(@arr) + 1
	AND SUBSTRING('|' + @arr, n, 1) = '|';
/*
	Function: Splits '|' delimited strings.

	Params:
		@arr - string to be split.

	Returns: Table 
				pos INT - the position of the element
				element varchar(max) - the split out element
*/
