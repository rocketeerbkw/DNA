Create Procedure forumgetthreadlist  @forumid int, @firstindex int, @lastindex int, @threadorder int,  @querytype int = 2, @includestickythreads bit =0
As
DECLARE @threadcount int
DECLARE @canread int, @canwrite int, @siteid int, @threadcanread int, @threadcanwrite int, @AlertInstantly int
DECLARE @moderationstatus int
declare @forumpostcount int
declare @notablesgroup int
select @notablesgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Notables'

--create table #tempthreads (id int NOT NULL IDENTITY(0,1)PRIMARY KEY, ThreadID int NOT NULL)

SELECT @threadcount = COUNT(*)
	FROM Threads WITH(NOLOCK)
	WHERE ForumID = @forumid AND VisibleTo IS NULL

SELECT @canread = CanRead, 
	@canwrite = CanWrite, 
	@threadcanread = ThreadCanRead, 
	@threadcanwrite = ThreadCanWrite, 
	@siteid = SiteID, 
	@moderationstatus = ModerationStatus, 
	@AlertInstantly = AlertInstantly,
	@forumpostcount = ForumPostCount
	FROM Forums WITH(NOLOCK)
	WHERE ForumID = @forumid
	
select @forumpostcount = @forumpostcount + isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = @forumid

-- Bodge for 6 Music (Peta) to force some forums to have the "datecreated" thread order
/* Removed on request from Peta and Jem on live on 23/3/10
 * I've left the code in for now, so it's quick to re-instate when they change their minds again.
IF @forumid=14074635 or @forumid=14107994 or @forumid=14126215
BEGIN
	SET @threadorder = 2
END
*/

IF (@threadcount > 0 AND @firstindex < @threadcount)
BEGIN

		IF @threadorder = 2
		BEGIN
			IF @includestickythreads = 0
			BEGIN
				EXEC forumgetthreadlist_datecreated		@forumid, 
														@firstindex, 
														@lastindex, 
														@threadcount, 
														@forumpostcount,
														@canread, 
														@canwrite, 
														@siteid, 
														@threadcanread, 
														@threadcanwrite, 
														@AlertInstantly,
														@moderationstatus,
														@notablesgroup
			END 
			ELSE
			BEGIN
					EXEC forumgetthreadlist_datecreated_includingstickythreads
														@forumid, 
														@firstindex, 
														@lastindex, 
														@threadcount, 
														@forumpostcount,
														@canread, 
														@canwrite, 
														@siteid, 
														@threadcanread, 
														@threadcanwrite, 
														@AlertInstantly,
														@moderationstatus,
														@notablesgroup
			END
		END
		ELSE
		BEGIN
			IF @includestickythreads = 0
			BEGIN
				EXEC forumgetthreadlist_lastposted		
													@forumid, 
													@firstindex, 
													@lastindex, 
													@threadcount, 
													@forumpostcount,
													@canread, 
													@canwrite, 
													@siteid, 
													@threadcanread, 
													@threadcanwrite, 
													@AlertInstantly,
													@moderationstatus,
													@notablesgroup
			END 
			ELSE
			BEGIN
					EXEC forumgetthreadlist_lastposted_includingstickythreads	
													@forumid, 
													@firstindex, 
													@lastindex, 
													@threadcount, 
													@forumpostcount,
													@canread, 
													@canwrite, 
													@siteid, 
													@threadcanread, 
													@threadcanwrite, 
													@AlertInstantly,
													@moderationstatus,
													@notablesgroup
			END
		END
END



ELSE
BEGIN
	SELECT 'ThreadID' = NULL, 
			'ThreadCount' = 0,
			'SiteID' = @siteid,
			'CanRead' = @canread,
			'CanWrite' = @canwrite,
			'ThreadCanRead' = @threadcanread,
			'ThreadCanWrite' = @threadcanwrite,
			'ModerationStatus' = @moderationstatus,
			'AlertInstantly' = @AlertInstantly
END

	return (0)


