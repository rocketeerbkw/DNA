IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'getuserfromidentityid')
	BEGIN
		DROP  Procedure  dbo.getuserfromidentityid
	END

GO

CREATE PROCEDURE getuserfromidentityid @indentityuserid varchar(40)
	AS
	SELECT     DNAUserID as ID, UserName as Name, IdentityUserId, SSOUserID, LoginName as IdentityUserName
	FROM         VAPIUsers
	WHERE     (IdentityUserID = @indentityuserid )
	
		
GO

GRANT EXECUTE ON [dbo].[getuserfromidentityid] TO [ripleyrole]