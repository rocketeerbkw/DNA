CREATE PROCEDURE createsitenotes @userid int, @siteid int, @notes nvarchar(max)
AS
insert into dbo.siteupdate(userid, siteid, notes)
values(@userid,@siteid,@notes)