Create Procedure getkeywordids	@kname1 varchar(255) = NULL,
									@kname2 varchar(255) = NULL,
									@kname3 varchar(255) = NULL,
									@kname4 varchar(255) = NULL,
									@kname5 varchar(255) = NULL,
									@kname6 varchar(255) = NULL,
									@kname7 varchar(255) = NULL,
									@kname8 varchar(255) = NULL,
									@kname9 varchar(255) = NULL,
									@kname10 varchar(255) = NULL,
									@kname11 varchar(255) = NULL,
									@kname12 varchar(255) = NULL,
									@kname13 varchar(255) = NULL,
									@kname14 varchar(255) = NULL,
									@kname15 varchar(255) = NULL,
									@kname16 varchar(255) = NULL
As
SELECT KeywordID, KeywordName
FROM Keywords
WHERE KeywordName IS NOT NULL
AND
(
	KeywordName = @kname1 OR
	KeywordName = @kname2 OR
	KeywordName = @kname3 OR
	KeywordName = @kname4 OR
	KeywordName = @kname5 OR
	KeywordName = @kname6 OR
	KeywordName = @kname7 OR
	KeywordName = @kname8 OR
	KeywordName = @kname9 OR
	KeywordName = @kname10 OR
	KeywordName = @kname11 OR
	KeywordName = @kname12 OR
	KeywordName = @kname13 OR
	KeywordName = @kname14 OR
	KeywordName = @kname15 OR
	KeywordName = @kname16
)
	return (0)