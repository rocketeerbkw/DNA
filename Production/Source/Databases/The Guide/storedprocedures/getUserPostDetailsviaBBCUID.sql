CREATE PROCEDURE getuserpostdetailsviabbcuid @bbcuid uniqueidentifier
AS
	IF (@bbcuid = '00000000-0000-0000-0000-000000000000')
	BEGIN
		RETURN
	END
	
	SELECT u.userid, u.username, te.forumid, te.threadid, te.entryid, te.postindex, te.dateposted 
	FROM ThreadEntriesIPAddress tip WITH(NOLOCK)
	INNER JOIN ThreadEntries te  WITH(NOLOCK) ON te.entryid = tip.entryid
	INNER JOIN Users u WITH(NOLOCK) ON u.userid = te.userid
	WHERE tip.BBCUID=@bbcuid
	ORDER BY te.dateposted desc
	