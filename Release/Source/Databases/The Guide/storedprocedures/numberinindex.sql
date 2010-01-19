CREATE PROCEDURE numberinindex @char varchar(4)
AS
	SELECT @char = LEFT(@char,1)
	IF @char >= 'a' AND @char <= 'z'
		SELECT 'ArticleCount' = COUNT(*) FROM GuideEntries WHERE LEFT(Subject,1) = @char AND Status IN (1,3,4)
	ELSE
		SELECT 'ArticleCount' = COUNT(*) FROM GuideEntries WHERE LEFT(Subject,1) LIKE '[^a-z]' AND Status IN (1,3,4)



