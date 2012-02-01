create procedure processpostingqueue --@content text
as
declare @queueid int, @userid int, 
							@forumid int, 
							@inreplyto int, 
							@threadid int, 
							@subject varchar(255), 
					--		@content text, 
							@poststyle int, 
							@hash uniqueidentifier, 
							@keywords varchar(255), 
							@nickname varchar(255), 
							@type varchar(30), 
							@eventdate datetime, 
							@forcemoderate tinyint , 
							@forcepremoderation tinyint, 
							@ignoremoderation tinyint,
							@clubid int, 
							@nodeid int,
							@keyphrases varchar(5000),
							@ipaddress varchar(25),
							@bbcuid uniqueidentifier, 
							@iscomment tinyint
WHILE 1=1
BEGIN

	select top 1				@queueid = QueueID,
								@userid = userID, 
								@forumid = forumid, 
								@inreplyto = InReplyTo, 
								@threadid = ThreadID, 
								@subject = Subject, 
								--@content  = Content, 
								@poststyle = PostStyle, 
								@hash = Hash, 
								@keywords = keywords, 
								@nickname = nickname, 
								@type = type, 
								@eventdate = eventdate, 
								@forcemoderate = forcemoderate, 
								@forcepremoderation = forcepremoderation, 
								@ignoremoderation = ignoremoderation,
								@clubid = clubid, 
								@nodeid = nodeid,
								@keyphrases = keyphrases,
								@ipaddress = IPAddress,
								@bbcuid = BBCUID, 
								@IsComment = IsComment
				from PostingQueue order by QueueID
	if @queueid IS NOT NULL
	BEGIN
		declare @returnthreadid int, @returnpostid int, @premodpostingmodid int, @ispremoderated int
		EXEC posttoforuminternal @userid, @forumid, @inreplyto, @threadid, @subject, '', 
				@poststyle, @hash, @keywords, @nickname, @returnthreadid OUTPUT, @returnpostid OUTPUT
				, @type, @eventdate, @forcemoderate, @forcepremoderation, @ignoremoderation, DEFAULT, @nodeid, @ipaddress, @queueid, DEFAULT, @premodpostingmodid, @ispremoderated, @bbcuid, @IsComment
				
--		Update ThreadEntries set text = p.Content
--		from ThreadEntries t, PostingQueue p
--		WHERE t.EntryID = @returnpostid AND p.QueueID = @queueid
		delete from Postingqueue where QueueID = @queueid
		set @queueid = NULL
	END
	ELSE
	BEGIN
		WAITFOR DELAY '00:00:01'
	END
END