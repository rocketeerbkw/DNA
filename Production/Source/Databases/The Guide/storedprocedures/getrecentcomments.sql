create procedure getrecentcomments @prefix varchar(255), @siteid INT
as
begin
	IF @prefix='movabletype%'
		RETURN

	IF @prefix='[_]%'
		RETURN

if charindex(',',@prefix) > 0
	set @prefix=substring(@prefix,charindex(',',@prefix)+1,len(@prefix))

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	select TOP(5) 
		t.EntryID, 
		t.ForumID, 
		t.ThreadID,
		t.PostIndex, 
		t.UserID, 
		u.FirstNames, 
		u.LastName, 
		u.Area,
		u.Status,
		u.TaxonomyNode,
		u.Active,
		'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END, 
		'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END, 
		NextSibling, 
		PrevSibling, 
		Parent, 
		FirstChild, 
		T.DatePosted, 
		Hidden,
		f.SiteID,
		'Interesting' = NULL,
		'ForumCanRead' = f.CanRead,
		'ForumCanWrite' = f.CanWrite,
		t.PostStyle,
		t.text,
		'ForumPostCount' = 0,
		f.AlertInstantly,
		f.ModerationStatus,
		'HostPageUrl' = cf.URL,
		cf.ForumCloseDate,
		'CommentForumTitle' = f.Title
	from
	dbo.VUserComments uc WITH(NOEXPAND)
	inner join dbo.CommentForums CF on CF.UID = uc.UID
	inner join dbo.Forums F on F.ForumID = CF.ForumID
	inner join dbo.ThreadEntries T on T.EntryID = uc.EntryID
	inner join dbo.Users U on U.UserID = T.UserID
	where uc.SiteId = @siteid AND uc.UID like @prefix
	order by uc.DatePosted desc
	OPTION (OPTIMIZE FOR (@prefix='%',@siteid=1))
end