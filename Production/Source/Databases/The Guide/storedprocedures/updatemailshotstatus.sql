CREATE PROCEDURE updatemailshotstatus	@shotid int,
						@status int
AS
RAISERROR('updatemailshotstatus DEPRECATED',16,1)

/*
	Deprecated - never called
	
	-- First update the number of mails sent
	UPDATE MailShots 
		SET TotalSent = (SELECT COUNT(ShotID) FROM SendRequests WHERE ShotID = @shotid AND SentFlag = 1), 
		TotalToSend = (SELECT COUNT(ShotID) FROM SendRequests WHERE ShotID = @shotid AND SentFlag = 0),
		Status= @status
		WHERE ShotID = @shotid
*/		