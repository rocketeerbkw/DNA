/*
 * Gets Moderation Status for Site, Forum, Thread and User. Priority is given to User, Thread, Forum then Site.
 * eg Users Moderation stetings will override thread moderation status and so on. 
 */
 
CREATE PROCEDURE getmodstatusforforum
	@userid int,  @threadid int = NULL, @forumid int, @siteid int,
	@premoderation int OUTPUT, @unmoderated int OUTPUT
AS
declare @forummodstatus int
declare @threadmodstatus int
declare @sitemodstatus int

-- get moderation details from the Site, Forum and Thread ( if specified)  tables
SELECT @premoderation = ISNULL(s.PreModeration,0), 
		@unmoderated = ISNULL(s.Unmoderated,1),
		@sitemodstatus = case when ISNULL(s.Unmoderated,1) =1 and ISNULL(s.PreModeration,0)=0 then 1--unmoderated
							when ISNULL(s.Unmoderated,1) =0 and ISNULL(s.PreModeration,0)=0 then 2-- post mod
							else 3 end,
	   @forummodstatus  = ISNULL(f.ModerationStatus,0),
	   @threadmodstatus = ISNULL(th.ModerationStatus,0)
		FROM dbo.Forums f
		INNER JOIN dbo.Sites s WITH(NOLOCK) ON f.SiteID = s.SiteID
		LEFT JOIN dbo.Threads th WITH(NOLOCK) ON th.ThreadId = @threadid
		WHERE f.ForumID = @forumid

-- If Forum moderation is >= 1, it overrides Site moderation
-- @forummodstatus = NULL = undefined (i.e. inherit moderation state)
--	                 0    = (same as NULL)
--					 1    = unmoderated
--	                 2    = postmoderated
--	                 3    = premoderated



if (@forummodstatus = 1)
BEGIN
	SELECT @premoderation = 0, @unmoderated   = 1
END

if (@forummodstatus = 2)
BEGIN
	SELECT @premoderation = 0, @unmoderated   = 0
END

if (@forummodstatus = 3)
BEGIN
	SELECT @premoderation = 1, @unmoderated   = 0
END

--Thread Moderation status overrides forum moderation status if >= 1 
if (@threadmodstatus = 1)
BEGIN
	SELECT @premoderation = 0, @unmoderated   = 1
END

if (@threadmodstatus = 2)
BEGIN
	SELECT @premoderation = 0, @unmoderated   = 0
END

if (@threadmodstatus = 3)
BEGIN
	SELECT @premoderation = 1, @unmoderated   = 0
END

DECLARE @prefstatus tinyint
EXEC getmemberprefstatus @UserID, @SiteID, @PrefStatus OUTPUT
--print @prefstatus

if (@prefstatus = 1)
begin
	select @premoderation = 1, @unmoderated = 0
end
-- only use user preference if the thread, site or forum not premod already
if (@prefstatus = 2 AND @threadmodstatus <> 3 AND @forummodstatus <> 3 AND @sitemodstatus <> 3)
begin
	select @premoderation = 0, @unmoderated = 0
end

if (@prefstatus = 0 or @prefstatus = 6)-- trusted user or standard user
begin
	-- make sure that if premoderated, the unmoderated flag is not in an illegal state
	if (@premoderation = 1)
	BEGIN
		SELECT @unmoderated = 0
	END

end


