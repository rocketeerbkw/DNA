CREATE    PROCEDURE verifyuseragainstbannedipaddress @userid int, @siteid int, @ipaddress varchar(25)=null, @bbcuid uniqueidentifier=null
AS

IF @ipaddress is null or @bbcuid is null
BEGIN
	RETURN
END

if @bbcuid = '00000000-0000-0000-0000-000000000000'
BEGIN 
	RETURN
END

IF exists(select * from bannedipaddress where ipaddress=@ipaddress and bbcuid=@bbcuid)
BEGIN

	exec updatetrackedmemberlistinternal
		@userids= @userid,
		@siteids= @siteid, 
		@prefstatus=4, --banned
		@prefstatusduration=0,
		@reason='Matching banned ipaddress/BBC UID combination found',
		@viewinguser=5-- system user

END