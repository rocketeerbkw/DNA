CREATE PROCEDURE fetcheditmarks @entryid int
AS
SELECT EntryID, Editor, Mark, Comment
FROM EditMarks
WHERE EntryID = @entryid