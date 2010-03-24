/*
		Author:		DE
        Created:	11/05/2005
        Inputs:		-iUser : id of the user whose votes are to be obtained
						-iSiteID : the id of the site - usually 16 for ican
        Outputs:	-true if successful, false otherwise
        Returns:	-returns a resultset containing details of all the threads and clubs a user 
						-has voted for. In Ican these translates as Notices and Campaigns 
        Purpose:	-Get all the items a user has voted for
*/
CREATE PROCEDURE getvotescastbyuser @iuserid INT, @isiteid INT 
AS
BEGIN
		SELECT 
					t.threadid AS ObjectID, 
					t.forumid AS ForumID,  
					t.FirstSubject AS Title, 
					t.Type, 
					vm.VoteID, 
					vm.Response, 
					t.DateCreated, 
					vm.DateVoted, 	
					u.UserID AS CreatorID, 
					u.UserName AS CreatorUsername					
		FROM votemembers AS vm WITH(NOLOCK)
		INNER JOIN votes AS v WITH(NOLOCK) ON v.voteid = vm.voteid  
		INNER JOIN threadvotes AS tv WITH(NOLOCK) ON tv.voteid = vm.voteid  
		INNER JOIN [threads] AS t WITH(NOLOCK) ON t.threadid = tv.threadid
		INNER JOIN threadentries AS te WITH(NOLOCK) ON te.threadid = t.threadid
		INNER JOIN forums AS f WITH(NOLOCK) ON f.forumid = t.forumid		
		INNER JOIN Users AS u WITH(NOLOCK) ON  u.UserID = te.UserID		
		WHERE vm.userid = @iuserid AND f.siteid = @isiteid AND t.visibleto IS NULL AND t.CanRead <> 0 
UNION
		SELECT 
					c.clubid AS ObjectID, 
					c.clubforum AS ForumID,  
					c.[name] AS Title, 
					"type"='Club',  
					cv.VoteID, 
					vm.Response, 
					"DateCreated" = ISNULL(c.DateCreated,g.DateCreated), 
					vm.DateVoted,
					u.UserID AS CreatorID, 
					u.UserName AS CreatorUsername
		FROM votemembers AS vm WITH(NOLOCK)
		INNER JOIN votes AS v WITH(NOLOCK) ON v.voteid = vm.voteid  
		INNER JOIN clubvotes AS cv WITH(NOLOCK) ON cv.voteid = vm.voteid  
		INNER JOIN clubs AS c WITH(NOLOCK) ON c.clubid = cv.clubid
		INNER JOIN GuideEntries g WITH(NOLOCK) ON c.h2g2id = g.h2g2id AND g.status != 7
		INNER JOIN Users AS u WITH(NOLOCK) ON  u.UserID = g.Editor		
		WHERE vm.userid = @iuserid AND c.siteid = @isiteid AND c.CanView <> 0
END 