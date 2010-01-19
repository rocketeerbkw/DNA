IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'getuserfromssouserid')
	BEGIN
		DROP  Procedure  dbo.getuserfromssouserid
	END

GO

CREATE PROCEDURE getuserfromssouserid @ssouserid int
	AS
	SELECT     DNAUserID as ID, UserName as Name, IdentityUserId, SSOUserID
	FROM         VAPIUsers
	WHERE     (SSOUserID = @ssouserid)
	
		
GO

GRANT EXECUTE ON [dbo].[getuserfromssouserid] TO [ripleyrole]