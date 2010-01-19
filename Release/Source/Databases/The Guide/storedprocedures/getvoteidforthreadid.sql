CREATE PROCEDURE getvoteidforthreadid @ithreadid int
as
SELECT VoteID FROM ThreadVotes WHERE ThreadID = @ithreadid
