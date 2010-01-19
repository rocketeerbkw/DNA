CREATE TRIGGER fixgelastupdated ON dbo.Topics 
FOR INSERT, UPDATE 
AS
UPDATE GuideEntries SET LastUpdated = getdate() WHERE h2g2ID IN (SELECT h2g2ID FROM inserted)
