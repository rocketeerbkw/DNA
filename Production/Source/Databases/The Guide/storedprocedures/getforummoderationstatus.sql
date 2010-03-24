Create Procedure getforummoderationstatus @forumid int, @threadid int
As

declare @moderationstatus int

if @threadid = 0
BEGIN

	select @moderationstatus=ModerationStatus from Forums F where F.ForumID = @forumid 

END
-- use the threadid to get the forum id if it has been provided as that
-- takes precedence
ELSE
BEGIN
	select top 1 @moderationstatus=ModerationStatus from Forums F 
		WHERE F.ForumID IN (SELECT ForumID FROM Threads WHERE ThreadID = @threadid)
END

if not(@moderationstatus IS NULL)
BEGIN
	select 'ModerationStatus' = @moderationstatus
END
