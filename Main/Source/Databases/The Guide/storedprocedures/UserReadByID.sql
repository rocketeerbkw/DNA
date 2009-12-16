IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'userreadbyid')
	BEGIN
		DROP  Procedure  dbo.userreadbyid
	END

GO

CREATE PROCEDURE userreadbyid @id int
	AS
	SELECT     DNAUserID as ID, UserName as Name, IdentityUserId, SSOUserID
	FROM         VAPIUsers
	WHERE     (DNAUserid = @id )
	
		
GO

GRANT EXECUTE ON [dbo].[userreadbyid] TO [ripleyrole]