create procedure getvotelinkstotals @pollid int 
as
select l.relationship, count(*) linksn from links l, clubvotes cv 
where l.sourceid = cv.clubid and cv.voteid = @pollid
group by l.relationship

