CREATE PROCEDURE createeditmarks @entryid int, @editor int, @mark int, @comment varchar(255)
AS
INSERT INTO EditMarks (EntryID, Editor, Mark, Comment) VALUES(@entryid, @editor, @mark, @comment)
