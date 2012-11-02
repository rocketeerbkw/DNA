create procedure createworldservicesite
	@siteslug nvarchar(50),
	@sitedescription nvarchar(50),
	@sitelanguage nvarchar(10),
	@customhouserulesurl nvarchar(250)
as
begin
	if not exists (select siteid from sites where shortname = @siteslug)
	begin
	
		declare @complainturl  nvarchar(250)
		set @complainturl = 'http://www.bbc.co.uk/dna/[sitename]/comments-' + 
						@sitelanguage + '/UserComplaintPage?PostID=[postid]&s_start=1'
						
		-- Create new site
		declare @addnotes nvarchar(50)
		set @addnotes = N'Adding ' + @siteslug + ' service'
		 
		exec createnewsite 
			@urlname=@siteslug,
			@shortname=@siteslug,
			@description=@sitedescription,
			@ssoservice=@siteslug,
			@defaultskin=N'html',
			@skindescription=N'html',
			@skinset=N'vanilla',
			@useframes=0,
			@premoderation=0,
			@noautoswitch=0,
			@customterms=0,
			@moderatorsemail=N'DNA.Moderators@bbc.co.uk',
			@editorsemail=N'DNA.Moderators@bbc.co.uk',
			@feedbackemail=N'DNA.Moderators@bbc.co.uk',
			@automessageuserid=294,
			@passworded=0,
			@unmoderated=0,
			@articleforumstyle=0,
			@threadorder=1,
			@threadedittimelimit=0,
			@eventalertmessageuserid=0,
			@eventemailsubject=N'',
			@includecrumbtrail=0,
			@allowpostcodesinsearch=0,
			@allowremovevote=0,
			@queuepostings=0,
			@IdentityPolicy=N'http://identity/policies/dna/adult',
			@modclassid=8,
			@bbcdivisionid=0,
			@sampleurl=N'',
			@notes=addnotes,
			@viewinguser=6,
			@contactformsemail=N''
		
		-- get the newly created site's id - we need this to add options	
		declare @newsiteid int	
		select @newsiteid = siteid from sites where shortname = @siteslug
		
		-- these are the options we're setting for each site
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='CommentForum',
			@name='AllowNotSignedInCommenting',
			@value='1'
		
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='CommentForum',
			@name='MaxCommentCharacterLength',
			@value='500'
			
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='CommentForum',
			@name='UseIDV4',
			@value='1'
			
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='General',
			@name='SiteLanguage',
			@value=@sitelanguage
			
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='General',
			@name='SiteType',
			@value='4'
			
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='Moderation',
			@name='CustomHouseRuleURL',
			@value=@customhouserulesurl
			
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='General',
			@name='ComplaintUrl',
			@value=@complainturl
			
		exec dbo.setsiteoption 
			@siteid=@newsiteid,
			@section='SignIn',
			@name='UseIdentitySignIn',
			@value='1'
	end
end