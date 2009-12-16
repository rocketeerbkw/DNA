CREATE PROCEDURE getallclubsthatuserbelongsto @iuserid int, @iinlastnoofdays int = 1, @isiteid int = 0
AS
BEGIN

-- This gives all the clubs the user is a member of, with the added bonus
-- on adding an 'Owner' field that indicates if the user is also the owner or not

IF (@isiteid = 0)
BEGIN
	SELECT	'Owner' = CASE WHEN t1.TeamID IS NULL THEN 0 ELSE 1 END, 
		'MembershipCount' = (SELECT COUNT(*) FROM dbo.TeamMembers WITH(NOLOCK) WHERE TeamID = c.memberteam),
		'NewMembersCount' = (SELECT COUNT(*) FROM dbo.TeamMembers WITH(NOLOCK) WHERE TeamID = c.memberteam AND (DateJoined > getdate() - @iinlastnoofdays)),
		'Role' = t.Role,
		c.*, 
		g.DateCreated,
		g.Hidden,
		g.ExtraInfo,
		g.Status 'ArticleStatus'
		FROM Clubs c WITH(NOLOCK)
		INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.h2g2id = c.h2g2id
		INNER JOIN dbo.TeamMembers t  WITH(NOLOCK) ON c.MemberTeam =  t.TeamID AND  t.UserID = @iuserid
		LEFT  JOIN dbo.TeamMembers t1 WITH(NOLOCK) ON c.OwnerTeam  = t1.TeamID AND t1.UserID = @iuserid
		WHERE g.hidden IS NULL
END
ELSE
BEGIN
	SELECT	'Owner' = CASE WHEN t1.TeamID IS NULL THEN 0 ELSE 1 END, 
		'MembershipCount' = (SELECT COUNT(*) FROM dbo.TeamMembers WITH(NOLOCK) WHERE TeamID = c.memberteam),
		'NewMembersCount' = (SELECT COUNT(*) FROM dbo.TeamMembers WITH(NOLOCK) WHERE TeamID = c.memberteam AND (DateJoined > getdate() - @iinlastnoofdays)),
		'Role' = t.Role,
		c.*, 
		g.DateCreated,
		g.Hidden,
		g.ExtraInfo,
		g.Status 'ArticleStatus'
		FROM dbo.Clubs c WITH(NOLOCK)
		INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.h2g2id = c.h2g2id
		INNER JOIN dbo.TeamMembers t  WITH(NOLOCK) ON c.MemberTeam =  t.TeamID AND  t.UserID = @iuserid
		LEFT  JOIN dbo.TeamMembers t1 WITH(NOLOCK) ON c.OwnerTeam  = t1.TeamID AND t1.UserID = @iuserid
		WHERE c.SiteID = @isiteid AND g.hidden IS NULL
END
END