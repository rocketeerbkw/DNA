CREATE PROCEDURE gettopfivegroupoftype @isiteid int, @groupname varchar(255)
As
IF @groupname = 'MostRecentClubUpdates'
BEGIN
	SELECT @@ROWCOUNT 'Count', c.ClubID, c.Name FROM Clubs c INNER JOIN TopFives f ON f.GroupName = @groupname AND f.SiteID = @isiteid AND f.ClubID = c.ClubID
END
ELSE IF @groupname = 'MostRecentUser'
BEGIN
	SELECT @@ROWCOUNT 'Count', g.h2g2ID, g.Subject FROM GuideEntries g INNER JOIN TopFives f ON f.GroupName = @groupname AND f.SiteID = @isiteid AND g.h2g2ID = f.h2g2ID
END
