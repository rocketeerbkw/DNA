CREATE PROCEDURE getuserfromidentityusername @indentityusername varchar(255)
	AS
	SELECT     DNAUserID as ID, UserName as Name, IdentityUserId, SSOUserID, LoginName as IdentityUserName
	FROM         VAPIUsers
	WHERE     (LoginName = @indentityusername )	