CREATE PROCEDURE getthreadswithkeyphrasesgeneral @forumid int, @firstindex int, @lastindex int
AS
BEGIN	

--Get count of all threads in forum
DECLARE @threadcount INT
SELECT @threadcount = COUNT(*)
FROM dbo.Threads th WITH(NOLOCK)
WHERE th.forumid = @forumid AND th.VisibleTo IS NULL


--Do Skip and Show by creating a temp table with the relevant entries
create table #tempthreads (id int NOT NULL IDENTITY(0,1)PRIMARY KEY, ThreadID int NOT NULL, ForumID int NOT NULL)
insert into #tempthreads (ThreadID, ForumID)
SELECT TOP(@lastindex) ThreadID, t.ForumID FROM dbo.Threads t WITH(NOLOCK) 
	WHERE t.forumid = @forumid AND t.VisibleTo IS NULL
	ORDER BY t.LastPosted DESC


DELETE FROM #tempthreads WHERE id > @lastindex or id < @firstindex
	
	
	--Fetch all threads - no phrase filter given.
	SELECT			t.Forumid, 
				t.threadid, 
				t.FirstSubject, 
				t.DateCreated, 
				t.LastPosted,
				'ThreadCount' = @threadcount,
				t.ThreadPostCount,
				f.SiteID,
				
				'CanRead' = f.canread,
				'CanWrite' = f.canwrite,
				'ThreadCanRead' = f.threadcanread,
				'ThreadCanWrite' = f.threadcanwrite,
				'ModerationStatus' = f.moderationstatus,
				'AlertInstantly' = f.AlertInstantly,	
					
				--First post details.
				'FirstPostText' = te.text,
				'FirstPostEntryID' = te.EntryID,
				'FirstPosting' = te.DatePosted,
				'FirstPostUserID' = te.UserID,
				
				'FirstPostStyle' = te.PostStyle,
				
				'FirstPostHidden' = te.Hidden,

				'LastPostEntryID' = te1.EntryID,
				'LastPostText' = te1.text,
				'LastPostHidden' = te1.Hidden,
				'LastPostStyle' = te1.PostStyle,
				'LastPostUserID' = te1.UserID,
				'LastPosting' = te1.DatePosted,
				
				f.ForumPostCount,
				t.type,
				t.eventdate,
				threadphrases.phrase
		from #tempthreads tmp
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.threadId = tmp.threadId
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = tmp.ForumID and f.forumid = @forumid --f.siteid = @siteid
		INNER JOIN dbo.ThreadEntries te  WITH(NOLOCK) ON te.Threadid = tmp.ThreadID AND te.PostIndex = 0
		INNER JOIN dbo.ThreadEntries te1 WITH(NOLOCK) ON te1.ThreadID = t.ThreadID AND te1.PostIndex = t.ThreadPostCount-1
		
		--Get all the phrases associated with each thread.
		LEFT JOIN dbo.ThreadKeyPhrases tkp WITH(NOLOCK) ON tkp.ThreadID=tmp.threadid
		LEFT JOIN dbo.KeyPhrases threadphrases WITH(NOLOCK) ON threadphrases.PhraseID=tkp.PhraseID
		ORDER BY  tmp.id

		--drop table #tempthreads

		RETURN @@ERROR
END

