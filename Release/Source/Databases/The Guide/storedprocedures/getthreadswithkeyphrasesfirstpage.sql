CREATE PROCEDURE getthreadswithkeyphrasesfirstpage @forumid int
AS

--Get count of all threads for site. 
DECLARE @threadcount INT
SELECT @threadcount = COUNT(*)
FROM Threads th WITH(NOLOCK)
WHERE th.forumid = @forumid AND th.VisibleTo IS NULL

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
		from 
		(
			-- Select only the first 20 threads
			select top 20 threadid, t.forumid, t.lastposted,ThreadPostCount,FirstSubject, DateCreated,type,eventdate
			from dbo.threads t with ( NOLOCK)
			where t.forumid = @forumid and t.visibleto is null
			order by t.lastposted DESC
		) as t
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = t.ForumID and f.forumid = @forumid
		INNER JOIN dbo.ThreadEntries te  WITH(NOLOCK) ON te.Threadid = t.ThreadID AND te.PostIndex = 0
		INNER JOIN dbo.ThreadEntries te1 WITH(NOLOCK) ON te1.ThreadID = t.ThreadID AND te1.PostIndex = t.ThreadPostCount-1
		
		--Get all the phrases associated with each thread.
		LEFT JOIN dbo.ThreadKeyPhrases tkp WITH(NOLOCK) ON tkp.ThreadID=t.threadid
		LEFT JOIN dbo.KeyPhrases threadphrases WITH(NOLOCK) ON threadphrases.PhraseID=tkp.PhraseID
		ORDER BY  t.lastposted desc

		--drop table #tempthreads

		RETURN @@ERROR