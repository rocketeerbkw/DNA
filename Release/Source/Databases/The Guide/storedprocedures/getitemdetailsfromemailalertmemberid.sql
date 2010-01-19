CREATE PROCEDURE getitemdetailsfromemailalertmemberid @memberid int
AS
SELECT * FROM EMailAlertListMembers WHERE MemberID = @memberid