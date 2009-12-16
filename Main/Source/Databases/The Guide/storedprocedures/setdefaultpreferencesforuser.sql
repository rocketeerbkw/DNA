CREATE PROCEDURE setdefaultpreferencesforuser @userid int, @siteid int = 0
As
INSERT INTO Preferences (UserID, PrefForumStyle, PrefForumThreadStyle, PrefForumShowMaxPosts, PrefReceiveWeeklyMailshot, 
					PrefReceiveDailyUpdates, PrefSkin, PrefUserMode, SiteID, AgreedTerms, PrefXML, Title, 
					SiteSuffix, PrefStatus, PrefStatusDuration, PrefStatusChangedDate, ContentFailedOrEdited)
	SELECT @userid, PrefForumStyle, PrefForumThreadStyle, PrefForumShowMaxPosts, PrefReceiveWeeklyMailshot, 
					PrefReceiveDailyUpdates, PrefSkin, PrefUserMode, SiteID, AgreedTerms, PrefXML, Title, 
					SiteSuffix, PrefStatus, PrefStatusDuration, PrefStatusChangedDate, ContentFailedOrEdited
	FROM Preferences
	WHERE UserID = 0 AND (@siteid = 0 OR SiteID = @siteid)
RETURN @@ERROR

