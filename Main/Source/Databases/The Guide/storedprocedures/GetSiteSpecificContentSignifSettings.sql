CREATE PROCEDURE getsitespecificcontentsignifsettings @siteid INT 
AS
	/*
		Returns Content Signif Settings for a site. 
	*/
	SELECT 'i' AS 'SettingType', act.ActionID, act.ActionDesc, incr.ItemID, item.ItemDesc, incr.Value
	  FROM dbo.ContentSignifIncrement incr
		   INNER JOIN dbo.ContentSignifItem item ON item.ItemID = incr.ItemID
		   INNER JOIN dbo.ContentSignifAction act ON act.ActionID = incr.ActionID
	 WHERE incr.ItemID = item.ItemID
	   AND incr.SiteID = @siteid
	UNION ALL
	SELECT 'd', act.ActionID, act.ActionDesc, decr.ItemID, item.ItemDesc, decr.Value
	  FROM dbo.ContentSignifDecrement decr
		   INNER JOIN dbo.ContentSignifItem item ON item.ItemID = decr.ItemID
		   INNER JOIN dbo.ContentSignifAction act ON act.ActionID = decr.ActionID
	 WHERE decr.SiteID = @siteid
	 ORDER BY act.ActionID

RETURN @@ERROR