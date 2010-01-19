CREATE PROCEDURE dbu_createsiteoption   @siteid int, @section varchar(50), @name varchar(50), 
										@value varchar(6000), @type int, @description varchar(1000)
AS
	INSERT INTO SiteOptions (SiteID,Section,Name,Value,Type,Description)
		VALUES (@siteid,@section,@name,@value,@type,@description)
