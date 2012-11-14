CREATE PROCEDURE createsitenotes @userid int, @siteid int, @notes nvarchar(max)
AS
insert into dbo.siteupdate
	select
		userid = @userid,
		siteid = @siteid,
		notes = @notes