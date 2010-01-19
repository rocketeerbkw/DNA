CREATE PROCEDURE automodaudit_addrecord @userid INT, @siteid SMALLINT, @reasonid TINYINT, 
										@trustpoints SMALLINT, @modstatus TINYINT
AS
	INSERT INTO dbo.AutoModAudit (UserID,  SiteID,  ReasonID,  TrustPoints,  ModStatus)
		VALUES					 (@userid, @siteid, @reasonid, @trustpoints, @modstatus)
