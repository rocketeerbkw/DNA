create procedure updatecommentforumstatus @uid varchar(255), @forumclosedate datetime = null, @modstatus int = null, @canwrite int = null
as
begin
	
	declare @forumUpdate bit
	set @forumUpdate =0
	
	declare @forumid int
	
	select @forumid = forumid from CommentForums where UID = @uid

	if (@forumclosedate is not null)
	begin
		update CommentForums
		set ForumCloseDate = @forumclosedate 
		where UID = @uid
		
		set @forumUpdate =1
	end

	if (@modstatus is not null)
	begin
		update Forums
		set ModerationStatus = @modstatus
		where ForumID = @forumid
		
		set @forumUpdate =1
	end

	if (@canwrite is not null)
	begin
		update Forums
		set CanWrite = @canwrite
		where ForumID = @forumid
	
		set @forumUpdate =1
	end
	
	--update last updated flag on forum
	if @forumUpdate =1
	BEGIN
		INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@forumid, getdate())
	END
end