CREATE PROCEDURE linkguideentrytoroute @routeid int, @h2g2id int
AS
	DECLARE @EntryID INT
	SELECT @EntryID = @h2g2id / 10
	UPDATE Route SET EntryID = @EntryID WHERE RouteID = @routeid

RETURN @@ERROR
