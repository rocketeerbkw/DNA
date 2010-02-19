/*
This script takes a set of UserIDs, and displays the IP addresses associated with them.

In addition it finds other UserIDs that have used the same IP address to help spot when the same
person has created more than one user account.  This is by no means definitive, as the IP address
may be a shared one, e.g. assigned by an ISP, belong to a large organisatoin, etc.

Run against NewGuide, or in emergencies, the live DB.

Put the list of UserIDs in the list below (marked with "*****")

*/
create table #t1 (userid int, ip varchar(50))

-- find all the ip addresses associated with the list of users
insert into #t1
select distinct te.userid,IPAddress from threadentriesipaddress tip (nolock)
join threadentries te (nolock) on te.entryid=tip.entryid
where te.userid in ()  -- ***** Put list of UserIDs here

-- Select the list of ip addresses for each user
select u.userid,u.username,#t1.ip from #t1
join users u (nolock) on u.userid=#t1.userid
order by u.username

-- Find all the other user accounts that share the same IP addresses
select distinct #t1.userid,u.username,#t1.ip,te.userid,u2.username from #t1
join threadentriesipaddress tip (nolock) on tip.ipaddress = #t1.ip
join threadentries te (nolock) on te.entryid=tip.entryid
join users u (nolock) on u.userid=#t1.userid
join users u2 (nolock) on u2.userid=te.userid and #t1.userid<>u2.userid
order by u.username,#t1.ip

drop table #t1
