create procedure getclubpermissions @userid int, @clubid int
as

-- Using the permissions in the Forums table as well
-- 


select 
		CASE WHEN gm.UserID IS NULL THEN c.CanAutoJoinMember ELSE cp.CanAutoJoinMember END as fCanAutoJoinMember,
		CASE WHEN gm.UserID IS NULL THEN c.CanAutoJoinOwner ELSE cp.CanAutoJoinOwner END as fCanAutoJoinOwner,
		CASE WHEN gm.UserID IS NULL THEN c.CanBecomeMember ELSE cp.CanBecomeMember END as fCanBecomeMember,
		CASE WHEN gm.UserID IS NULL THEN c.CanBecomeOwner ELSE cp.CanBecomeOwner END as fCanBecomeOwner,
		CASE WHEN gm.UserID IS NULL THEN c.CanApproveMembers ELSE cp.CanApproveMembers END as fCanApproveMembers,
		CASE WHEN gm.UserID IS NULL THEN c.CanApproveOwners ELSE cp.CanApproveOwners END as fCanApproveOwners,
		CASE WHEN gm.UserID IS NULL THEN c.CanDemoteOwners ELSE cp.CanDemoteOwners END as fCanDemoteOwners,
		CASE WHEN gm.UserID IS NULL THEN c.CanDemoteMembers ELSE cp.CanDemoteMembers END as fCanDemoteMembers,
		CASE WHEN gm.UserID IS NULL THEN c.CanViewActions ELSE cp.CanViewActions END as fCanViewActions,
		CASE WHEN gm.UserID IS NULL THEN c.CanView ELSE cp.CanView END as fCanView,
		CASE WHEN gm.UserID IS NULL THEN c.CanEdit ELSE cp.CanEdit END as fCanEdit,c.*
		from Clubs c
LEFT JOIN ClubPermissions cp ON cp.ClubID = c.ClubID
LEFT JOIN (SELECT u.UserID, g.TeamID FROM Users u INNER JOIN TeamMembers g ON u.UserID = g.UserID) as gm ON gm.TeamID = cp.TeamID AND gm.UserID = @userid
WHERE c.ClubID = @clubid
order by gm.UserID DESC, cp.Priority DESC
