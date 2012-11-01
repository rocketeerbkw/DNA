CREATE PROCEDURE gettwitterscreennamefromtwitteruserid @twitteruserids nvarchar(max) 
AS
IF (@twitteruserids <> '')
BEGIN
	create table #userids (ids [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL)
	insert into #userids select element from dbo.udf_splitvarcharwithdelimiter(@twitteruserids, ',')

	select LoginName AS TwitterScreenName
	from dbo.Users
		where userid in
		(
			Select dnauserid from dbo.SignInUserIDMapping where TwitterUserID in
			(
				select ids from #userids
			)
		)
	
	drop table #userids
END