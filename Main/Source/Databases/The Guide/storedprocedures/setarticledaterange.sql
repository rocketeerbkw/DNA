CREATE PROCEDURE setarticledaterange @entryid int, @startdate datetime, @enddate datetime, @timeinterval int
AS
	IF @timeinterval <= 0
	BEGIN
		SET @timeinterval = null
	END

	IF EXISTS (SELECT * FROM ArticleDateRange WHERE EntryID = @entryid)
	BEGIN
		UPDATE ArticleDateRange
			SET StartDate=@startdate, EndDate=@enddate, TimeInterval=@timeinterval
			WHERE EntryID=@entryid
	END
	ELSE
	BEGIN
		INSERT INTO ArticleDateRange(EntryID, StartDate, EndDate, TimeInterval)
			VALUES (@entryid, @startdate, @enddate, @timeinterval)
	END
