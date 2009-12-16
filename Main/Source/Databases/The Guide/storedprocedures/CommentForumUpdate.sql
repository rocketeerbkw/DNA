CREATE PROCEDURE commentforumupdate @uid varchar(255), @url varchar(255), @title nvarchar(255), @sitename varchar(255), @moderationstatus int, @closedate datetime
AS
BEGIN TRANSACTION
	
	declare @siteid int
	declare @forumid int
	select @siteid = siteid from sites where urlname = @sitename
	IF (@siteid is null)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error -1
		RETURN -1
	END
	
	select @forumid = forumid 
	from commentforums
	where uid=@uid and siteid=@siteid
	IF (@forumid is null)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error -1
		RETURN -1
	END
	--update commentforum elements
	update commentforums
	set
	url = @url,
	forumclosedate = @closedate
	where forumid=@forumid
	
	--update forum elements
	UPDATE Forums 
	Set 
	Title = @title,
	moderationstatus = @moderationstatus
	WHERE ForumID = @forumid
	
	INSERT INTO ForumLastUpdated(forumid, lastupdated) values (@forumid, getdate())
	
COMMIT TRANSACTION

