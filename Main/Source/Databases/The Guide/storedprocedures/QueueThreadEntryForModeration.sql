CREATE PROCEDURE queuethreadentryformoderation @forumid int, @threadid int, @entryid int, @siteid int, @modnotes VARCHAR(255), @profanityxml xml = null
AS
	 -- Add an entry into the ThreadMod table and get the ModId
	DECLARE @ModID INT
	INSERT INTO dbo.ThreadMod ( ForumID,  ThreadID,  PostID,  Status, NewPost, SiteID,  Notes)
		               VALUES (@forumid, @threadid, @entryid, 0,      1,      @siteid, @modnotes)
	SELECT @ModID = SCOPE_IDENTITY()       
		                
	-- Now insert the modid and the profanity ids/termsid into the ModTermMapping table  
	if (@profanityxml IS NOT NULL)
	BEGIN	  
		INSERT INTO dbo.ForumModTermMapping (ThreadModID, ModClassID, ForumID, TermID)
		SELECT @ModID,
			A.B.value('(ModClassID)[1]', 'int' ) ModClassID,
			A.B.value('(ForumID)[1]', 'int' ) ForumID,
			A.B.value('(TermID)[1]', 'int' ) TermID
		FROM   @profanityxml.nodes('/Profanities/Terms/TermDetails') A(B) 
	END
