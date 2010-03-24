IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'getusersposts')
	BEGIN
		DROP  Procedure  dbo.getusersposts
	END

GO


CREATE procedure getusersposts @userid int, @siteurlname nvarchar(30) = null, @startindex int = null, @itemsperpage int = null
as
begin
	declare @totalResults int

	if (@startindex is null) set @startindex = 0
	if (@itemsPerPage is null) set @itemsPerPage = 20

	if (@siteurlname is not null)
	begin

		declare @siteid int
		
		select @siteid = siteid from sites where urlname = @siteurlname
		select @totalResults = count(*) from VUsersPosts
									 where UserId = @userid
									 and HostId = @siteid;

		with cte_usersposts as
		(
			select row_number() over ( order by created desc) as n, Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription
			from VUsersPosts where UserId = @userid and HostId = @siteid
		)
		select
		Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription, @totalResults as TotalResults, @userid as UserID
		from cte_usersposts
		where n > @startindex and n <= @startindex + @itemsPerPage
		order by Created desc
	end
	else
	begin
		select @totalResults = count(*) from VUsersPosts
									 where UserId = @userid;

		with cte_usersposts as
		(
			select row_number() over ( order by created desc) as n, Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription
			from VUsersPosts where UserId = @userid
		)
		select
		Id, Title, Summary, Uri, Created, HostId, HostUri, HostUrlName, HostShortName, HostDescription, @totalResults as TotalResults, @userid as UserID
		from cte_usersposts
		where n > @startindex and n <= @startindex + @itemsPerPage
		order by Created desc
	end
	
	return @totalResults
end


	
GO

GRANT EXECUTE ON [dbo].[getusersposts] TO [ripleyrole]