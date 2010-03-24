CREATE PROCEDURE createyourworldentry
@entryid int,
@topic varchar(100),
@country varchar(100),
@city varchar(100),
@region varchar(100),
@detail varchar(150)
 AS
INSERT INTO YourWorldEntries (EntryID, Topic, Country, City, Region, Detail)
VALUES(@entryid, @topic, @country, @city, @region, @detail)


