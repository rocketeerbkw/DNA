CREATE PROCEDURE generateemailevents @topeventid INT
AS
	INSERT INTO dbo.EmailEventQueue
	SELECT  EventInfo.ListID,
			EventInfo.SiteID,
			EventInfo.ItemID,
			EventInfo.ItemType,
			EventInfo.EventType,
			EventInfo.EventDate,
			EventInfo.ItemID2,
			EventInfo.ItemType2,
			EventInfo.NotifyType,
			EventInfo.EventUserID,
			EventInfo.IsOwner
	FROM
	(
		SELECT	'ListID' = el.EmailAlertListID,
				el.SiteID,
				eq.ItemID,
				eq.ItemType,
				eq.EventType,
				eq.EventDate,
				eq.ItemID2,
				eq.ItemType2,
				elm.NotifyType,
				eq.EventUserID,
				'IsOwner' = ISNULL(ag.IsOwner,0)
		FROM dbo.EventQueue eq
		INNER JOIN dbo.EMailAlertListMembers elm ON elm.ItemType = eq.ItemType AND elm.ItemID = eq.ItemID
		INNER JOIN dbo.EMailAlertList el ON el.EmailAlertListID = elm.EmailAlertListID
		LEFT JOIN dbo.AlertGroups ag ON ag.GroupID = elm.AlertGroupID
		WHERE elm.NotifyType > 0 AND elm.NotifyType < 3  AND el.UserID <> eq.EventUserID AND eq.EventUserID > 0 AND eq.EventID <= @TopEventID
		UNION ALL
		SELECT	'ListID' = iel.InstantEMailAlertListID,
				iel.SiteID,
				eq.ItemID,
				eq.ItemType,
				eq.EventType,
				eq.EventDate,
				eq.ItemID2,
				eq.ItemType2,
				ielm.NotifyType,
				eq.EventUserID,
				'IsOwner' = ISNULL(ag.IsOwner,0)
		FROM dbo.EventQueue eq
		INNER JOIN dbo.EMailAlertListMembers ielm ON ielm.ItemType = eq.ItemType AND ielm.ItemID = eq.ItemID
		INNER JOIN dbo.InstantEMailAlertList iel ON iel.InstantEMailAlertListID = ielm.EMailAlertListID
		LEFT JOIN dbo.AlertGroups ag ON ag.GroupID = ielm.AlertGroupID
		WHERE ielm.NotifyType > 0 AND ielm.NotifyType < 3 AND iel.UserID <> eq.EventUserID AND eq.EventUserID > 0 AND eq.EventID <= @TopEventID
	) AS EventInfo

RETURN 0;