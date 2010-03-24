CREATE PROCEDURE getitemdetailsfrominstantemailalertmemberid @memberid int
AS
SELECT * FROM EMailAlertListMembers WHERE MemberID = @memberid