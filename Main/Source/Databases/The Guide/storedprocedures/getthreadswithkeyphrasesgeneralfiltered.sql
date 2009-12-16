CREATE PROCEDURE getthreadswithkeyphrasesgeneralfiltered @forumid int, @keyphraselist VARCHAR(8000), @firstindex int = 0, @lastindex int = 20
AS

--If there's not comma, it's a single phrase, so call the simpler version
IF CHARINDEX('|',@keyphraselist) = 0
BEGIN
 	DECLARE @err int
 	EXEC @err = getthreadswithkeyphrasesgeneralfiltered1 @forumid,@keyphraselist,@firstindex, @lastindex
 	SET @err = dbo.udf_checkerr(@@ERROR,@err)
 	RETURN @err
END

DECLARE @phrasetable table (phraseid int)
INSERT @phrasetable 
	SELECT kp.phraseid
		FROM udf_splitvarchar(@keyphraselist) as s
		INNER JOIN dbo.KeyPhrases kp WITH(NOLOCK) on kp.phrase = s.element

--Get phrase count.
DECLARE @count INT; 
SELECT @count = @@ROWCOUNT

--Do Skip and Show by creating a temp table with the relevant entries
CREATE TABLE #tempfilterthreads (id int NOT NULL IDENTITY(0,1), ThreadID int NOT NULL)
INSERT INTO #tempfilterthreads (ThreadID)
SELECT tkp.ThreadID
	FROM @phrasetable as s
	INNER JOIN dbo.ThreadKeyPhrases tkp  WITH(NOLOCK) ON tkp.phraseid = s.phraseid
	INNER JOIN dbo.Threads th  WITH(NOLOCK) ON th.ThreadId = tkp.ThreadId AND th.VisibleTo IS NULL AND th.forumid=@forumid
	GROUP BY tkp.ThreadID,th.LastPosted HAVING count(s.PhraseID) = @count
	ORDER BY th.LastPosted DESC

	DECLARE @threadcount int
	SET @threadcount=@@ROWCOUNT 
	
	--Remove entries that are not wanted.	
	DELETE FROM #tempfilterthreads where id > @lastindex or id < @firstindex

	SELECT
		t.Forumid, 
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

		FROM #tempfilterthreads tmp
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadId = tmp.ThreadId
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.forumid=@forumid
		INNER JOIN dbo.ThreadEntries te WITH(NOLOCK) ON te.Threadid = t.ThreadID AND te.PostIndex = 0
		INNER JOIN dbo.ThreadEntries te1 WITH(NOLOCK) ON te1.ThreadID = t.ThreadID AND te1.PostIndex = t.ThreadPostCount-1

		INNER JOIN dbo.ThreadKeyPhrases tkp WITH(NOLOCK) ON tkp.ThreadID=tmp.threadid
		INNER JOIN dbo.KeyPhrases threadphrases WITH(NOLOCK) ON threadphrases.PhraseID=tkp.PhraseID

		ORDER BY tmp.id

		drop table #tempfilterthreads
		
		RETURN @@ERROR