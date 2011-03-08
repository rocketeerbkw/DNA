CREATE PROCEDURE commentforumreadbyuid @uid varchar(255), @siteurlname varchar(30)
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	select  uid as uid
	, sitename
	,title
	, forumpostcount
	, moderationstatus
	, datecreated
	,  lastupdated
	, url
	, isnull(forumclosedate, getdate()) as forumclosedate 
	, 0 as totalresults
	, 0 as startindex
	, 0 as itemsperpage
	,  siteId
	, forumId
	, canRead
	, canWrite
	, lastposted
	, editorpickcount
	, NotSignedInUserId
	from dbo.VCommentForums 
	where uid = @uid
	and sitename = @siteurlname

