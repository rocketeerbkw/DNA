CREATE PROCEDURE createforum @title varchar(255), @keywords varchar(255) 
AS
INSERT INTO Forums (Title, keywords) VALUES(@title, @keywords)
SELECT 'ForumID' = @@IDENTITY