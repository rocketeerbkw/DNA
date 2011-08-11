CREATE PROCEDURE queuethreadentryformoderation @forumid int, @threadid int, @entryid int, @siteid int, @modnotes VARCHAR(255),, @profanityxml xml = null
AS
	 -- Add an entry into the ThreadMod table and get the ModId
	DECLARE @ModID INT
	INSERT INTO dbo.ThreadMod ( ForumID,  ThreadID,  PostID,  Status, NewPost, SiteID,  Notes)
		               VALUES (@forumid, @threadid, @entryid, 0,      1,      @siteid, @modnotes)
	SELECT @ModID = SCOPE_IDENTITY()       
		                
	-- Now insert the modid and the profanity ids/termsid into the ModTermMapping table  
	  
	INSERT INTO dbo.ModTermMapping (ModID, TermID)  
	SELECT @ModID, ParamValues.ID.value('.','VARCHAR(20)') FROM @profanityxml.nodes('/Profanities/id') as ParamValues(ID) 
