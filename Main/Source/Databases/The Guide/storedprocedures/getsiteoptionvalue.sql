CREATE PROCEDURE getsiteoptionvalue @siteid int, @section varchar(50), @name varchar(50), @value varchar(6000) OUTPUT
AS
	SET @value=''
	SELECT @value=Value FROM SiteOptions WHERE SiteID=@siteid AND Section=@section AND Name=@name
	