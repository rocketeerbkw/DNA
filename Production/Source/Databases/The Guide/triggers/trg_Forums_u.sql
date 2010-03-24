CREATE TRIGGER trg_Forums_u ON Forums
AFTER UPDATE 
AS
	-- If the siteid changes for this forum,
	-- update the siteid on all associated Threads
	IF UPDATE(SiteID)
	BEGIN
		UPDATE dbo.Threads SET dbo.Threads.SiteID = i.SiteID 
			FROM inserted i
			INNER JOIN Forums f ON f.ForumId = i.ForumID
			WHERE dbo.Threads.ForumID=i.ForumID
	END
