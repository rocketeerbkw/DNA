create procedure getactionlistforuser @userid int, @currentsiteid int = 0
as

declare @actioncount int
select @actioncount = COUNT(*) FROM ClubMemberActions a WHERE a.UserID = @userid

SELECT u.UserName as ActionUserName,
		u1.UserName as OwnerUserName,
		CASE WHEN ActionName IS NOT NULL THEN ActionName ELSE 'unknown' END as ActionName, 
		@actioncount as NumActions,
		c.Name as ClubName,
		a.*, c.*,
		U.FIRSTNAMES as ActionFirstNames, U.LASTNAME as ActionLastName, U.AREA as ActionArea, U.STATUS as ActionStatus, U.TAXONOMYNODE as ActionTaxonomyNode, J.FORUMID as ActionJournal, U.ACTIVE as ActionActive, P.SITESUFFIX as ActionSiteSuffix, P.TITLE as ActionTitle,
		U1.FIRSTNAMES as OwnerFirstNames, U1.LASTNAME as OwnerLastName, U1.AREA as OwnerArea, U1.STATUS as OwnerStatus, U1.TAXONOMYNODE as OwnerTaxonomyNode, J1.FORUMID as OwnerJournal, U1.ACTIVE as OwnerActive, P1.SITESUFFIX as OwnerSiteSuffix, P1.TITLE as OwnerTitle
	from ClubMemberActions a
	INNER JOIN Clubs c ON a.ClubID = c.ClubID
	INNER JOIN Users u ON a.UserID = u.UserID
	LEFT JOIN Preferences p ON p.UserID = u.UserID AND p.SiteID = @currentsiteid	
	LEFT JOIN ClubActionNames n ON a.ActionType = n.ActionType
	LEFT JOIN Users u1 ON a.OwnerID = u1.UserID
	LEFT JOIN Preferences p1 ON p1.UserID = u1.UserID AND p1.SiteID = @currentsiteid
	INNER JOIN Journals J on j.userid = u.userid and j.siteid = @currentsiteid
	LEFT JOIN Journals J1 on j1.userid = u1.userid and j1.siteid  = @currentsiteid
	WHERE a.UserID = @userid
	ORDER BY CASE WHEN ActionResult = 0 THEN 1 ELSE 0 END DESC, DateRequested DESC