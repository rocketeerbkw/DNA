CREATE  PROCEDURE finduserfromidwithorwithoutmasthead @userid int, @siteid int
AS

-- If no userid supplied, assume the h2g2id of the user's masthead has been supplied
-- just select every field since we want them all anyway

declare @AutoSinBin int
exec updateautosinbinstatus @userid, @siteid, @AutoSinBin output

EXEC openemailaddresskey;

select TOP 1 
			u.UserID,
			u.Cookie,
			dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) as email,
			u.UserName,
			u.Password,
			u.FirstNames,
			u.LastName,
			u.Active,
			--u.Masthead,
			'Masthead' = dbo.udf_generateh2g2id(m.EntryID),
			u.DateJoined,
			u.Status,
			u.Anonymous,
			--u.Journal,
			'Journal' = J.ForumID,
			u.Latitude,
			u.Longitude,
			u.SinBin,
			u.DateReleased,
			u.Prefs1,
			u.Recommended,
			u.Friends,
			u.LoginName,
			u.BBCUID,
			ut.TeamID,
			u.Postcode,
			u.Area,
			u.TaxonomyNode,
			u.UnreadPublicMessageCount,
			u.UnreadPrivateMessageCount,
			u.Region,
			u.HideLocation,
			u.HideUserName,
			u.AcceptSubscriptions,
			'PrivateForum' = t.ForumID,
			AgreedTerms,
			PrefSkin,
			PrefUserMode,
			PrefForumStyle,
			PrefForumThreadStyle,
			PrefForumShowMaxPosts,
			PrefReceiveWeeklyMailshot,
			PrefReceiveDailyUpdates,
			PrefXML,
			Title,
			SiteSuffix,
			PrefStatus,
			CASE WHEN mcm.ModClassId IS NULL THEN 0 ELSE 1 END 'IsModClassMember',
			'AutoSinBin' = @AutoSinBin,
			'BannedFromComplaints' = CASE WHEN be.EncryptedEmail IS NULL THEN 0 ELSE 1 END
from Users U WITH(NOLOCK)
LEFT JOIN UserTeams ut WITH(NOLOCK) ON ut.UserID = u.UserID AND ut.SiteID = @siteid
LEFT JOIN Teams t WITH(NOLOCK) ON ut.TeamID = t.TeamID
left join Preferences P WITH(NOLOCK) on (P.UserID = U.UserID OR P.UserID = 0) AND (P.SiteID = @siteid OR @siteid = 0 OR P.SiteID IS NULL )
INNER JOIN Sites s WITH(NOLOCK) ON s.SiteId = @siteid
LEFT JOIN ModerationClassMembers mcm WITH(NOLOCK) ON mcm.UserId = @userid AND s.ModClassId = mcm.ModClassId
LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = u.UserID and J.SiteID = @siteid
LEFT JOIN MastHeads m WITH(NOLOCK) on U.UserID = m.UserID AND m.SiteID = @siteid
LEFT JOIN dbo.BannedEMails be WITH(NOLOCK) ON dbo.udf_decryptemailaddress(u.EncryptedEmail,u.UserId) = dbo.udf_decryptemailaddress(be.EncryptedEmail,0) AND be.ComplaintBanned = 1
where U.UserID = @userid
ORDER BY P.UserID DESC
