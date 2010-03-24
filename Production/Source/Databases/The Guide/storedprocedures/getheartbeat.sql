create procedure getheartbeat @siteid int, @time datetime = null, @interval int = 5
as
set transaction isolation level read uncommitted
if @time is null
begin
	set @time = getdate()
end
select top 200 * from threadentries t join forums f on f.forumid = t.forumid
where t.dateposted > dateadd(minute, -@interval, @time) and t.Dateposted <= @time and f.siteid = @siteid
order by t.DatePosted