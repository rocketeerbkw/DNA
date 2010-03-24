CREATE PROCEDURE addvotetothreadtable @ithreadid int, @ivoteid int
As
IF NOT EXISTS( SELECT @ithreadid FROM ThreadVotes WHERE ThreadID = @ithreadid )
BEGIN
	BEGIN TRANSACTION
	BEGIN
		INSERT INTO ThreadVotes(ThreadID,VoteID) VALUES(@ithreadid,@ivoteid)
	END
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END
	COMMIT TRANSACTION
END