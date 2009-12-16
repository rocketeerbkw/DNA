create procedure getlinkgroups @sourcetype varchar(30), @sourceid int
as
select Type, 'TotalLinks' = COUNT(*) FROM Links WHERE SourceType = @sourcetype AND SourceID = @sourceid GROUP BY Type 