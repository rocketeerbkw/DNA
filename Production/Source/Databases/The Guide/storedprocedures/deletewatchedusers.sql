CREATE PROCEDURE deletewatchedusers				@userid int, 
																		@watch1 int = NULL,
																		@watch2 int = NULL,
																		@watch3 int = NULL,
																		@watch4 int = NULL,
																		@watch5 int = NULL,
																		@watch6 int = NULL,
																		@watch7 int = NULL,
																		@watch8 int = NULL,
																		@watch9 int = NULL,
																		@watch10 int = NULL,
																		@watch11 int = NULL,
																		@watch12 int = NULL,
																		@watch13 int = NULL,
																		@watch14 int = NULL,
																		@watch15 int = NULL,
																		@watch16 int = NULL,
																		@watch17 int = NULL,
																		@watch18 int = NULL,
																		@watch19 int = NULL,
																		@watch20 int = NULL,
																		@currentsiteid INT =0 
AS
BEGIN
	EXEC openemailaddresskey

	DELETE FROM FaveForums
	WHERE UserID = @userid AND ForumID IN 
																( 
																		SELECT J.ForumID
																		FROM Journals J
																		WHERE J.UserID IN 
																		(
																				@watch1,
																				@watch2,
																				@watch3,
																				@watch4,
																				@watch5,
																				@watch6,
																				@watch7,
																				@watch8,
																				@watch9,
																				@watch10,
																				@watch11,
																				@watch12,
																				@watch13,
																				@watch14,
																				@watch15,
																				@watch16,
																				@watch17,
																				@watch18,
																				@watch19,
																				@watch20
																		)
																		--end J.SiteID = @currentsiteid /* -- ? -- */
																)

	


	SELECT f.*, 
	u.UserID,
	u.Cookie,
	dbo.udf_decryptemailaddress(u.EncryptedEmail,u.userid) AS 'email',
	u.UserName,
	u.Password,
	u.FirstNames,
	u.LastName,
	u.Active,
	--u.Masthead, - not required
	u.DateJoined,
	u.Status,
	u.Anonymous,
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
	u.TeamID,
	u.Postcode,
	u.Area,
	u.TaxonomyNode,
	u.UnreadPublicMessageCount,
	u.UnreadPrivateMessageCount,
	u.Region,
	u.HideLocation,
	u.HideUserName,
	p.title, p.sitesuffix 
	FROM Forums AS f
	--INNER JOIN Users AS u ON f.ForumID = u.Journal
	INNER JOIN Journals J on J.ForumID = f.ForumID
	inner join Users u on U.UserID = J.UserID
	LEFT JOIN preferences AS p ON (p.userid = J.userid) and (p.siteid = @currentsiteid)
	WHERE J.UserID IS NOT NULL AND J.UserID IN 
								(
										@watch1,
										@watch2,
										@watch3,
										@watch4,
										@watch5,
										@watch6,
										@watch7,
										@watch8,
										@watch9,
										@watch10,
										@watch11,
										@watch12,
										@watch13,
										@watch14,
										@watch15,
										@watch16,
										@watch17,
										@watch18,
										@watch19,
										@watch20
								)	
	ORDER BY u.UserName
	
END