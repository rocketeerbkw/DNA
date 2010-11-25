CREATE PROCEDURE [dbo].[impressionswrite] @date datetime, @machine_name varchar(50), @http_method varchar(50), 
	@http_status varchar(50), @url varchar(100), @site varchar(50), @count int, @min int, @max int, @avg int
AS
BEGIN
	SET NOCOUNT ON;
	
	--declare id variables
	declare @machine_nameid int
	declare @http_methodid int
	declare @http_statusid int
	declare @urlid int
	declare @siteid int

	--call sps to return ID values
	exec http_methodget @http_method, @http_methodid output
	exec machine_nameget @machine_name, @machine_nameid output
	exec http_statusget @http_status, @http_statusid output
	exec urlget @url, @urlid output
	exec siteget @site, @siteid output
	
	-- do update
	update impressions
	set
	count = @count, min=@min, max=@max, avg=@avg
	where
	date = @date and http_method = @http_methodid and machine_name = @machine_nameid
	and http_status = @http_statusid and url = @urlid and site = @siteid

	--check if updated - otherwise insert
	if @@rowcount = 0
	BEGIN
		insert into impressions	
		(date,http_method,machine_name,http_status,url,site, count, min, max, avg)
		values
		(@date,@http_methodid,@machine_nameid,@http_statusid,@urlid,@siteid,@count,@min,@max,@avg)
	END
END


