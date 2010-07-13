Create Procedure updateforumalertinstantly	@alert int, @forumid int
As

UPDATE Forums SET AlertInstantly = @alert where ForumID = @forumid

INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@forumid, getdate())

return (0)