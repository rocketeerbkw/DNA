CREATE PROCEDURE createnewvote @itype int, @dclosedate datetime, @iyesno TinyInt, @iownerid int, @iresponsemin int = NULL, @iresponsemax int = NULL, @allowanonymousrating TinyInt = NULL
As
DECLARE @iVoteID int
BEGIN TRANSACTION
BEGIN
	INSERT INTO Votes(Type,DateCreated,ClosingDate,YesNoVoting,OwnerID,ResponseMin,ResponseMax, AllowAnonymousRating)
	VALUES (@itype,GetDate(),@dclosedate,@iyesno,@iownerid,@iresponsemin,@iresponsemax, @allowanonymousrating)
	SET @iVoteID = @@IDENTITY
	SELECT VoteID, DateCreated FROM Votes WHERE VoteID = @iVoteID
END
IF (@@ERROR <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END
COMMIT TRANSACTION