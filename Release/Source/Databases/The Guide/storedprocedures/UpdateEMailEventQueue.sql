CREATE PROCEDURE updateemaileventqueue
AS	
BEGIN TRANSACTION

EXEC openemailaddresskey

-- Update the EMailEventQueue with items from the eventqueue that matches any users alerts
DECLARE @Error int
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
		WHERE elm.NotifyType > 0 AND elm.NotifyType < 3  AND el.UserID <> eq.EventUserID
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
		WHERE ielm.NotifyType > 0 AND ielm.NotifyType < 3 AND iel.UserID <> eq.EventUserID
	) AS EventInfo
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

-- Now clear the event queue as we've delt with them all now
DELETE FROM dbo.EventQueue
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

COMMIT TRANSACTION

-- Get the values for all the different types of items we can have events for
DECLARE @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int, @PostType int, @UserType int, @VoteType int, @LinkType int, @TeamType int, @URLType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT
EXEC SetItemTypeValInternal 'IT_POST', @PostType OUTPUT
EXEC SetItemTypeValInternal 'IT_USER', @UserType OUTPUT
EXEC SetItemTypeValInternal 'IT_VOTE', @VoteType OUTPUT
EXEC SetItemTypeValInternal 'IT_LINK', @LinkType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB_MEMBERS', @TeamType OUTPUT
EXEC SetItemTypeValInternal 'IT_URL', @URLType OUTPUT

-- Now get all the values for the different events that can happen
DECLARE @ArticleEdit int, @ArticleTagged int, @TaggedArticleEdited int, @ForumEdit int, @NewTeamMember int, @PostRepliedTo int, @NewThread int, @ThreadTagged int
DECLARE @UserTagged int, @ClubTagged int, @LinkAdded int, @VoteAdded int, @VoteRemoved int, @OwnerTeamChange int, @MemberTeamChange int, @MemberApplication int, @ClubEdit int, @NodeHidden int
EXEC SetEventTypeValInternal 'ET_ARTICLEEDITED', @ArticleEdit OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYARTICLETAGGED', @ArticleTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYARTICLEEDITED', @TaggedArticleEdited OUTPUT
EXEC SetEventTypeValInternal 'ET_FORUMEDITED', @ForumEdit OUTPUT
EXEC SetEventTypeValInternal 'ET_NEWTEAMMEMBER', @NewTeamMember OUTPUT
EXEC SetEventTypeValInternal 'ET_POSTREPLIEDTO', @PostRepliedTo OUTPUT
EXEC SetEventTypeValInternal 'ET_POSTNEWTHREAD', @NewThread OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYTHREADTAGGED', @ThreadTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYUSERTAGGED', @UserTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYCLUBTAGGED', @ClubTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_NEWLINKADDED', @LinkAdded OUTPUT
EXEC SetEventTypeValInternal 'ET_VOTEADDED', @VoteAdded OUTPUT
EXEC SetEventTypeValInternal 'ET_VOTEREMOVED', @VoteRemoved OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBOWNERTEAMCHANGE', @OwnerTeamChange OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBMEMBERTEAMCHANGE', @MemberTeamChange OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBMEMBERAPPLICATIONCHANGE', @MemberApplication OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBEDITED', @ClubEdit OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYHIDDEN', @NodeHidden OUTPUT

-- Do the User Tagged bit 'ET_CATEGORYUSERTAGGED'
SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
		eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
		eeq.ItemID, eeq.ItemType,
		'ItemName' = h1.DisplayName,
		eeq.ItemID2, eeq.ItemType2,
		'ItemName2' = NULL,
		'EventUserID' = u2.UserID,
		'EventUserName' = u2.UserName,
		'EventUserFirstNames' = u2.FirstNames,
		'EventUserLastName' = u2.LastName,
		'EventUserSiteSuffix' = p2.SiteSuffix,
		'EventUserTitle' = p2.Title,
		'VoteResponse' = NULL,
		'ItemType3' = NULL,
		'ItemName3' = NULL,
		'ItemID3' = NULL,
		eeq.ListID
FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
INNER JOIN dbo.Hierarchy h1 WITH(NOLOCK) ON h1.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
WHERE eeq.ItemID2 = 0 AND eeq.EventType = @UserTagged
UNION ALL
(
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = h1.DisplayName,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = NULL,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
	INNER JOIN dbo.Hierarchy h1 WITH(NOLOCK) ON h1.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
	WHERE eeq.ItemID2 = 0 AND eeq.EventType = @UserTagged
)
UNION ALL
(
	-- Do the Post To Thread Bit 'ET_POSTNEWTHREAD'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = f.Title,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = t.FirstSubject,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN 'ClubForum'
				WHEN c2.ClubID IS NOT NULL THEN 'ClubJournal'
				WHEN g.h2g2ID IS NOT NULL THEN 'GuideEntry'
				ELSE NULL END,
			'ItemName3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN c1.Name
				WHEN c2.ClubID IS NOT NULL THEN c2.Name
				WHEN g.h2g2ID IS NOT NULL THEN g.Subject
				ELSE NULL END,
			'ItemID3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN c1.ClubID
				WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
				WHEN g.h2g2ID IS NOT NULL THEN g.h2g2id
				ELSE NULL END,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID2 AND eeq.ItemType2 = @ThreadType AND t.VisibleTo IS NULL
	INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = eeq.ItemID AND eeq.ItemType = @ForumType
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	LEFT JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.ForumID = f.ForumID
	LEFT JOIN dbo.Clubs c1 WITH(NOLOCK) ON c1.ClubForum = f.ForumID
	LEFT JOIN dbo.Clubs c2 WITH(NOLOCK) ON c2.Journal = f.ForumID
	WHERE eeq.ItemID2 = 0 AND eeq.EventType = @NewThread
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = f.Title,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = t.FirstSubject,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN 'ClubForum'
					WHEN c2.ClubID IS NOT NULL THEN 'ClubJournal'
					WHEN g.h2g2ID IS NOT NULL THEN 'GuideEntry'
					ELSE NULL END,
				'ItemName3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN c1.Name
					WHEN c2.ClubID IS NOT NULL THEN c2.Name
					WHEN g.h2g2ID IS NOT NULL THEN g.Subject
					ELSE NULL END,
				'ItemID3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN c1.ClubID
					WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
					WHEN g.h2g2ID IS NOT NULL THEN g.h2g2id
					ELSE NULL END,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID2 AND eeq.ItemType2 = @ThreadType AND t.VisibleTo IS NULL
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = eeq.ItemID AND eeq.ItemType = @ForumType
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		LEFT JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.ForumID = f.ForumID
		LEFT JOIN dbo.Clubs c1 WITH(NOLOCK) ON c1.ClubForum = f.ForumID
		LEFT JOIN dbo.Clubs c2 WITH(NOLOCK) ON c2.Journal = f.ForumID
		WHERE eeq.ItemID2 = 0 AND eeq.EventType = @NewThread
	)
)
UNION ALL
(
	-- Do the Forum Bit 'ET_FORUMEDITED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = f.Title,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = t.FirstSubject,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN 'ClubForum'
				WHEN c2.ClubID IS NOT NULL THEN 'ClubJournal'
				WHEN g.h2g2ID IS NOT NULL THEN 'GuideEntry'
				ELSE NULL END,
			'ItemName3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN c1.Name
				WHEN c2.ClubID IS NOT NULL THEN c2.Name
				WHEN g.h2g2ID IS NOT NULL THEN g.Subject
				ELSE NULL END,
			'ItemID3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN c1.ClubID
				WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
				WHEN g.h2g2ID IS NOT NULL THEN g.h2g2id
				ELSE NULL END,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = eeq.ItemID AND eeq.ItemType = @ForumType
	INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID2 AND eeq.ItemType2 = @ThreadType AND t.VisibleTo IS NULL
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	LEFT JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.ForumID = f.ForumID
	LEFT JOIN dbo.Clubs c1 WITH(NOLOCK) ON c1.ClubForum = f.ForumID
	LEFT JOIN dbo.Clubs c2 WITH(NOLOCK) ON c2.Journal = f.ForumID
	WHERE eeq.EventType = @ForumEdit
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = f.Title,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = t.FirstSubject,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN 'ClubForum'
					WHEN c2.ClubID IS NOT NULL THEN 'ClubJournal'
					WHEN g.h2g2ID IS NOT NULL THEN 'GuideEntry'
					ELSE NULL END,
				'ItemName3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN c1.Name
					WHEN c2.ClubID IS NOT NULL THEN c2.Name
					WHEN g.h2g2ID IS NOT NULL THEN g.Subject
					ELSE NULL END,
				'ItemID3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN c1.ClubID
					WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
					WHEN g.h2g2ID IS NOT NULL THEN g.h2g2id
					ELSE NULL END,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = eeq.ItemID AND eeq.ItemType = @ForumType
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID2 AND eeq.ItemType2 = @ThreadType AND t.VisibleTo IS NULL
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		LEFT JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.ForumID = f.ForumID
		LEFT JOIN dbo.Clubs c1 WITH(NOLOCK) ON c1.ClubForum = f.ForumID
		LEFT JOIN dbo.Clubs c2 WITH(NOLOCK) ON c2.Journal = f.ForumID
		WHERE eeq.EventType = @ForumEdit
	)
)
UNION ALL
(
	-- Do the Post bit 'ET_POSTREPLIEDTO'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = t.FirstSubject,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = t2.Subject,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN 'ClubForum'
				WHEN c2.ClubID IS NOT NULL THEN 'ClubJournal'
				WHEN g.h2g2ID IS NOT NULL THEN 'GuideEntry'
				ELSE NULL END,
			'ItemName3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN c1.Name
				WHEN c2.ClubID IS NOT NULL THEN c2.Name
				WHEN g.h2g2ID IS NOT NULL THEN g.Subject
				ELSE NULL END,
			'ItemID3' = CASE
				WHEN c1.ClubID IS NOT NULL THEN c1.ClubID
				WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
				WHEN g.h2g2ID IS NOT NULL THEN g.h2g2id
				ELSE NULL END,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID AND eeq.ItemType = @ThreadType AND t.VisibleTo IS NULL
	INNER JOIN dbo.ThreadEntries t2 WITH(NOLOCK) ON t2.EntryID = eeq.ItemID2 AND eeq.ItemType2 = @PostType AND t2.Hidden IS NULL
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	LEFT JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.ForumID = t.ForumID
	LEFT JOIN dbo.Clubs c1 WITH(NOLOCK) ON c1.ClubForum = t.ForumID
	LEFT JOIN dbo.Clubs c2 WITH(NOLOCK) ON c2.Journal = t.ForumID
	WHERE eeq.EventType = @PostRepliedTo
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = t.FirstSubject,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = t2.Subject,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN 'ClubForum'
					WHEN c2.ClubID IS NOT NULL THEN 'ClubJournal'
					WHEN g.h2g2ID IS NOT NULL THEN 'GuideEntry'
					ELSE NULL END,
				'ItemName3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN c1.Name
					WHEN c2.ClubID IS NOT NULL THEN c2.Name
					WHEN g.h2g2ID IS NOT NULL THEN g.Subject
					ELSE NULL END,
				'ItemID3' = CASE
					WHEN c1.ClubID IS NOT NULL THEN c1.ClubID
					WHEN c2.ClubID IS NOT NULL THEN c2.ClubID
					WHEN g.h2g2ID IS NOT NULL THEN g.h2g2id
					ELSE NULL END,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID AND eeq.ItemType = @ThreadType AND t.VisibleTo IS NULL
		INNER JOIN dbo.ThreadEntries t2 WITH(NOLOCK) ON t2.EntryID = eeq.ItemID2 AND eeq.ItemType2 = @PostType AND t2.Hidden IS NULL
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		LEFT JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.ForumID = t.ForumID
		LEFT JOIN dbo.Clubs c1 WITH(NOLOCK) ON c1.ClubForum = t.ForumID
		LEFT JOIN dbo.Clubs c2 WITH(NOLOCK) ON c2.Journal = t.ForumID
		WHERE eeq.EventType = @PostRepliedTo
	)
)
UNION ALL
(
	-- Do the Tagged Thread bit 'ET_CATEGORYTHREADTAGGED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = h2.DisplayName,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = t.FirstSubject,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
	INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID2 AND eeq.ItemType2 = @ThreadType AND t.VisibleTo IS NULL
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @ThreadTagged
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = h2.DisplayName,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = t.FirstSubject,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID	
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = eeq.ItemID2 AND eeq.ItemType2 = @ThreadType AND t.VisibleTo IS NULL
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType = @ThreadTagged
	)
)
UNION ALL
(
	 -- Do the Edit Club Bit 'ET_CLUBEDITED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = c.Name,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = NULL,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.ItemType2 = 0 AND ItemID2 = 0 AND eeq.EventType = @ClubEdit
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = c.Name,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = NULL,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.ItemType2 = 0 AND ItemID2 = 0 AND eeq.EventType = @ClubEdit
	)
)
UNION ALL
(
	 -- Do the Tagged Club Bit 'ET_CATEGORYCLUBTAGGED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = h2.DisplayName,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = c.Name,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
	INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID2 AND eeq.ItemType2 = @ClubType
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @ClubTagged
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = h2.DisplayName,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = c.Name,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID2 AND eeq.ItemType2 = @ClubType
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType = @ClubTagged
	)
)
UNION ALL
(
	-- Do the Article tagged 'ET_CATEGORYARTICLETAGGED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = h2.DisplayName,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = g1.Subject,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
	INNER JOIN dbo.GuideEntries g1 WITH(NOLOCK) ON g1.h2g2ID = eeq.ItemID2 AND eeq.ItemType2 = @ArticleType AND g1.Hidden IS NULL
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @ArticleTagged
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = h2.DisplayName,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = g1.Subject,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID AND eeq.ItemType = @NodeType
		INNER JOIN dbo.GuideEntries g1 WITH(NOLOCK) ON g1.h2g2ID = eeq.ItemID2 AND eeq.ItemType2 = @ArticleType AND g1.Hidden IS NULL
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType = @ArticleTagged
	)
)UNION ALL
(
	-- Do the Article Edited bit 'ET_ARTICLEEDITED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = g1.Subject,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = NULL,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.GuideEntries g1 WITH(NOLOCK) ON g1.h2g2ID = eeq.ItemID AND eeq.ItemType = @ArticleType AND g1.Hidden IS NULL
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.ItemType2 = 0 AND eeq.ItemID2 = 0 AND eeq.EventType = @ArticleEdit
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = g1.Subject,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = NULL,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.GuideEntries g1 WITH(NOLOCK) ON g1.h2g2ID = eeq.ItemID AND eeq.ItemType = @ArticleType AND g1.Hidden IS NULL
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.ItemType2 = 0 AND eeq.ItemID2 = 0 AND eeq.EventType = @ArticleEdit
	)
)
UNION ALL
(
	-- Do the New team member for clubs 'ET_NEWTEAMMEMBER', 'ET_CLUBOWNERTEAMCHANGE', 'ET_CLUBMEMBERTEAMCHANGE' and 'ET_CLUBMEMBERAPPLICATIONCHANGE'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = c.Name,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = u2.UserName,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType IN (@NewTeamMember, @OwnerTeamChange, @MemberTeamChange, @MemberApplication) AND eeq.IsOwner = 1
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = c.Name,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = u2.UserName,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType IN (@NewTeamMember, @OwnerTeamChange, @MemberTeamChange, @MemberApplication) AND eeq.IsOwner = 1
	)
)
UNION ALL
(
	-- Do the New team member for clubs 'ET_VOTEADDED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = c.Name,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = u2.UserName,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = vm.Response,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	INNER JOIN dbo.VoteMembers vm WITH(NOLOCK) ON vm.VoteID = eeq.ItemID2 AND eeq.ItemType2 = @VoteType AND vm.UserID = eeq.EventuserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @VoteAdded
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = c.Name,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = u2.UserName,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = vm.Response,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		INNER JOIN dbo.VoteMembers vm WITH(NOLOCK) ON vm.VoteID = eeq.ItemID2 AND eeq.ItemType2 = @VoteType AND vm.UserID = eeq.EventuserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType = @VoteAdded
	)
)
UNION ALL
(
	-- Do the New team member for clubs 'ET_VOTEREMOVED'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = c.Name,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = u2.UserName,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @VoteRemoved
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = c.Name,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = u2.UserName,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType = @VoteRemoved
	)
)
UNION ALL
(
	-- Do the links added 'ET_URL'
	-- FIRST THE ARTICLE LINKS
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = c.Name,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = g.Subject,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
	INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.h2g2id = eeq.ItemID2
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @LinkAdded AND eeq.ItemType2 = @ArticleType
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = c.Name,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = g.Subject,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
		INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.h2g2id = eeq.ItemID2
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType = @LinkAdded AND eeq.ItemType2 = @ArticleType
	)
)
UNION ALL
(
	-- Do the links added 'ET_URL'
	-- FIRST THE URL LINKS
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = c.Name,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = l.LinkDescription,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
	INNER JOIN dbo.Links l WITH(NOLOCK) ON l.LinkID = eeq.ItemID2
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @LinkAdded AND eeq.ItemType2 = @URLType
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = c.Name,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = l.LinkDescription,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.InstantEMailAlertList iel WITH(NOLOCK) ON iel.InstantEMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = iel.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = iel.UserID AND p.SiteID = iel.SiteID
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = eeq.ItemID AND eeq.ItemType = @ClubType
		INNER JOIN dbo.Links l WITH(NOLOCK) ON l.LinkID = eeq.ItemID2
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = iel.SiteID
		WHERE eeq.EventType = @LinkAdded AND eeq.ItemType2 = @URLType
	)
)
UNION ALL
(
	-- Do the links added 'ET_CATEGORYHIDDEN'
	SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
			eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 1, eeq.IsOwner,
			eeq.ItemID, eeq.ItemType,
			'ItemName' = h.DisplayName,
			eeq.ItemID2, eeq.ItemType2,
			'ItemName2' = h2.DisplayName,
			'EventUserID' = u2.UserID,
			'EventUserName' = u2.UserName,
			'EventUserFirstNames' = u2.FirstNames,
			'EventUserLastName' = u2.LastName,
			'EventUserSiteSuffix' = p2.SiteSuffix,
			'EventUserTitle' = p2.Title,
			'VoteResponse' = NULL,
			'ItemType3' = NULL,
			'ItemName3' = NULL,
			'ItemID3' = NULL,
			eeq.ListID
	FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
	INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
	LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
	INNER JOIN dbo.Hierarchy h WITH(NOLOCK) ON h.NodeID = eeq.ItemID
	INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID2
	INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
	LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
	WHERE eeq.EventType = @NodeHidden
	UNION ALL
	(
		SELECT	u.UserID, u.UserName, u.FirstNames, u.LastName, p.SiteSuffix, p.Title, dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) AS EMail,
				eeq.EventType, eeq.EventDate, eeq.NotifyType, eeq.SiteID, 'EMailType' = 2, eeq.IsOwner,
				eeq.ItemID, eeq.ItemType,
				'ItemName' = h.DisplayName,
				eeq.ItemID2, eeq.ItemType2,
				'ItemName2' = h2.DisplayName,
				'EventUserID' = u2.UserID,
				'EventUserName' = u2.UserName,
				'EventUserFirstNames' = u2.FirstNames,
				'EventUserLastName' = u2.LastName,
				'EventUserSiteSuffix' = p2.SiteSuffix,
				'EventUserTitle' = p2.Title,
				'VoteResponse' = NULL,
				'ItemType3' = NULL,
				'ItemName3' = NULL,
				'ItemID3' = NULL,
				eeq.ListID
		FROM dbo.EMailEventQueue eeq WITH(NOLOCK)
		INNER JOIN dbo.EMailAlertList el WITH(NOLOCK) ON el.EMailAlertListID = eeq.ListID
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = el.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = el.UserID AND p.SiteID = el.SiteID
		INNER JOIN dbo.Hierarchy h WITH(NOLOCK) ON h.NodeID = eeq.ItemID
		INNER JOIN dbo.Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = eeq.ItemID2
		INNER JOIN dbo.Users u2 WITH(NOLOCK) ON u2.UserID = eeq.EventUserID
		LEFT JOIN dbo.Preferences p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID = el.SiteID
		WHERE eeq.EventType = @NodeHidden
	)
)
ORDER BY eeq.NotifyType ASC, u.UserID ASC, eeq.SiteID ASC, eeq.EventDate DESC

