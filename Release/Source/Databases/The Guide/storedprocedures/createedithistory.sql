CREATE PROCEDURE createedithistory @entryid int, @userid int, @action int = 0, @dateperformed datetime = NULL, @comment varchar(255) = NULL
AS
IF (@dateperformed IS NULL)
SELECT @dateperformed = getdate()
INSERT INTO EditHistory (EntryID, UserID, DatePerformed, Action, Comment)
VALUES(@entryid, @userid, @dateperformed, @action, @comment)
