/*******************
Testing PostToForum 
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

	DECLARE @SiteID INT
	DECLARE @EntryID INT
	DECLARE @UserID INT
	DECLARE @ForumID INT
	DECLARE @ClubID	INT
	DECLARE @ThreadID INT

		SELECT @SiteID = 16
		SELECT @EntryID = 116510
		SELECT @UserID = 1090497730
		SELECT @ForumID = 1
		SELECT @ClubID = 2
		SELECT @ThreadID = 11

-- SET @Message = N'<EVENT><DESCRIPTION>PostToForum</DESCRIPTION><SITEID>16</SITEID><NODEID>1502</NODEID><ENTRYID>116510</ENTRYID><USERID>1090497730</USERID><THREADID>11</THREADID><FORUMID>1</FORUMID><CLUBID>2</CLUBID></EVENT>';
		SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>PostToForum</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@entryid as varchar(20))+'</ENTRYID><USERID>'+CAST(@UserID as varchar(20))+'</USERID><THREADID>'+CAST(@threadid as varchar(20))+'</THREADID><FORUMID>'+CAST(@forumid as varchar(20))+'</FORUMID><CLUBID>'+CAST(@clubid as varchar(20))+'</CLUBID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


SEND ON CONVERSATION @ZeitgeistEvent
  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_PostToForum] (@Message)

/*******************
Testing CreateGuideEntry
********************/
/*******************
Testing PostToForum 
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

	DECLARE @SiteID INT
	DECLARE @EntryID INT
	DECLARE @UserID INT
	DECLARE @ForumID INT
	DECLARE @ClubID	INT
	DECLARE @ThreadID INT

		SELECT @SiteID = 16
		SELECT @EntryID = 116510
		SELECT @UserID = 1090497730

-- SET @Message = N'<EVENT><DESCRIPTION>PostToForum</DESCRIPTION><SITEID>16</SITEID><NODEID>1502</NODEID><ENTRYID>116510</ENTRYID><USERID>1090497730</USERID><THREADID>11</THREADID><FORUMID>1</FORUMID><CLUBID>2</CLUBID></EVENT>';
		SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>CreateGuideEntry</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@entryid as varchar(20))+'</ENTRYID><USERID>'+CAST(@UserID as varchar(20))+'</USERID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


SEND ON CONVERSATION @ZeitgeistEvent
  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry] (@Message)
/*******************
Testing AddArticleToHierarchy
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

DECLARE @siteid INT
DECLARE @entryid INT
DECLARE @userid INT
DECLARE @nodeid INT

SELECT @siteid = 16
SELECT @entryid = 116510
SELECT @userid = 1090497730
SELECT @nodeid = 1501

SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddArticleToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@entryid as varchar(20))+'</ENTRYID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


	SEND ON CONVERSATION @ZeitgeistEvent
	  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy] (@Message)


/*******************
Testing AddClubToHierarchy
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

DECLARE @siteid INT
DECLARE @clubid INT
DECLARE @userid INT
DECLARE @nodeid INT

SELECT @siteid = 16
SELECT @clubid = 1222
SELECT @userid = 1090497730
SELECT @nodeid = 1501

SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddClubToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><CLUBID>'+CAST(@clubid as varchar(20))+'</CLUBID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


	SEND ON CONVERSATION @ZeitgeistEvent
	  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy] (@Message)

/*******************
Testing AddPositiveResponseToVote
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

DECLARE @siteid INT
DECLARE @clubid INT
DECLARE @userid INT
DECLARE @EntryID INT
DECLARE @ThreadID INT

SELECT @siteid = 16
SELECT @clubid = 1222
SELECT @userid = 1090497730
SELECT @EntryID = 116510

SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddPositiveResponseToVote</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@EntryID as varchar(20))+'</ENTRYID><USERID>'+CAST(@userid as varchar(20))+'</USERID><CLUBID>'+CAST(@ClubID as varchar(20))+'</CLUBID><THREADID>'+CAST(ISNULL(@ThreadID, '') as varchar(20))+'</THREADID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


	SEND ON CONVERSATION @ZeitgeistEvent
	  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote] (@Message)

/*******************
Testing AddNegativeResponseToVote
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

DECLARE @siteid INT
DECLARE @clubid INT
DECLARE @userid INT
DECLARE @EntryID INT
DECLARE @ThreadID INT

SELECT @siteid = 16
SELECT @clubid = 1222
SELECT @userid = 1090497730
SELECT @EntryID = 116510
SELECT @ThreadID = null

SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddNegativeResponseToVote</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@EntryID as varchar(20))+'</ENTRYID><USERID>'+CAST(@UserID as varchar(20))+'</USERID><CLUBID>'+CAST(@ClubID as varchar(20))+'</CLUBID><THREADID>'+CAST(ISNULL(@ThreadID, '') as varchar(20))+'</THREADID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


	SEND ON CONVERSATION @ZeitgeistEvent
	  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddNegativeResponseToVote] (@Message)

/*******************
Testing AddThreadToHierarchy
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

DECLARE @siteid INT
DECLARE @forumid INT
DECLARE @userid INT
DECLARE @nodeid INT
DECLARE @threadid INT

SELECT @siteid = 16
SELECT @userid = 1090497730
SELECT @threadid = 487548
SELECT @forumid = 139371
SELECT @nodeid = 1501

SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddThreadToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID><THREADID>'+CAST(@threadid as varchar(20))+'</THREADID><FORUMID>'+CAST(@forumid as varchar(20))+'</FORUMID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


	SEND ON CONVERSATION @ZeitgeistEvent
	  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy] (@Message)

/*******************
Testing CompleteClubAction
********************/
DECLARE @ZeitgeistEvent uniqueidentifier
DECLARE @Message nvarchar(2500)

DECLARE @siteid INT
DECLARE @clubid INT

SELECT @siteid = 16
SELECT @clubid = 1222

SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>UserJoinTeam</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><CLUBID>'+CAST(@clubid as varchar(20))+'</CLUBID></ZEITGEISTEVENT>';

BEGIN DIALOG CONVERSATION @ZeitgeistEvent
  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
  WITH ENCRYPTION = OFF;


	SEND ON CONVERSATION @ZeitgeistEvent
	  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CompleteClubAction] (@Message)


/*******************
RESULTS
********************/

select *
  from dbo.ContentSignifArticle -- 1110
 where EntryID = 116510

select *
  from dbo.ContentSignifNode-- 119.1
 where NodeId = 1501

select *
  from dbo.ContentSignifUser-- 1120
 where UserID = 1090497730

select *
  from dbo.ContentSignifForum-- 60
 where ForumID = 139371

select *
  from dbo.ContentSignifThread-- 20
 where ThreadId = 487548

select *
  from dbo.ContentSignifClub-- 44
 where ClubId = 1222