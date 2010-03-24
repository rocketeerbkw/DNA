CREATE PROCEDURE getalertgroupsettings @userid int
AS
SELECT DISTINCT
	elm.NotifyType,
	elm.NotifyType,
	'ListType' = CASE WHEN el.UserID IS NOT NULL THEN 1
			WHEN iel.UserID IS NOT NULL THEN 2
			ELSE 0 END
	FROM EmailAlertListMembers elm WITH(NOLOCK)
	LEFT JOIN EmailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = elm.EMailAlertListID
	LEFT JOIN InstantEmailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = elm.EmailAlertListID
	WHERE el.UserID = @userid OR iel.UserID = @userid AND elm.AlertGroupID > 0