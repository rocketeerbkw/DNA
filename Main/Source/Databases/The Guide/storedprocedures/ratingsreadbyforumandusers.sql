CREATE procedure ratingsreadbyforumandusers @forumid int, @userlist varchar(max), @startindex int = null, @itemsperpage int = null, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
as

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

declare @totalresults int 
declare @average int 
if (@startindex is null) set @startindex = 0
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

-- get userid tmp table
declare @userIds table (userid varchar(40))
insert into @userIds 
select element from dbo.udf_splitint(@userlist);

-- get total
select @totalresults = count(*), @average = avg(rating)
from dbo.ForumReview fr
inner join signInUserIDMapping sium on sium.dnauserid = fr.userId
inner join @userIds u on u.userid = sium.identityuserId
where fr.forumid = @forumid



;with cte_usersposts as
(
	select row_number() over ( order by entryid asc) as n, EntryID
	from dbo.ForumReview fr
	inner join signInUserIDMapping sium on sium.dnauserid = fr.userId
	inner join @userIds u on u.userid = sium.identityuserId
	where forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'ascending'

	union all

	select row_number() over ( order by entryid desc) as n, EntryID
	from dbo.ForumReview fr
	inner join signInUserIDMapping sium on sium.dnauserid = fr.userId
	inner join @userIds u on u.userid = sium.identityuserId
	where forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'descending'

)
select cte_usersposts.n, 
	vu.*,
	@totalresults as totalresults,
	@average as average
from cte_usersposts
inner join VRatings vu on vu.Id = cte_usersposts.EntryID
where n > @startindex and n <= @startindex + @itemsPerPage



	