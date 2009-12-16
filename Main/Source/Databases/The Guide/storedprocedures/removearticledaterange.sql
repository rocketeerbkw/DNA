CREATE PROCEDURE removearticledaterange @entryid int
AS
	IF EXISTS (SELECT * FROM ArticleDateRange WHERE EntryID = @entryid)
	BEGIN
		DELETE FROM ArticleDateRange WHERE EntryID = @entryid
	END
