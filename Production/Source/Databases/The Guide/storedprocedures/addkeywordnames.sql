Create Procedure addkeywordnames @kname1 varchar(255) = NULL,
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
IF @kname1 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname1)
IF @kname2 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname2)
IF @kname3 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname3)
IF @kname4 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname4)
IF @kname5 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname5)
IF @kname6 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname6)
IF @kname7 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname7)
IF @kname8 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname8)
IF @kname9 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname9)
IF @kname10 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname10)
IF @kname11 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname11)
IF @kname12 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname12)
IF @kname13 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname13)
IF @kname14 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname14)
IF @kname15 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname15)
IF @kname16 IS NOT NULL
	INSERT INTO Keywords (KeywordName) VALUES(@kname16)
SELECT KeywordID, KeywordName FROM Keywords WHERE KeywordName IN (	@kname1,
																	@kname2,
																	@kname3,
																	@kname4,
																	@kname5,
																	@kname6,
																	@kname7,
																	@kname8,
																	@kname9,
																	@kname10,
																	@kname11,
																	@kname12,
																	@kname13,
																	@kname14,
																	@kname15,
																	@kname16)
	return (0)