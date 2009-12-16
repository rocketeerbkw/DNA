CREATE PROCEDURE getitemdetailsfrommemberid @memberid int
AS
SELECT * FROM ItemListMembers WHERE MemberID = @memberid