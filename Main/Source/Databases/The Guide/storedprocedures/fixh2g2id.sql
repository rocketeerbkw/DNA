CREATE PROCEDURE fixh2g2id @guideentry int
AS
declare @temp int, @checksum int
SELECT @temp = @guideentry, @checksum = 0
WHILE @temp > 0
BEGIN
SELECT @checksum = @checksum + (@temp % 10)
SELECT @temp = @temp  / 10
END
SELECT @checksum = @checksum % 10
SELECT @checksum = 10 - @checksum
SELECT @checksum = @checksum + (10 * @guideentry)
UPDATE GuideEntries SET h2g2id = @checksum WHERE EntryID = @guideentry
