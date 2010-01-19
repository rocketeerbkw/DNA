CREATE PROCEDURE deletesiteoption @siteid int, @section varchar(50), @name varchar(50)
AS
	IF @siteid > 0
	BEGIN
		DELETE FROM SiteOptions WHERE SiteID = @siteid AND Section = @section AND Name = @name
	END
	
	RETURN @@ERROR