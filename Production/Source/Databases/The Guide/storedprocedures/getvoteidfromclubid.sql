CREATE PROCEDURE getvoteidfromclubid @iclubid int
As
SELECT VoteID FROM ClubVotes WHERE ClubID = @iclubid