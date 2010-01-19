CREATE PROCEDURE senddnasystemmessage @userid INT, @siteid INT, @messagebody VARCHAR(8000), @dateposted DATETIME = NULL
AS
	/* 
		Inserts row into dbo.DNASystemMessages effectively sending a system message to a user. 
		@userid = recipient of system message. 
		@siteid = site the system message is associated with. When siteid = 0 it applied to all sites accross DNA. 
		@messagebody = message body. 
		@dateposted = date posted. 
	*/
	IF (@dateposted IS NULL)
	BEGIN	
		SELECT @dateposted = getdate()
	END

	INSERT INTO dbo.DNASystemMessages
	(
		UserID, 
		SiteID, 
		MessageBody, 
		DatePosted
	)
	VALUES 
	(
		@userid, 
		@siteid, 
		@messagebody, 
		@dateposted
	)

RETURN @@ERROR
