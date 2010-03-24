CREATE PROCEDURE cachegetkeyarticlename @artname varchar(255)
AS
	SELECT 'seconds' = DATEDIFF(second, MAX(DateActive), getdate()) FROM KayArticles WHERE ArticleName = @artname AND DateActive <= getdate()