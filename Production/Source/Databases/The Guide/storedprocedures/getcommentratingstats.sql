--Hack day SP needs some tweekings and shoule be integrated 
CREATE PROCEDURE getcommentratingstats @forumid int
AS
BEGIN
		select f.forumpostcount, f.title,--f.LastPosted, 
		SUM(tr.value) as totalrating, count(tr.entryid) as noratings, AVG(CAST (tr.value AS FLOAT)) as avgvalue, tr.entryid, tr.forumid
		from commentforums cf
		inner join forums f on cf.forumid = f.forumid
		inner join ThreadEntryRating tr on cf.forumid = tr.forumid and cf.siteid = tr.siteid
		where cf.siteid = 492 and f.forumid = @forumid
		and f.lastposted < GETDATE() and f.lastposted > GETDATE() - 7
		group by tr.entryid, tr.forumid, f.forumpostcount, f.title, f.lastposted
		order by  f.LastPosted desc, f.forumpostcount desc

END
