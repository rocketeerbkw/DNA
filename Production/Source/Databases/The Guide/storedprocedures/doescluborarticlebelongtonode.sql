CREATE PROCEDURE doescluborarticlebelongtonode @iparentid int, @iclubid int, @iarticleid int
As

DECLARE @EntryID int
SET @EntryID=@iarticleid/10

DECLARE @Subject varchar(255)
SELECT @Subject = Subject FROM GuideEntries g INNER JOIN Hierarchy h ON h.h2g2id = g.h2g2id AND h.NodeID = @iparentid

-- Check to see if the club or article is a child of the given parent
SELECT 'Subject' = @Subject, COUNT(*) 'Alreadyexists' FROM GuideEntries WHERE h2g2ID IN
(
	SELECT h2g2ID FROM Hierarchy WHERE Nodeid = @iparentid AND NodeID IN
	(
		SELECT NodeID FROM HierarchyClubMembers WHERE ClubID = @iclubid
		UNION
		(
			SELECT NodeID FROM HierarchyArticleMembers WHERE EntryID = @EntryID
		)
	)
)
