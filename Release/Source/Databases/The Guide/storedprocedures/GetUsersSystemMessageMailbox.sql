CREATE PROCEDURE getuserssystemmessagemailbox @userid INT, @siteid INT = NULL, @skip INT = 0, @show INT = 20
AS
	DECLARE @TotalNumberOfMessages INT

	IF (@siteid IS NULL)
	BEGIN
		SELECT @TotalNumberOfMessages = count(*)
		  FROM dbo.DNASystemMessages WITH (NOLOCK)
		 WHERE UserID = @userid;

		WITH DateOrderedDNASystemMessages (MsgId, UserID, SiteID, MessageBody, DatePosted, ordernum)
		AS 
		(
			SELECT MsgId, UserID, SiteID, MessageBody, DatePosted, 
			       ROW_NUMBER() OVER(ORDER BY MsgID DESC) AS ordernum
			  FROM dbo.DNASystemMessages WITH (NOLOCK)
			 WHERE UserID = @userid
		)
		SELECT @TotalNumberOfMessages AS 'TotalCount', * FROM DateOrderedDNASystemMessages WHERE ordernum BETWEEN (@skip + 1) AND (@skip + @show)
	END 
	ELSE
	BEGIN
		SELECT @TotalNumberOfMessages = count(*)
		  FROM dbo.DNASystemMessages WITH (NOLOCK)
		 WHERE UserID = @userid
		   AND SiteID = @siteid;

		WITH DateOrderedDNASystemMessages (MsgId, UserID, SiteID, MessageBody, DatePosted, ordernum)
		AS 
		(
			SELECT MsgId, UserID, SiteID, MessageBody, DatePosted,
			       ROW_NUMBER() OVER(ORDER BY MsgID DESC) AS ordernum
			  FROM dbo.DNASystemMessages WITH (NOLOCK)
			 WHERE UserID = @userid
			   AND SiteID = @siteid
		)
		SELECT @TotalNumberOfMessages AS 'TotalCount', * FROM DateOrderedDNASystemMessages WHERE ordernum BETWEEN (@skip + 1) AND (@skip + @show)
	END

RETURN @@ERROR