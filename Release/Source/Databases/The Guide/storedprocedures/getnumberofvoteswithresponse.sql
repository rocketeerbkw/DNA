CREATE PROCEDURE getnumberofvoteswithresponse @ivoteid int, @iresponse int
as
DECLARE @VisibleUsers int
DECLARE @HiddenUsers int
SET @VisibleUsers = (SELECT COUNT(*) FROM VoteMembers WHERE VoteID = @ivoteid AND Response = @iresponse AND Visible = 1)
SET @HiddenUsers = (SELECT COUNT(*) FROM VoteMembers WHERE VoteID = @ivoteid AND Response = @iresponse AND Visible = 0)
SELECT 'Visible' = @VisibleUsers, 'Hidden' = @HiddenUsers
