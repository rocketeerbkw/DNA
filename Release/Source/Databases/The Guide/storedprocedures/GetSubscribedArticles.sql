CREATE PROCEDURE getsubscribedarticles @userid INT, @siteid INT, @firstindex INT, @lastindex INT
AS

	/*
		Function: Get all articles by authors the user has subscribed to.

		Params:
			@userid		- the user who wants most recent articles of from those they have subscribed to.
			@siteid		- the site viewing the subscribed articles from
			@firstindex - index of first article to be included in results set (1 based index)
			@lastindex	- index of last article to be included in results set (1 based index)

		Results Set: 1st - KeyPhrase - Namespace pairs assocciated with recent subscribed articles. 
					 2nd - Recent subscribed articles

		Returns: @@ERROR

		Throws: 
	*/

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RecentSubscribedArticles TABLE (Total INT, EntryID INT, h2g2ID INT, RowNumber INT); 

	WITH ArticlesSubscribedTo AS 
	(
		SELECT sub.EntryID, vge.h2g2ID, ROW_NUMBER() OVER(ORDER BY sub.DateCreated DESC) as 'rn', sub.DateCreated
		  FROM dbo.ArticleSubscriptions sub
				INNER JOIN dbo.udf_GetVisibleSites(@siteid) vs ON sub.SiteID = vs.SiteID
				INNER JOIN dbo.VVisibleGuideEntries vge ON sub.EntryID = vge.EntryID
		 WHERE sub.UserId = @userid
	)
	INSERT INTO @RecentSubscribedArticles (Total, EntryID, h2g2ID, RowNumber)
	SELECT (SELECT count(*) FROM ArticlesSubscribedTo) AS 'Total', EntryID, h2g2ID, rn
	  FROM ArticlesSubscribedTo
	 WHERE rn BETWEEN @firstindex AND @lastindex;

	-- KeyPhrase - Namespace pairs assocciated with recent subscribed articles results set
	SELECT rsa.EntryID, rsa.h2g2ID, kp.PhraseId, kp.phrase, ns.NameSpaceID, ns.Name as Namespace
	  FROM @RecentSubscribedArticles rsa
			LEFT JOIN dbo.ArticleKeyPhrases akp ON rsa.EntryID = akp.EntryID AND akp.siteid = @siteid
			LEFT JOIN dbo.PhraseNameSpaces pns ON akp.PhraseNameSpaceID = pns.PhraseNameSpaceID
			LEFT JOIN dbo.KeyPhrases kp ON pns.PhraseID = kp.PhraseID
			LEFT JOIN dbo.NameSpaces ns ON pns.NameSpaceID = ns.NameSpaceID
	ORDER BY rsa.EntryID;

	-- Recent subscribed articles results set
	SELECT ge.EntryID, 
			ge.h2g2ID,
			ge.subject,
			ge.editor,
			ge.extrainfo,
			ge.datecreated,
			ge.lastupdated,
			ge.Type,
			ge.Status,
			ge.ForumID,
			ge.ModerationStatus,
			ge.Preprocessed,
			ge.Submittable,
			ge.Style,
			ge.Hidden,
			ge.CanRead,
			ge.CanWrite,
			ge.CanChangePermissions,	
			ge.text,	
			1 as 'IsMainArticle',	
			(select count(*) FROM @RecentSubscribedArticles) as 'count',
			rsa.Total as 'total',
			ama.MediaAssetID,
			ge.SiteID,
			ma.Caption,
			ma.Filename,
			ma.MimeType,
			ma.ContentType,
			ma.ExtraElementXML,
			ma.OwnerID,
			ma.DateCreated 'MADateCreated',
			ma.LastUpdated 'MALastUpdated',
			ma.Description,
			ma.Hidden,
			ma.ExternalLinkURL,
			pv.voteid AS 'CRPollID',
			pv.AverageRating AS 'CRAverageRating',
			pv.VoteCount AS 'CRVoteCount',
			ge.Hidden AS 'ArticleHidden',
			adr.StartDate,
			adr.EndDate,
			adr.TimeInterval,
			u.UserName,
			u.FirstNames,
			u.LastName,
			u.Status,
			u.Active,
			u.Postcode,
			u.Area,
			u.TaxonomyNode,
			u.UnreadPublicMessageCount,
			u.UnreadPrivateMessageCount,
			u.Region,
			u.HideLocation,
			u.HideUserName,
			f.ForumPostCount,
			csa.Score AS 'ZeitgeistScore'
	  FROM @RecentSubscribedArticles rsa
			INNER JOIN dbo.GuideEntries ge ON ge.EntryID = rsa.EntryID 
			INNER JOIN dbo.Forums f ON f.ForumID = ge.ForumID
			INNER JOIN dbo.Users u ON u.Userid = ge.editor
			LEFT JOIN dbo.ArticleMediaAsset ama ON ama.EntryID = rsa.EntryID 
			LEFT JOIN dbo.MediaAsset ma ON ma.ID = ama.MediaAssetID
			LEFT JOIN dbo.PageVotes pv on pv.itemid = ge.h2g2id and pv.itemtype=1
			LEFT JOIN dbo.ArticleDateRange adr ON adr.EntryID = rsa.EntryID 
			LEFT JOIN dbo.ContentSignifArticle csa ON csa.EntryID = ge.EntryID 
	ORDER BY rsa.RowNumber ASC; -- equivalent of DateCreated DESC above

RETURN @@ERROR