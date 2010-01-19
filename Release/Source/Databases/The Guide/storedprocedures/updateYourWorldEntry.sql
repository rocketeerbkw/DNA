CREATE PROCEDURE updateyourworldentry
@entryid int,
@topic varchar(100),
@country varchar(100),
@city varchar(100),
@region varchar(100),
@detail varchar(150)
 AS
Update YourWorldEntries
SET Topic = @topic,
Country=@country,
City=@city,
Region=@region,
Detail=@detail
WHERE EntryID=@entryid


