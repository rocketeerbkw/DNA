CREATE TRIGGER trg_Threads_iu ON Threads
AFTER INSERT, UPDATE 
AS
	-- If the forumid changes for this thread, make sure the SiteID
	-- is the same as the siteid for the new forum
	IF UPDATE(ForumID)
	BEGIN
		UPDATE dbo.Threads SET dbo.Threads.SiteID = f.SiteID 
			FROM inserted i
			INNER JOIN Forums f ON f.ForumId = i.ForumID
			WHERE dbo.Threads.ThreadID=i.ThreadID
	END
