create procedure markallthreadsread @userid int
as
BEGIN TRANSACTION
UPDATE ThreadPostings
	SET LastPostCountRead = CountPosts
	WHERE UserID = @userid
COMMIT TRANSACTION