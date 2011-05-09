
select accumulativescore, count(*) as 'totalusers'
from UserReputationScore
where modclassid = 19--news
group by accumulativescore
order by accumulativescore desc

-------------------------post numbers

select sum(numberofposts) as 'TrustedPosts'
from userpostevents
where modclassid = 19--news
and accumulativescore > 5


select sum(numberofposts) as 'NormalPosts'
from userpostevents
where modclassid = 19--news
and accumulativescore >= 0
and accumulativescore <= 5


select sum(numberofposts) as 'PostModPosts'
from userpostevents
where modclassid = 19--news
and accumulativescore >= -5
and accumulativescore < 0


select sum(numberofposts) as 'PreModPosts'
from userpostevents
where modclassid = 19--news
and accumulativescore >= -10
and accumulativescore < -5


select sum(numberofposts) as 'BannedPosts'
from userpostevents
where modclassid = 19--news
and accumulativescore < -10

-------------------------user numbers

select count(*) as 'TrustedUsers'
from userreputationscore
where modclassid = 19--news
and accumulativescore > 5

select count(*) as 'NormalUsers'
from userreputationscore
where modclassid = 19--news
and accumulativescore >= 0
and accumulativescore <= 5


select count(*) as 'PostModUsers'
from userreputationscore
where modclassid = 19--news
and accumulativescore >= -5
and accumulativescore < 0

select count(*) as 'PreModUsers'
from userreputationscore
where modclassid = 19--news
and accumulativescore >= -10
and accumulativescore < -5

select count(*) as 'BannedUsers'
from userreputationscore
where modclassid = 19--news
and accumulativescore < -10
