CREATE    PROCEDURE verifyuseragainstbannedipaddress @userid int, @siteid int, @ipaddress varchar(25)=null, @bbcuid uniqueidentifier=null
AS

IF @ipaddress is null and @bbcuid is null
BEGIN
	RETURN
END

IF exists(select * from bannedipaddress where ipaddress=@ipaddress and bbcuid=@bbcuid)
BEGIN

	exec updatetrackedmemberlist
		@userids= @userid,
		@siteids= @siteid, 
		@prefstatus=4, --banned
		@prefstatusduration=0,
		@reason='Matching banned ipaddress/BBC UID combination found',
		@viewinguser=6

END