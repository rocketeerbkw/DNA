CREATE PROCEDURE getuserfromidentityid @indentityuserid varchar(40)
	AS
	SELECT     DNAUserID as ID, UserName as Name, IdentityUserId, SSOUserID, LoginName as IdentityUserName
	FROM         VAPIUsers
	WHERE     (IdentityUserID = @indentityuserid )
	