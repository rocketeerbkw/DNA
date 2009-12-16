/*
	@nodeid - category node / hierarchy node
	@type - filter for article type
	@maxresults - max number of results to fetch.
	@showcontentrating - adds content rating info to resultset.
	@usernodeid - local user node/location node
	@currentsiteid - ?
	This stored procedure is a special case of getarticlesinhierarchynode with the additional feature of 
	being able to identify if an article is local to user. If this is modified then also propogate the change into
	getarticlesinhierarchy node.
	The idea of this stored procedure is to restrict the number of articles returned to maxresults 
	but also to balance the articltypes returned. 
	It attempts to pull out the same number of each article type but will allow any
	unused allocation to 'roll-over' to subsequent article types.
*/
CREATE PROCEDURE getarticlesinhierarchynodewithlocal_rating_usernode_withtype @nodeid INT, @type  INT, @maxresults INT = 500, 
	@usernodeid int, @currentsiteid int = 0
AS
BEGIN

	--String for representing query
	DECLARE @SELECT VARCHAR(8000)
	SET @SELECT = ''
	
	-- Set ContentRatingData fields and join tables
	declare @ContentRatingDataSelect varchar(100)
	declare @ContentRatingDataJoin varchar(200)

		set @ContentRatingDataSelect =	',pv.voteid CRPollID, pv.AverageRating CRAverageRating, pv.VoteCount CRVoteCount '
		set @ContentRatingDataJoin =	' left outer join PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1 ' +
		  			' left outer join Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3 '
	
	declare @LocalMemberDataSelect varchar(100)
	declare @LocalMemberDataJoin varchar(400)
	
	--when a non zero @usernodeid specified calculate if article is local
	if (@usernodeid > 0) begin
		--use a temporary table to hold all the nodea that are local to a user
		SELECT 'nodeid'=a.nodeid INTO #UserLocalNodes
		FROM Ancestors a WITH(NOLOCK)
		WHERE a.ancestorid = @usernodeid
		INSERT INTO #UserLocalNodes VALUES(@usernodeid)

		CREATE INDEX [IDX_ULN] ON #UserLocalNodes (nodeid)
		
		set @LocalMemberDataSelect = ', ''local'' = case when g.h2g2id = g2.h2g2id then 1 else 0 end '
		
	end else begin
		set @LocalMemberDataSelect = ''
		set @LocalMemberDataJoin = ''
	end
	
	
		--Results filtered on type - get a count for inclusion in resultset.
		DECLARE @iActualRows int
		SELECT @iActualRows = COUNT(*)
			FROM HierarchyArticleMembers a WITH(NOLOCK)	
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7
			WHERE a.nodeid = @nodeid AND g.Type  = @type
			  AND g.Hidden IS NULL

			
			
		--Restrict number of rows to MaxResults
		SELECT TOP(@maxresults) 'TypeCount' = @iActualRows
		, g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName 'editorName'
		,pv.voteid CRPollID, pv.AverageRating CRAverageRating, pv.VoteCount CRVoteCount 
		, 'local' = case when g.h2g2id = g2.h2g2id then 1 else 0 end 
		, 	U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
		P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle
		FROM HierarchyArticleMembers a WITH(NOLOCK)
		INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
		LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor
		LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserId = u.UserID AND p.SiteID = @currentsiteid
		LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
		left join GuideEntries g2 WITH(NOLOCK) on 
				(EXISTS (select ham.nodeid from HierarchyArticleMembers ham WITH(NOLOCK)
							inner join #UserLocalNodes uln on uln.nodeid = ham.nodeid
							where ham.EntryID = g2.EntryID and g2.EntryID = g.EntryID  AND g.Type = @type )) 
		left outer join PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1
		left outer join Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3
		WHERE a.nodeid = @nodeid AND g.Type  = @type
		ORDER BY g.DateCreated DESC
		
	
	--delete the temporary table if required
	if (@usernodeid > 0) begin
		DROP TABLE #UserLocalNodes
	end
	
	RETURN(0)
END






