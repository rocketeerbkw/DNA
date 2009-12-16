Create Procedure setarticleforumarchivestatus @h2g2id int, @archivestatus tinyint
As
Begin TRANSACTION

declare @forumid int, @canwrite int
SELECT @forumid = ForumID FROM GuideEntries where h2g2ID = @h2g2id

select @canwrite = CASE WHEN @archivestatus = 1 THEN 0 ELSE 1 END

update Forums SET CanWrite = @canwrite, ThreadCanWrite = @canwrite WHERE ForumID = @forumid

COMMIT TRANSACTION