IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usergroupreadbyid')
	BEGIN
		DROP  Procedure  dbo.usergroupreadbyid
	END

GO

CREATE PROCEDURE usergroupreadbyid @userid int =0, @siteid int =0
	AS
	
	SELECT     name, userid, GroupID, siteid
	FROM         VUserGroups
	WHERE     
	(@userid = 0 or userid = @userid )
	and
	(@siteid = 0 or siteid = @siteid )
	
		
GO

GRANT EXECUTE ON [dbo].[usergroupreadbyid] TO [ripleyrole]