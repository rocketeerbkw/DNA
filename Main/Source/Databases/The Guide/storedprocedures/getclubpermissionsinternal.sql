create procedure getclubpermissionsinternal @userid int, @clubid int,
												@canautomember int OUTPUT,
												@canautoowner int OUTPUT,
												@canbecomemember int OUTPUT,
												@canbecomeowner int OUTPUT,
												@canapprovemembers int OUTPUT,
												@canapproveowners int OUTPUT,
												@candemoteowneres int OUTPUT, 
												@candemotemembers int OUTPUT,
												@canviewactions int OUTPUT,
												@canview int OUTPUT,
												@canedit int OUTPUT,
												@isteammember int OUTPUT,
												@isowner int OUTPUT
as

-- Using the permissions in the Forums table as well
-- 

select TOP 1
		@canautomember = CASE WHEN gm.UserID IS NULL THEN c.CanAutoJoinMember ELSE cp.CanAutoJoinMember END,
		@canautoowner = CASE WHEN gm.UserID IS NULL THEN c.CanAutoJoinOwner ELSE cp.CanAutoJoinOwner END,
		@canbecomemember = CASE WHEN gm.UserID IS NULL THEN c.CanBecomeMember ELSE cp.CanBecomeMember END,
		@canbecomeowner = CASE WHEN gm.UserID IS NULL THEN c.CanBecomeOwner ELSE cp.CanBecomeOwner END,
		@canapprovemembers = CASE WHEN gm.UserID IS NULL THEN c.CanApproveMembers ELSE cp.CanApproveMembers END,
		@canapproveowners = CASE WHEN gm.UserID IS NULL THEN c.CanApproveOwners ELSE cp.CanApproveOwners END,
		@candemoteowneres = CASE WHEN gm.UserID IS NULL THEN c.CanDemoteOwners ELSE cp.CanDemoteOwners END,
		@candemotemembers = CASE WHEN gm.UserID IS NULL THEN c.CanDemoteMembers ELSE cp.CanDemoteMembers END,
		@canviewactions = CASE WHEN gm.UserID IS NULL THEN c.CanViewActions ELSE cp.CanViewActions END,
		@canview = CASE WHEN gm.UserID IS NULL THEN c.CanView ELSE cp.CanView END,
		@canedit = CASE WHEN gm.UserID IS NULL THEN c.CanEdit ELSE cp.CanEdit END,
		@isteammember = CASE WHEN gm.UserID IS NULL THEN 0 ELSE 1 END,
		@isowner = CASE WHEN gm.TeamID = c.OwnerTeam THEN 1 ELSE 0 END
		from Clubs c
LEFT JOIN ClubPermissions cp ON cp.ClubID = c.ClubID
LEFT JOIN (SELECT u.UserID, g.TeamID FROM Users u INNER JOIN TeamMembers g ON u.UserID = g.UserID) as gm ON gm.TeamID = cp.TeamID AND gm.UserID = @userid
WHERE c.ClubID = @clubid
order by  gm.UserID DESC, cp.Priority DESC
