CREATE PROCEDURE addvotetoclubtable @iclubid int, @ivoteid int
As
IF NOT EXISTS ( SELECT ClubID FROM ClubVotes WHERE ClubID = @iclubid )
BEGIN
	BEGIN TRANSACTION
	INSERT INTO ClubVotes(ClubID,VoteID) VALUES(@iclubid,@ivoteid)
	DECLARE @Error int
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	COMMIT TRANSACTION
END
SELECT Name FROM Clubs WHERE ClubID = @iclubid