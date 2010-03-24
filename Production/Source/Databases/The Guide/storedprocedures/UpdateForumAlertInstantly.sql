Create Procedure updateforumalertinstantly	@alert int, @forumid int
As

UPDATE Forums SET AlertInstantly = @alert where ForumID = @forumid

return (0)