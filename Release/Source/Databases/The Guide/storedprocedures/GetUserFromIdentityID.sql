IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'getuserfromidentityid')
	BEGIN
		DROP  Procedure  dbo.getuserfromidentityid
	END

GO

CREATE PROCEDURE getuserfromidentityid @indentityuserid int
	AS
	SELECT     DNAUserID as ID, UserName as Name, IdentityUserId, SSOUserID
	FROM         VAPIUsers
	WHERE     (IdentityUserID = @indentityuserid )
	
		
GO

GRANT EXECUTE ON [dbo].[getuserfromidentityid] TO [ripleyrole]