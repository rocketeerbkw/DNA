-- Written by Itzik Ben-Gan (Solid Quality Learning)

CREATE FUNCTION udf_splitint(@arr AS VARCHAR(max))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
	SELECT	n - LEN(REPLACE(LEFT(@arr, n), '|', '')) + 1 AS pos,
			CAST(SUBSTRING(@arr, n,CHARINDEX('|', @arr + '|', n) - n) AS INT) AS element
		FROM dbo.Nums WHERE n <= LEN(@arr) AND SUBSTRING('|' + @arr, n, 1) = '|'
