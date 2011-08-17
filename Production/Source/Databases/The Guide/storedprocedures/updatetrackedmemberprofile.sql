--depreciated storedprocedure
create procedure updatetrackedmemberprofile 
	@userid int, 
	@siteid int, 
	@prefstatus int, 
	@prefstatusduration int, 
	@usertags varchar(255),
	@applytoaltids bit = 0,
	@allprofiles bit = 0
as
	RAISERROR('updatetrackedmemberprofile DEPRECATED',16,1)

/*
	Deprecated - This relies on data in UsersTags table.  This table on live is empty, so this SP cannot be used anymore

begin
	create table #usertagids (tagid int)
	
	--create a table with the tag id in it
	insert into #usertagids (tagid)
	select element from udf_splitvarchar(@usertags)
		
	update preferences
	set PrefStatus = @prefstatus,
		PrefStatusduration = @prefstatusduration,
		PrefStatuschangeddate = CASE WHEN @PrefStatus = 0 THEN NULL ELSE GETDATE() END
	where userid = @userid and siteid = @siteid
	
	delete from userstags 
	where userid = @userid and siteid = @siteid
	
	insert into userstags(usertagid, userid, siteid)
	select tagid, @userid, @siteid
	from #usertagids
	
	EXEC openemailaddresskey
	
	declare @email varchar(255)
	select @email = NULLIF(dbo.udf_decryptemailaddress(U2.EncryptedEmail,U2.UserId),'0') from Users U2 where UserID = @userid

	if (@email is not null)
	begin
		if (@applytoaltids = 1)
		begin
			create table #userids (userid int)

			--alt id's - same email address on the same site
			insert into #userids (userid)
			select u.userid 
			from Users u WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID
			where HashedEmail = dbo.udf_hashemailaddress(@email) and P.SiteID = @siteid

			delete from userstags 
			where userid in (select userid from #userids) and siteid = @siteid
			
			insert into userstags (usertagid, userid, siteid)
			select tagid, u.UserID, @siteid
			from #usertagids, #userids u
			
			update preferences
			set prefstatus = @prefstatus,
				prefstatusduration = @prefstatusduration,
				PrefStatuschangeddate = CASE WHEN @PrefStatus = 0 THEN NULL ELSE GETDATE() END
			where userid in (select userid from #userids) and siteid = @siteid

			drop table #userids
		end
		
		if (@allprofiles = 1)
		begin
			create table #useridsbysite (userid int, siteid int)

			--all profiles - same email address across all sites
			insert into #useridsbysite (userid, siteid)
			select DISTINCT u.userid, p.siteid
			from Users u WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID
			where HashedEmail = dbo.udf_hashemailaddress(@email)

			delete userstags
			from userstags ut
			inner join #useridsbysite ui on ui.userid = ut.userid and ui.siteid = ut.siteid

			insert into userstags (usertagid, userid, siteid)
			select ut.tagid, us.userid, us.siteid
			from #usertagids ut, #useridsbysite us
	        
			update preferences
			set prefstatus = @prefstatus,
				prefstatusduration = @prefstatusduration,
				PrefStatuschangeddate = CASE WHEN @PrefStatus = 0 THEN NULL ELSE GETDATE() END
			where userid in (select distinct userid from #useridsbysite)
		
			drop table #useridsbysite
		end
	end
	
	drop table #usertagids
end
*/
