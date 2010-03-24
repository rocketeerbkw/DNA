IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'getuserscomments')
	BEGIN
		DROP  Procedure  dbo.getuserscomments
	END

GO

CREATE procedure getuserscomments @userid int, @siteurlname nvarchar(30) = null, @startindex int = null, @itemsperpage int = null
as
begin
	declare @totalResults int

	if (@startindex is null) set @startindex = 0
	if (@itemsPerPage is null) set @itemsPerPage = 20

	if (@siteurlname is not null)
	begin

		declare @siteid int
		select @totalResults = count(*) from VUsersComments
									 where UserId = @userid
									 and HostId = @siteid;

		with cte_usersposts as
		(
			select row_number() over ( order by created desc) as n, Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription, forumid, text
			from VUsersComments where UserId = @userid and HostId = @siteid
		)
		select
		Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription, @totalResults as TotalResults, @userid as UserID, 
		@startindex as startindex, @itemsPerPage as itemsPerPage, forumid, text
		from cte_usersposts
		where n > @startindex and n <= @startindex + @itemsPerPage
		order by Created desc
	end
	else
	begin
		select @totalResults = count(*) from VUsersComments
									 where UserId = @userid;

		with cte_usersposts as
		(
			select row_number() over ( order by created desc) as n, Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription, forumid, text
			from VUsersComments where UserId = @userid
		)
		select
		Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription, @totalResults as TotalResults, @userid as UserID,
		@startindex as startindex, @itemsPerPage as itemsPerPage, forumid, text
		from cte_usersposts
		where n > @startindex and n <= @startindex + @itemsPerPage
		order by Created desc
	end
	
	return @totalResults
end

	
GO

GRANT EXECUTE ON [dbo].[getuserscomments] TO [ripleyrole]