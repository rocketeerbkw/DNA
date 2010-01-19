CREATE PROCEDURE setsiteoption @siteid int, @section varchar(50), @name varchar(50), @value varchar(6000)
AS
	IF NOT EXISTS(SELECT * FROM SiteOptions WHERE SiteID=0 AND Section=@section AND Name = @name)
	BEGIN
		-- This site option is not defined
		RETURN 0
	END

	IF @siteid=0 OR EXISTS(SELECT * FROM SiteOptions WHERE SiteID=@SiteID AND Section=@section AND Name = @name)
	BEGIN
		UPDATE SiteOptions SET Value = @value
			WHERE SiteID = @siteid AND Section = @section AND Name=@name
	END
	ELSE
	BEGIN
		INSERT INTO SiteOptions (SiteID,Section,Name,Value,Type,Description)
			SELECT @siteid,@section,@name,@value,Type,Description FROM SiteOptions
				WHERE SiteID=0 AND Section=@section AND Name=@name
	END

	RETURN @@ERROR