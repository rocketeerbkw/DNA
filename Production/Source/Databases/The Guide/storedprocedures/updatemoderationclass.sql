CREATE PROCEDURE updatemoderationclass @modclassid INT, @swapsortorder INT = NULL
AS
	DECLARE @sortorder INT
	DECLARE @newsortorder INT
	SELECT @sortorder = sortorder FROM ModerationClass WHERE modclassid = @modclassid

	IF @swapsortorder > 0 
	BEGIN
		SELECT @newsortorder = MIN(sortorder) 
		FROM ModerationClass 
		WHERE sortorder > @sortorder
	END
	ELSE IF @swapsortorder < 0 
	BEGIN
		SELECT @newsortorder = MAX(sortorder) 
		FROM ModerationClass 
		WHERE sortorder < @sortorder
	END

	IF @newsortorder IS NOT NULL
	BEGIN
		--Switch the sort order.
		UPDATE ModerationClass
		SET sortorder = @sortorder 
		WHERE sortorder = @newsortorder
		
		UPDATE ModerationClass
		SET sortorder = @newsortorder 
		WHERE modclassid = @modclassid
	END