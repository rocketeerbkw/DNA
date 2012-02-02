// Forum.cpp: implementation of the CForum class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#include "stdafx.h"
#include "tdvassert.h"
#include "GuideEntry.h"
#include "ReviewForum.h"
#include "ProfanityFilter.h"
#include ".\forum.h"
#include "StoredProcedure.h"
#include ".\TagItem.h"
#include "EMailAlertGroup.h"
#include "EmailAddressFilter.h"
#include "URLFilter.h"
#include "XMLStringUtils.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CForum::CForum(CInputContext& inputContext) : CXMLObject(inputContext)

	Author:		Jim Lynn
	Created:	16/03/2000
	Inputs:		inputContext - input context
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for the forum object. Does nothing.

*********************************************************************************/

CForum::CForum(CInputContext& inputContext) : CXMLObject(inputContext), m_SiteID(0), m_ForumID(0)
{
	// Nothing more
}

/*********************************************************************************

	CForum::~CForum()

	Author:		Jim Lynn
	Created:	16/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	dtor for the CForum object. No specific destruction required
				over the base class.

*********************************************************************************/

CForum::~CForum()
{

}

/*********************************************************************************

	bool CForum::GetMostRecent(int iForumID)

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		iForumID - ID of the forum we want to fetch
	Outputs:	-
	Returns:	true if succeeded, false otherwise
	Purpose:	Tells the Forum object to get the most recent thread information
				ready to be inserted. This is the method that should be used for
				adding the most recent threads to an article.
				<ARTICLEFORUM>
					<FORUMID>12345</FORUMID>
					<THREAD>
					  <THREADID>40643</THREADID> 
					  <SUBJECT>Interesting</SUBJECT> 
					  <DATEPOSTED>
						<DATE DAYNAME="Wednesday" SECONDS="12" MINUTES="21" HOURS="00" DAY="23" MONTH="02" MONTHNAME="February" YEAR="2000" RELATIVE="3 Weeks ago" /> 
					  </DATEPOSTED>
					</THREAD>
				</ARTICLEFORUM>

*********************************************************************************/

bool CForum::GetMostRecent(int iForumID, CUser* pViewer)
{
	m_ForumID = iForumID;
	if (iForumID <= 0)
	{
		CreateFromXMLText("<NOFORUMFOUND/>");
		return true;
	}
	bool bSuccess = GetThreadList(pViewer, iForumID, 10,0);
	if (bSuccess)
	{
		CXMLTree* pTree = CXMLTree::Parse("<ARTICLEFORUM/>");
		
		// This will pull out the root node and delete the rest of the tree
		// so m_pTree  == NULL
		CXMLTree* pTemp = ExtractTree();

		// Find the <ARTICLEFORUM> node
		CXMLTree* pNode = pTree->FindFirstTagName("ARTICLEFORUM", 0, false);
		if (pNode != NULL)
		{
			pNode->AddChild(pTemp);
			m_pTree = pTree;
		}
		else
		{
			delete pTree;
			pTree = NULL;
			bSuccess = false;
		}
	}
	
	return bSuccess;

	// declare a string to hold the XML returned by the SP
	CTDVString sThreads = "";

	// Create the stored procedure and fail if we couldn't get it
	CStoredProcedure SP;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create stored procedure object in CForum::GetMostRecent");
		return false;
	}

	// Get the result from the stored procedure
	bSuccess = SP.ForumGetMostRecent(iForumID, sThreads);

	if (bSuccess)
	{
		bSuccess = CreateFromXMLText(sThreads);
	}
	SP.Release();

	UpdateRelativeDates();
	return bSuccess;
}


/*********************************************************************************

	bool CForum::GetThreadList(CUser* pViewer, int ForumID, int NumThreads, int NumSkipped, int iThreadID, bool bOverflow, const int iThreadOrder)

	Author:		Jim Lynn
	Created:	07/03/2000
	Inputs:		pViewer - user viewing the thread list (or NULL if none)
				ForumID - ID of the forum to fetch threads from
				NumThreads - maximum number of threads to fetch
				NumSkipped - number of threads to skip before fetching
				iThreadID - optional thread ID - will cause us to override the skip value
				bOverflow - optional. If true, causes one extra thread to be included before and
							one after the set of NumThreads 
				iThreadOrder - thread order
	Outputs:	-
	Returns:	true if results were found, false otherwise
	Purpose:	Given a forum ID, fetches a number of threads into its internal tree.
				This method can be used on pages displaying the threads only

*********************************************************************************/

bool CForum::GetThreadList(CUser* pViewer, int ForumID, int NumThreads, int NumSkipped, int iThreadID, bool bOverflow, const int  iThreadOrder)
{
	m_ForumID = ForumID;
	if (NumThreads > 200) 
	{
		NumThreads = 200;
	}

	// get the forum siteid
	GetForumSiteID(ForumID,0,m_SiteID);
	
	TDVASSERT(NumThreads > 0, "Stupid to not fetch any threads from forum");
	CTDVString sThreads = "";

	CStoredProcedure SP;
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CForum::GetThreadList");
		return false;
	}

	if (iThreadID > 0)
	{
		// override NumSkipped if we want a particular thread
		int iThreadIndex = SP.GetIndexOfThreadInForum(iThreadID, ForumID);

		// Calculate the block it lives in
		NumSkipped = iThreadIndex / NumThreads;
		NumSkipped = NumSkipped * NumThreads;
	}
	
	CTDVString cachename = "FT";
	int overflow;
	if (bOverflow)
	{
		overflow = 1;
	}
	else
	{
		overflow = 0;
	}
	cachename << ForumID << "-" << NumSkipped << "-" << NumSkipped + NumThreads - 1 << "-" << overflow <<"-" << iThreadOrder << ".txt";

	CTDVDateTime dLastDate;
	SP.CacheGetMostRecentThreadDate(ForumID, &dLastDate);
	SP.Release();

	if (CacheGetItem("forumthreads", cachename, &dLastDate, &sThreads))
	{
		// this should not fail, but might if cache is garbled so check anyway
		if (CreateFromCacheText(sThreads))
		{
			SetSiteIDFromTree("FORUMTHREADS");
			SetForumIDFromTree("FORUMTHREADS");
			FilterOnPermissions(pViewer, ForumID, "FORUMTHREADS");
			FilterIndividualThreadPermissions(pViewer, "FORUMTHREADS", "THREAD");
			UpdateRelativeDates();
			return true;
		}
	}
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CForum::GetThreadList");
		return false;
	}
	
	// If we fail to get a thread list (e.g. because SP.GetThreadList() times out), then make sure
	// we don't cache the XML, otherwise dodgy XML will be cached for the forum.
	bool bCacheXML = true;

	if (bOverflow) 
	{
		// We want to fetch the one before the first and the one after the second
		if (NumSkipped <= 0)
		{
			bCacheXML = SP.GetThreadList(ForumID, 0, NumThreads, iThreadOrder);
		}
		else
		{
			bCacheXML = SP.GetThreadList(ForumID, NumSkipped-1, NumSkipped + NumThreads, iThreadOrder);
		}
	}
	else
	{
		bCacheXML = SP.GetThreadList(ForumID, NumSkipped, NumSkipped + NumThreads - 1, iThreadOrder);
	}

	bool bDefaultCanRead = true;
	bool bDefaultCanWrite = true;
	bool bThreadCanRead = true;
	bool bThreadCanWrite = true;
	int iTotalThreads = 0;
	int iModerationStatus = 0;
	int iForumPostCount = 0;
	int iAlertInstantly = 0;
	
	int iJournalOwner = 0;

	if (!SP.IsEOF())
	{
		if(SP.FieldExists("JournalOwner"))
		{
			iJournalOwner = SP.GetIntField("JournalOwner");
		}
		bDefaultCanRead = SP.GetBoolField("CanRead");
		bDefaultCanWrite = SP.GetBoolField("CanWrite");
		bThreadCanRead = SP.GetBoolField("ThreadCanRead");
		bThreadCanWrite = SP.GetBoolField("ThreadCanWrite");
		iModerationStatus = SP.GetIntField("ModerationStatus");
		m_SiteID = SP.GetIntField("SiteID");
		if(SP.FieldExists("ForumPostCount"))
		{
			iForumPostCount = SP.GetIntField("ForumPostCount");
		}
		iAlertInstantly = SP.GetIntField("AlertInstantly");
	}
	
	// If there aren't any more threads we should still return an empty set
	// not fail

	sThreads = "<FORUMTHREADS FORUMID='";
	sThreads << ForumID << "' SKIPTO='" << NumSkipped << "' COUNT='" << NumThreads << "'";
	if (iJournalOwner > 0)
	{
		sThreads << " JOURNALOWNER='" << iJournalOwner << "'";
	}
	
	if (!SP.IsEOF())
	{
		iTotalThreads = SP.GetIntField("ThreadCount");
		sThreads << " TOTALTHREADS='" << iTotalThreads << "'";
	}
	
	sThreads << " FORUMPOSTCOUNT='" << iForumPostCount << "' ";
	sThreads << " FORUMPOSTLIMIT='" << m_InputContext.GetCurrentSiteOptionInt("Forum", "PostLimit") << "' ";
	sThreads << " SITEID='" << m_SiteID << "'";
	sThreads << " CANREAD=";
	if (bDefaultCanRead)
	{
		sThreads << "'1'";
	}
	else
	{
		sThreads << "'0'";
	}
	sThreads << " CANWRITE=";
	if (bDefaultCanWrite)
	{
		sThreads << "'1'";
	}
	else
	{
		sThreads << "'0'";
	}

	if (bThreadCanRead)
	{
		sThreads << " THREADCANREAD='1'";
	}
	else
	{
		sThreads << " THREADCANREAD='0'";
	}
	if (bThreadCanWrite)
	{
		sThreads << " THREADCANWRITE='1'";
	}
	else
	{
		sThreads << " THREADCANWRITE='0'";
	}
	
	if (iTotalThreads > (NumSkipped + NumThreads)) 
	{
		sThreads << " MORE='1'";
	}
	
	// Add the alert instantly flag
	sThreads << " ALERTINSTANTLY='" << iAlertInstantly << "'";

	sThreads << ">";

	sThreads << "<MODERATIONSTATUS ID='" << ForumID << "'>";
	sThreads<< iModerationStatus << "</MODERATIONSTATUS>";

	// Got a list, so let's skip the first NumSkipped threads
//	if (NumSkipped > 0)
//	{
//		if (bOverflow)
//		{
//			SP.MoveNext(NumSkipped-1);
//		}
//		else
//		{
//			SP.MoveNext(NumSkipped);
//		}
//	}

	int iIndex = 0;
	bool bFirstItem = true;

	if (bOverflow)
	{
		if (NumSkipped == 0)
		{
			NumThreads += 1;
		}
		else
		{
			NumThreads += 2;
		}
	}
	//DEBUG
	CTDVString sORDER;
	GetThreadOrderDesc(iThreadOrder, sORDER);
	sThreads << "<ORDERBY>" << sORDER << "</ORDERBY>";
	//DEBUG
	while (!SP.IsEOF() && iTotalThreads > 0 && NumThreads > 0)
	{
		int iThisCanRead = SP.GetIntField("ThisCanRead");
		int iThisCanWrite = SP.GetIntField("ThisCanWrite");
		int ThreadID = SP.GetIntField("ThreadID");
		CTDVString sSubject = "";
		SP.GetField("FirstSubject", sSubject);
		EscapeAllXML(&sSubject);
		CTDVDateTime dDate = SP.GetDateField("LastPosted");
		CTDVString sDate = "";
		dDate.GetAsXML(sDate);
		
		CTDVString sDateFirstPosted;
		dDate = SP.GetDateField("FirstPosting");
		dDate.GetAsXML(sDateFirstPosted);
		CTDVString bodytext;
		SP.GetField("FirstPostText", bodytext);
		CTDVString sUserName;
		SP.GetField("FirstPostUserName", sUserName);
		MakeSubjectSafe(&sUserName);
		int iUserID = SP.GetIntField("FirstPostUserID");
		int iPostID = SP.GetIntField("FirstPostEntryID");
		int iCountPosts = SP.GetIntField("cnt");
		int iLastUserID = SP.GetIntField("LastPostUserID");
		int iNotable	= SP.GetIntField("FirstPostNotableUser");
		int iLastNotable= SP.GetIntField("LastPostNotableUser");
		CTDVString sLastUserName;
		SP.GetField("LastPostUserName", sLastUserName);
		CTDVString sLastText;
		SP.GetField("LastPostText", sLastText);
		MakeSubjectSafe(&sLastUserName);

		int iFirstPostHidden = SP.GetIntField("FirstPostHidden");
		int iLastPostHidden = SP.GetIntField("LastPostHidden");

		if (SP.GetIntField("FirstPostStyle") != 1) 
		{
			MakeTextSafe(bodytext);
		}
		else
		{
			CTDVString sTemp;
			sTemp << "<RICHPOST>" << bodytext << "</RICHPOST>";
			bodytext = sTemp;
		}
		if (SP.GetIntField("LastPostStyle") != 1) 
		{
			MakeTextSafe(sLastText);
		}
		else
		{
			CTDVString sTemp;
			sTemp << "<RICHPOST>" << sLastText << "</RICHPOST>";
			sLastText = sTemp;
		}
		int iFinalPostID = SP.GetIntField("LastPostEntryID");

		sThreads << "<THREAD FORUMID='" << ForumID << "' THREADID='" << ThreadID << "' INDEX='" << iIndex << "'";
		if (bOverflow && bFirstItem && (NumSkipped > 0))
		{
			sThreads << " OVERFLOW='1'";
		}
		if (bOverflow && (NumThreads == 1))
		{
			sThreads << " OVERFLOW='2'";
		}

		// Add the CanRead and CanWrite For the Thread
		sThreads << " CANREAD='" << iThisCanRead << "' CANWRITE='" << iThisCanWrite << "'>";

		sThreads << "<THREADID>" << ThreadID << "</THREADID>";
		sThreads << "<SUBJECT>" << sSubject;
		if (iThisCanRead == 0)
		{
			sThreads << " - Hidden";
		}
		sThreads << "</SUBJECT>";
		sThreads << "<DATEPOSTED>" << sDate << "</DATEPOSTED>";
		sThreads << "<TOTALPOSTS>" << iCountPosts << "</TOTALPOSTS>";

		// Put the thread type and eventdate into the xml if it exists!
		if (SP.FieldExists("type"))
		{
			CTDVString sType;
			SP.GetField("Type",sType);
			sThreads << "<TYPE>" << sType << "</TYPE>";
		}

		// Put the thread type and eventdate into the xml if it exists!
		if (SP.FieldExists("eventdate") && !SP.IsNULL("eventdate"))
		{
			CTDVDateTime dEventDate = SP.GetDateField("EventDate");
			CTDVString sEventDate;
			dEventDate.GetAsXML(sEventDate,true);
			sThreads << "<EVENTDATE>" << sEventDate << "</EVENTDATE>";
		}

		// Insert the details of the first person who posted
		sThreads << "<FIRSTPOST POSTID='" << iPostID << "' HIDDEN='" << SP.GetIntField("FirstPostHidden") << "'>"
			<< sDateFirstPosted
			<< "<USER><USERID>" << iUserID << "</USERID><USERNAME>" << sUserName << "</USERNAME>";

		// Get the title of the first person to post
		CTDVString sFirstPostTitle;
		SP.GetField("FirstPostTitle", sFirstPostTitle);
		EscapeXMLText(&sFirstPostTitle);
		if (!SP.IsNULL("FirstPostTitle"))
		{
			sThreads << "<TITLE>" << sFirstPostTitle << "</TITLE>\n";
		}
		
		// Get the area of the first person to post
		CTDVString sFirstPostArea;
		SP.GetField("FirstPostArea", sFirstPostArea);
		EscapeXMLText(&sFirstPostArea);
		if (!SP.IsNULL("FirstPostArea"))
		{
			sThreads << "<AREA>" << sFirstPostArea << "</AREA>\n";
		}
		
		InitialiseXMLBuilder(&sThreads, &SP);
		bool bOk = AddDBXMLTag("FirstPostFirstNames","FIRSTNAMES",false);
		bOk = bOk && AddDBXMLTag("FirstPostLastName","LASTNAME",false);
		bOk = bOk && AddDBXMLTag("FirstPostSiteSuffix","SITESUFFIX",false);
		bOk = bOk && AddDBXMLTag("FirstPostStatus","STATUS",false);
		bOk = bOk && AddDBXMLTag("FirstPostTaxonomyNode","TAXONOMYNODE",false);
		bOk = bOk && AddDBXMLTag("FirstPostJournal","JOURNAL",false);
		bOk = bOk && AddDBXMLTag("FirstPostActive","ACTIVE",false);

		if(iNotable > 0)
		{
			sThreads << "<NOTABLE>" << iNotable << "</NOTABLE>";
		}

		// Add Groups
		CTDVString sGroupsXML;
		if(!m_InputContext.GetUserGroups(sGroupsXML, iUserID))
		{
			TDVASSERT(false, "Failed to get user groups");
		}
		else
		{
			sThreads << sGroupsXML;
		}

		sThreads << "</USER>";
		
		if (iFirstPostHidden != 0) 
		{
			sThreads << "<TEXT>Hidden</TEXT>";
		}
		else
		{
			sThreads << "<TEXT>" << bodytext << "</TEXT>\n";
		}
		sThreads << "</FIRSTPOST>\n";
		
		// Now get the details of the last person to post
		sThreads << "<LASTPOST POSTID='" << iFinalPostID << "' HIDDEN='" << SP.GetIntField("LastPostHidden") << "'>"
			<< sDate
			<< "<USER><USERID>" << iLastUserID << "</USERID><USERNAME>" << sLastUserName << "</USERNAME>\n";
		
		
		// Get the title of the last person to post
		CTDVString sLastPostTitle;
		SP.GetField("LastPostTitle", sLastPostTitle);
		EscapeXMLText(&sLastPostTitle);
		if (!SP.IsNULL("LastPostTitle"))
		{
			sThreads << "<TITLE>" << sLastPostTitle << "</TITLE>\n";
		}
		
		// Get the area of the last person to post
		CTDVString sLastPostArea;
		SP.GetField("LastPostArea", sLastPostArea);
		EscapeXMLText(&sLastPostArea);
		if (!SP.IsNULL("LastPostArea"))
		{
			sThreads << "<AREA>" << sLastPostArea << "</AREA>\n";
		}
		
		bOk = bOk && AddDBXMLTag("LastPostFirstNames","FIRSTNAMES",false);
		bOk = bOk && AddDBXMLTag("LastPostLastName","LASTNAME",false);
		bOk = bOk && AddDBXMLTag("LastPostSiteSuffix","SITESUFFIX",false);
		bOk = bOk && AddDBXMLTag("LastPostStatus","STATUS",false);
		bOk = bOk && AddDBXMLTag("LastPostTaxonomyNode","TAXONOMYNODE",false);
		bOk = bOk && AddDBXMLTag("LastPostJournal","JOURNAL",false);
		bOk = bOk && AddDBXMLTag("LastPostActive","ACTIVE",false);
					
		TDVASSERT(bOk,"Problems getting first, last name and site suffix for posts!");
		if(iLastNotable > 0)
		{
			sThreads << "<NOTABLE>" << iLastNotable << "</NOTABLE>";
		}

		// Add Groups
		CTDVString sLastUserGroupsXML;
		if(!m_InputContext.GetUserGroups(sLastUserGroupsXML, iLastUserID))
		{
			TDVASSERT(false, "Failed to get user groups");
		}
		else
		{
			sThreads << sLastUserGroupsXML;
		}

		sThreads << "</USER>\n";
		
		
		if (iFirstPostHidden != 0) 
		{
			sThreads << "<TEXT>Hidden</TEXT>";
		}
		else
		{
			sThreads << "<TEXT>" << sLastText << "</TEXT>\n";
		}
		sThreads << "</LASTPOST>\n";
		sThreads << "</THREAD>\n";
		SP.MoveNext();
		bFirstItem = false;
		NumThreads--;
		iIndex++;
	}
	sThreads << "</FORUMTHREADS>";
	bool bSuccess = CreateFromXMLText(sThreads);
	
	// If we haven't yet reached EOF then set the 'more' flag
//	if (bSuccess && iTotalThreads > 0 && !SP.IsEOF())
//	{
//		// Get the node and add a MORE attribute
//		CXMLTree* pFNode = m_pTree->FindFirstTagName("FORUMTHREADS");
//		TDVASSERT(pFNode != NULL, "Can't find FORUMTHREADS node");
//		
//		if (pFNode != NULL)
//		{
//			pFNode->SetAttribute("MORE","1");
//		}
//	}

	SP.Release();

	if (bSuccess && bCacheXML)
	{
		CTDVString StringToCache;
		//GetAsString(StringToCache);
		CreateCacheText(&StringToCache);
		CachePutItem("forumthreads", cachename, StringToCache);
	}
	
	if (bSuccess)
	{
		FilterOnPermissions(pViewer, ForumID, "FORUMTHREADS");
		FilterIndividualThreadPermissions(pViewer,"FORUMTHREADS","THREAD");
		UpdateRelativeDates();
	}
	
	return bSuccess;
}

/*********************************************************************************

	bool CForum::GetPostsInThread(int ForumID, int ThreadID, int NumPosts, int NumSkipped, int iPost, bool bOrderByDatePostedDesc=false)

	Author:		Jim Lynn
	Created:	21/03/2000
	Inputs:		ForumID - ID of forum
				ThreadID - ID of thread in forum
				NumPosts - number of posts to display
				NumSkipped - number of posts to skip before displaying NumPosts
				iPost - ID of a specific post to show (overrides NumSkipped if >0)
				bOrderByDatePostedDesc - order resultset by date desc order
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CForum::GetPostsInThread(CUser* pViewer, int ForumID, int ThreadID, int NumPosts, int NumSkipped, int iPost, bool bOrderByDatePostedDesc/*=false*/)
{
	m_ForumID = ForumID;

	// Make sure this object is empty
	TDVASSERT(IsEmpty(),"Can't call GetPostsInThread if the object isn't empty");
	if (!IsEmpty())
	{
		return false;
	}

	int iViewingUserID = 0;
	if (pViewer != NULL)
	{
		iViewingUserID = pViewer->GetUserID();
	}

	if (NumPosts > 200) 
	{
		NumPosts = 200;
	}
	
	CTDVString sPosts = "";		// String to contain the XML

	CTDVString cachename = "FPOSTS";
	cachename << "-" << ThreadID << "-" << NumSkipped << "-" << NumSkipped + NumPosts - 1 << ".txt";

	// Create a stored procedure object to use
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetPostsInThread");
		return false;
	}
	
	int iLastPost = 0;
	CTDVDateTime dLastDate;
	if ( !SP.CacheGetThreadLastUpdated(ThreadID, &dLastDate) )
	{
		TDVASSERT(false, "Failed to getthread lastupdated.");
		SetDNALastError("CForum::GetPostsInThread","GetPostsInThread","Failed to get thread last updated.");
		return false;
	}
	SP.Release();

	bool bGotCache = false;

//	if ((NumSkipped + NumPosts) < iLastPost + 1 )
//	{
//		bGotCache = CacheGetItem("forumposts", cachename, NULL, &sPosts);
//	}
//	else
//	{
		bGotCache = CacheGetItem("forumposts", cachename, &dLastDate, &sPosts);
//	}

	if (bGotCache)
	{
		CreateFromXMLText(sPosts);
		SetSiteIDFromTree("FORUMTHREADPOSTS");
		SetForumIDFromTree("FORUMTHREADPOSTS");
		SetUsersGroupAlertForThread(iViewingUserID, ThreadID);
		FilterThreadPermissions(pViewer, m_ForumID, ThreadID, "FORUMTHREADPOSTS");
		UpdateRelativeDates();
		return true;
	}
	
	// Initialise DB object again
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetPostsInThread");
		return false;
	}

	// if we want to display a post, find its position - which block it's in
	if (iPost > 0)
	{
		// This will override NumSkipped. First find the index of the required
		// post in the list
		int iPostIndex = SP.GetIndexOfPostInThread(ThreadID, iPost);

		// Now we have to find the block it's in
		NumSkipped = iPostIndex / NumPosts;
		NumSkipped = NumSkipped * NumPosts;
	}
	
	// Call the stored procedure to get the post data
	// We fetch the posts from NumSkipped-1 to NumSkipped + NumPosts
	// This gives us the previous post and the next post if they exist
	if (NumSkipped <= 0)
	{
		// There isn't a previous post anyway...
		SP.ForumGetThreadPosts( ThreadID, NumSkipped, NumSkipped + NumPosts, bOrderByDatePostedDesc );
	}
	else
	{
		SP.ForumGetThreadPosts( ThreadID, NumSkipped-1, NumSkipped + NumPosts, bOrderByDatePostedDesc );
	}

	// Skip over all the posts we don't care about *except* the one
	// before the first one we display - this is so we can get the ID
	// of the previous post so we can skip back properly
	
	int iLastPostOnPreviousPage = 0;
	int iFirstPostOnNextPage = 0;
	int iTotalPosts = 0;
	int iForumPostCount = 0;
	bool bDefaultCanRead = true;
	bool bDefaultCanWrite = true;
	bool bAlertInstantly = false;
	
	if (!SP.IsEOF())
	{
		bDefaultCanRead = SP.GetBoolField("CanRead");
		bDefaultCanWrite = SP.GetBoolField("CanWrite");
		iTotalPosts = SP.GetIntField("Total");
		ForumID = SP.GetIntField("ForumID");
		m_ForumID = ForumID;
		m_SiteID = SP.GetIntField("SiteID");
		iForumPostCount = SP.GetIntField("ForumPostCount");
		bAlertInstantly = (SP.GetIntField("AlertInstantly") > 0);
	}

	if (NumSkipped > 0)
	{
		// Skip all but one
		if (NumSkipped > 1)
		{
//			SP.MoveNext(NumSkipped - 1);
		}
		if (!SP.IsEOF())
		{
			iLastPostOnPreviousPage = SP.GetIntField("EntryID");
			SP.MoveNext();
		}
	}

	sPosts << "<FORUMTHREADPOSTS FORUMID='" << ForumID << "' ALERTINSTANTLY='" << bAlertInstantly << "' THREADID='" << ThreadID << "' SKIPTO='" << NumSkipped << "' COUNT='" << NumPosts << "'";
	if (bDefaultCanRead)
	{
		sPosts << " CANREAD='1'";
	}
	else
	{
		sPosts << " CANREAD='0'";
	}
	if (bDefaultCanWrite)
	{
		sPosts << " CANWRITE='1'";
	}
	else
	{
		sPosts << " CANWRITE='0'";
	}

	if (SP.IsEOF())
	{
		GetForumSiteID(ForumID,ThreadID, m_SiteID);
	}

	sPosts << " FORUMPOSTCOUNT='" << iForumPostCount << "' ";
	sPosts << " FORUMPOSTLIMIT='" << m_InputContext.GetCurrentSiteOptionInt("Forum", "PostLimit") << "' ";
	sPosts << " TOTALPOSTCOUNT='" << iTotalPosts << "' SITEID='" << m_SiteID << "'";

	sPosts << ">";

	// Insert the subject of the first post
	CTDVString sFirstPostSubject = "";
	if(!SP.IsEOF())
	{
		SP.GetField("FirstPostSubject",sFirstPostSubject);
		EscapeAllXML(&sFirstPostSubject);
	}
	sPosts << "<FIRSTPOSTSUBJECT>" << sFirstPostSubject << "</FIRSTPOSTSUBJECT>";

	CTDVString sPostType;
	int iPostType = 0;
	int iCount = 0;
	while (!SP.IsEOF() && NumPosts > 0)
	{
		int iPostID = SP.GetIntField("EntryID");
		int iInReplyTo = SP.GetIntField("Parent");
		int iPrevSibling = SP.GetIntField("PrevSibling");
		int iNextSibling = SP.GetIntField("NextSibling");
		int iFirstChild = SP.GetIntField("FirstChild");
		int iUserID = SP.GetIntField("UserID");
		int iHidden = SP.GetIntField("Hidden");
		int iEditor = SP.GetIntField("Editor");
		int iNotable = SP.GetIntField("Notable");
		
		CTDVString sSubject = "";
		if (iHidden > 0)
		{
			sSubject = "Removed";
		}
		else
		{
			SP.GetField("Subject", sSubject);
		}
		CTDVDateTime dDate = SP.GetDateField("DatePosted");
		CTDVString sDate = "";
		dDate.GetAsXML(sDate);
		
		CTDVString sUserName = "";
		SP.GetField("UserName",sUserName);
		if (sUserName.GetLength() == 0)
		{
			sUserName << "Member " << iUserID;
		}

		CTDVString sRawText = "";
		if (iHidden == 3) // 3 means premoderated! - Hidden!
		{
			sRawText = "This post has been Hidden";
		}
		else if (iHidden > 0)
		{
			sRawText = "This post has been removed";
		}
		else
		{
			SP.GetField("text",sRawText);
		}
		
		CTDVString sText;
		if (SP.GetIntField("PostStyle") != 1)
		{
			MakeTextSafe(sRawText);
			sText << "<TEXT>" << sRawText << "</TEXT>";
		}
		else
		{
			sText << "<TEXT><RICHPOST>" << sRawText << "</RICHPOST></TEXT>";
		}
		//MakeSubjectSafe(&sSubject);
		EscapeAllXML(&sSubject);

		// start creating the post structure
		sPosts << "<POST POSTID='" << iPostID << "'";
		
		// We have an incrementing index field for the next and
		// previous buttons
		sPosts << " INDEX='" << iCount << "'";
		
		// Put a 'Previous' attribute in if applicable
//			if (iCount > 0)
//			{
//				sPosts << " PREVINDEX='" << iCount-1 << "'";
//			}

		// Always put in a next field, the stylesheet can work it out
//			sPosts << " NEXTINDEX='" << iCount+1 << "'";
		
		// Increment the index here
		iCount++;

		// This *might* be useful...
		if (iInReplyTo > 0)
		{
			sPosts << " INREPLYTO='" << iInReplyTo << "'";
		}

		if (iPrevSibling > 0)
		{
			sPosts << " PREVSIBLING='" << iPrevSibling << "'";
		}

		if (iNextSibling > 0)
		{
			sPosts << " NEXTSIBLING='" << iNextSibling << "'";
		}

		if (iFirstChild > 0)
		{
			sPosts << " FIRSTCHILD='" << iFirstChild << "'";
		}

		sPosts << " HIDDEN='" << iHidden << "'";

		// Can this post still be edited?
		if (iViewingUserID == iUserID)
		{
			sPosts << " EDITABLE=\"" << GetPostEditableAttribute(iUserID, dDate) << "\"";
		}
		else
		{
			// Avoid calling too many functions, won't be editable anyway
			sPosts << " EDITABLE=\"0\"";
		}

		sPosts << ">";
		sPosts << "<SUBJECT>" << sSubject << "</SUBJECT>\n";

		sPosts << "<DATEPOSTED>" << sDate << "</DATEPOSTED>\n";

		// Only add LASTUPDATED if LastUpdated != DateCreated
		//
		if (!SP.IsNULL("LastUpdated"))
		{
			CTDVDateTime dLastUpdated = SP.GetDateField("LastUpdated");
			CTDVString sLastUpdated;
			dLastUpdated.GetAsXML(sLastUpdated);
			sPosts << "<LASTUPDATED>" << sLastUpdated << "</LASTUPDATED>\n";
		}

		sPosts << "<USER><USERID>" << iUserID << "</USERID><USERNAME>";
		if (iHidden > 0)
		{
			sPosts << "Researcher " << iUserID;
		}
		else
		{
			sPosts << sUserName;
		}

		sPosts << "</USERNAME>";
		CTDVString sTitle;
		if (!SP.IsNULL("Title"))
		{
			SP.GetField("Title",sTitle);
			EscapeXMLText(&sTitle);
			sPosts << "<TITLE>" << sTitle << "</TITLE>";
		}

		CTDVString sArea;
		if (!SP.IsNULL("Area"))
		{	
			SP.GetField("Area",sArea);
			EscapeXMLText(&sArea);
			sPosts << "<AREA>" << sArea << "</AREA>";
		}
		
		InitialiseXMLBuilder(&sPosts, &SP);
		bool bOk = AddDBXMLTag("FirstNames",NULL,false);
		bOk = bOk && AddDBXMLTag("LastName",NULL,false);
		bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);
		bOk = bOk && AddDBXMLTag("Status","STATUS",false);
		bOk = bOk && AddDBXMLTag("TaxonomyNode","TAXONOMYNODE",false);
		bOk = bOk && AddDBXMLTag("Journal","JOURNAL",false);
		bOk = bOk && AddDBXMLTag("Active","ACTIVE",false);

		TDVASSERT(bOk,"Problems getting first, last name and site suffix for posts!");
		
		sPosts << "<EDITOR>" << iEditor << "</EDITOR>";
		sPosts << "<NOTABLE>" << iNotable << "</NOTABLE>";

		// Add Groups
		CTDVString sGroupsXML;
		if(!m_InputContext.GetUserGroups(sGroupsXML, iUserID))
		{
			TDVASSERT(false, "Failed to get user groups");
		}
		else
		{
			sPosts << sGroupsXML;
		}


		sPosts << "</USER>\n";

		// Add the event date if it has one!
		bOk = bOk && AddDBXMLDateTag("eventdate",NULL,false,true);

		// Get the Type of post we're looking at
		bOk = bOk && AddDBXMLTag("type",NULL,false,true,&sPostType);

		// Now see if we are an event or notice, if so put the taginfo in for the post
		if (sPostType.CompareText("Notice") || sPostType.CompareText("Event"))
		{
			// We've got a notice or event! Get all the tag info
			CTagItem TagItem(m_InputContext);
			if (TagItem.InitialiseFromThreadId(ThreadID,m_SiteID,pViewer) && TagItem.GetAllNodesTaggedForItem())
			{
				TagItem.GetAsString(sPosts);
			}
		}

		sPosts << sText;
		sPosts << "</POST>";

		NumPosts--;
		SP.MoveNext();
	}

	sPosts << "</FORUMTHREADPOSTS>";
	bool bSuccess = CreateFromXMLText(sPosts);

	// If we haven't yet reached EOF then set the 'more' flag
	if (bSuccess && !SP.IsEOF())
	{
		// Get the node and add a MORE attribute
		CXMLTree* pFNode = m_pTree->FindFirstTagName("FORUMTHREADPOSTS", 0, false);
		TDVASSERT(pFNode != NULL, "Can't find FORUMTHREADPOSTS node");
		
		if (pFNode != NULL)
		{
			pFNode->SetAttribute("MORE","1");
		}

		// Also get the ID of the next post
		iFirstPostOnNextPage = SP.GetIntField("EntryID");
	}

	SP.Release();
	
	if (bSuccess)
	{
		// Now add the PREVINDEX and NEXTINDEX attributes for all the nodes
		CXMLTree* pNode = m_pTree->FindFirstTagName("POST", 0, false);
		CXMLTree* pPrevNode = NULL;
		int iPrevID = 0;

		// loop through the tree setting this node's PREVINDEX to iPrevID
		// and remembering the previous ID
		while (pNode != NULL)
		{
			int iThisNodeID = pNode->GetIntAttribute("POSTID");
			// If we've got a previous node ID, this one's PREVINDEX should
			// be set to that
			if (iPrevID > 0)
			{
				pNode->SetAttribute("PREVINDEX",iPrevID);
			}
			else
			{
				if (iLastPostOnPreviousPage > 0)
				{
					pNode->SetAttribute("PREVINDEX", iLastPostOnPreviousPage);
				}
			}

			// Now set the NEXTINDEX attribute of the previous node if it
			// exists
			if (pPrevNode != NULL)
			{
				pPrevNode->SetAttribute("NEXTINDEX",iThisNodeID);
			}
			
			// Now remember the current node and ID
			pPrevNode = pNode;
			iPrevID = iThisNodeID;

			// Find the next node in the tree
			pNode = pNode->FindNextTagNode("POST");
		}
		// Now set the attribute on the last node we found
		if ((pPrevNode != NULL) && (iFirstPostOnNextPage > 0))
		{
			pPrevNode->SetAttribute("NEXTINDEX", iFirstPostOnNextPage);
		}
	}
	
	CTDVString StringToCache;
	GetAsString(StringToCache);
	CachePutItem("forumposts", cachename, StringToCache);
	SetUsersGroupAlertForThread(iViewingUserID, ThreadID);
	FilterThreadPermissions(pViewer, ForumID, ThreadID, "FORUMTHREADPOSTS");
	UpdateRelativeDates();
	return bSuccess;		
}

/*********************************************************************************

	bool CForum::SetUsersGroupAlertForThread(int piUserID, int piThreadID)

	Author:		James Conway
	Created:	14/12/2005
	Inputs:		ID of user to check alerts for, ID of the thread to check for user's alert
	Outputs:	- 
	Returns:	true if successful, false if unsuccessful
	Purpose:	Get user's AlertGroupID of thread. If one exists insert AlertGroupID as attribute
				of FORUMTHREADPOSTS.
				

*********************************************************************************/
bool CForum::SetUsersGroupAlertForThread(int piUserID, int piThreadID)
{
	int iAlertGroupID = 0;

	// Get user's AlertGroupID of thread.
    if(piUserID)
	{
		CEMailAlertGroup EMailAlertGroup(m_InputContext);
		if(!EMailAlertGroup.HasGroupAlertOnItem(iAlertGroupID, piUserID, m_InputContext.GetSiteID(), CEmailAlertList::IT_THREAD, piThreadID))
		{
			TDVASSERT(false, "CForum::GetPostsInThread EMailAlertGroup.HasGroupAlert failed");
		}

		// If one exists insert AlertGroupID as attribute of FORUMTHREADPOSTS.
		if(iAlertGroupID)
		{
			CXMLTree* pFNode = m_pTree->FindFirstTagName("FORUMTHREADPOSTS", 0, false);
			TDVASSERT(pFNode != NULL, "Can't find FORUMTHREADPOSTS node");
			
			if (pFNode != NULL)
			{
				pFNode->SetAttribute("GROUPALERTID",iAlertGroupID);
			}
		}
	}
	return true; 
}
/*********************************************************************************

	bool CForum::WasLastPostRead(int* oPostCount, bool* bGotLastPost)

	Author:		Jim Lynn
	Created:	22/09/2003
	Inputs:		-
	Outputs:	oPostCount - Count of last post read (possibly not the last post in
				the forum)
				bGotLastPost - if it's got the last post
	Returns:	true if got postread information, false if result undefined
	Purpose:	-

*********************************************************************************/

bool CForum::WasLastPostRead(int* oPostCount, bool* bGotLastPost)
{
	if (IsEmpty()) 
	{
		return false;
	}
	CXMLTree* pRoot = m_pTree->FindFirstTagName("FORUMTHREADPOSTS", 0, false);
	if (pRoot == NULL) 
	{
		return false;
	}
	int iSkip = pRoot->GetIntAttribute("SKIPTO");
	int iShow = pRoot->GetIntAttribute("COUNT");
	int iTotalPosts = pRoot->GetIntAttribute("TOTALPOSTCOUNT");
	
	// Find the last post count on this page
	CXMLTree* pNode = pRoot->FindFirstTagName("POST", pRoot, false);
	CXMLTree* pFinalNode = NULL;
	while (pNode != NULL) 
	{
		pFinalNode = pNode;
		pNode = pNode->FindNextTagNode("POST", pRoot);
	}
	if (pFinalNode != NULL) 
	{
		// Count starts from 1 while index starts from 0
		*oPostCount = (pFinalNode->GetIntAttribute("INDEX")) + iSkip + 1;
		if ((iSkip + iShow) >= iTotalPosts)
		{
			*bGotLastPost = true;
		}
		else
		{
			*bGotLastPost = false;
		}
		return true;
	}
	else
	{
		return false;
	}
}

bool CForum::GetPostHeadersInThread(CUser* pViewer, int ForumID, int ThreadID, int NumToShow, int NumSkipped)
{
	m_ForumID = ForumID;
	// Make sure this object is empty
	TDVASSERT(IsEmpty(),"Can't call GetPostHeadersInThread if the object isn't empty");
	if (!IsEmpty())
	{
		return false;
	}

	if (NumToShow > 200) 
	{
		NumToShow = 200;
	}
	
	CTDVString sPosts = "";		// String to contain the XML

	CTDVString cachename = "FHEADERS";
	cachename << "-" << ThreadID << "-" << NumSkipped << "-" << NumSkipped + NumToShow - 1 << ".txt";

	// Create a stored procedure object to use
	CStoredProcedure SP;
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetPostHeadersInThread");
		return false;
	}

	int iLastPost = 0;
	CTDVDateTime dLastDate;
	SP.CacheGetForumMostRecentPost(ForumID, ThreadID, &iLastPost, &dLastDate);

	bool bGotCache = false;

	bGotCache = CacheGetItem("forumpostheaders", cachename, &dLastDate, &sPosts);

	if (bGotCache)
	{
		SetForumIDFromTree("FORUMTHREADHEADERS");
		CreateFromXMLText(sPosts);
		FilterThreadPermissions(pViewer, ForumID, ThreadID, "FORUMTHREADHEADERS");
		UpdateRelativeDates();
		return true;
	}
	
	// Call the stored procedure to get the post data
	bool bSuccess = true;

	// We don't care if these calls fail, since that merely means we don't
	// have any more threads to show, but it shouldn't signal failure in total
	// Note that we fetch one more post than we need - just so we can tell if there are any more
	// posts to come.
	SP.ForumGetThreadPostHeaders( ThreadID, NumSkipped, NumSkipped + NumToShow );

	int iTotalPosts = 0;
	int iForumPostCount = 0;
	bool bDefaultCanRead = 1;
	bool bDefaultCanWrite = 1;

	if (!SP.IsEOF())
	{
		iTotalPosts = SP.GetIntField("Total");
		bDefaultCanRead = SP.GetBoolField("CanRead");
		bDefaultCanWrite = SP.GetBoolField("CanWrite");
		ForumID = SP.GetIntField("ForumID");
		m_ForumID = ForumID;
		iForumPostCount = SP.GetIntField("ForumPostCount");
	}

//	if (NumSkipped > 0)
//	{
//		SP.MoveNext(NumSkipped);
//	}

	if (bSuccess)
	{
		sPosts = "<FORUMTHREADHEADERS FORUMID='";
		sPosts << ForumID << "' THREADID='" << ThreadID << "' SKIPTO='" << NumSkipped << "' COUNT='" << NumToShow << "'";
		sPosts << " FORUMPOSTCOUNT='" << iForumPostCount << "' ";
		sPosts << " FORUMPOSTLIMIT='" << m_InputContext.GetCurrentSiteOptionInt("Forum", "PostLimit") << "' ";
		sPosts << " TOTALPOSTCOUNT='" << iTotalPosts << "'";
		if (bDefaultCanRead)
		{
			sPosts << " CANREAD='1'";
		}
		else
		{
			sPosts << " CANREAD='0'";
		}
		if (bDefaultCanWrite)
		{
			sPosts << " CANWRITE='1'";
		}
		else
		{
			sPosts << " CANWRITE='0'";
		}
		sPosts << ">";
		
		CTDVString sPreviousSubject = "";
//		int iCount = 0;
		while (!SP.IsEOF() && NumToShow > 0)
		{
			int iPostID = SP.GetIntField("EntryID");
			int iInReplyTo = SP.GetIntField("Parent");
			int iUserID = SP.GetIntField("UserID");
			int iHidden = SP.GetIntField("Hidden");
			
			CTDVString sSubject = "";
			if (iHidden == 3) // 3 means premoderated! - Hidden!
			{
				sSubject = "Hidden";
			}
			else if (iHidden > 0)
			{
				sSubject = "Removed";
			}
			else
			{
				SP.GetField("Subject", sSubject);
			}

			CTDVDateTime dDate = SP.GetDateField("DatePosted");
			CTDVString sDate = "";
			dDate.GetAsXML(sDate);
			
			CTDVString sUserName = "";
			SP.GetField("UserName",sUserName);
			if (sUserName.GetLength() == 0)
			{
				sUserName << "Member " << iUserID;
			}
			
			sPosts << "<POST POSTID='" << iPostID << "'";

			// We have an incrementing index field for the next and
			// previous buttons
//			sPosts << " INDEX='" << iCount << "'";

			// Increment the count
//			iCount++;

			if (iInReplyTo > 0)
			{
				sPosts << " INREPLYTO='" << iInReplyTo << "'";
			}
			sPosts << " HIDDEN='" << iHidden << "'";

			sPosts << "><SUBJECT SAME='";
			if (sSubject.CompareText(sPreviousSubject))
			{
				sPosts << "1" << "'>";
			}
			else
			{
				sPosts << "0" << "'>";
			}
			sPreviousSubject = sSubject;
			EscapeAllXML(&sSubject);
			sPosts << sSubject << "</SUBJECT>\n";

			sPosts << "<DATEPOSTED>" << sDate << "</DATEPOSTED>\n";

			sPosts << "<USER><USERID>" << iUserID << "</USERID><USERNAME>";
			
			if (iHidden > 0)
			{
				sPosts << "Researcher " << iUserID;
			}
			else
			{
				sPosts << sUserName;
			}
			sPosts << "</USERNAME>";

			// Get the users title
			CTDVString sTitle;
			if (!SP.IsNULL("Title"))
			{
				SP.GetField("Title",sTitle);
				EscapeXMLText(&sTitle);
				sPosts << "<TITLE>" << sTitle << "</TITLE>";
			}

			// Get the users local area
			CTDVString sArea;
			if (!SP.IsNULL("Area"))
			{	
				SP.GetField("Area",sArea);
				EscapeXMLText(&sArea);
				sPosts << "<AREA>" << sArea << "</AREA>";
			}

			InitialiseXMLBuilder(&sPosts, &SP);
			bool bOk = AddDBXMLTag("FirstNames",NULL,false);
			bOk = bOk && AddDBXMLTag("LastName",NULL,false);
			bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);
			bOk = bOk && AddDBXMLTag("Status","STATUS",false);
			bOk = bOk && AddDBXMLTag("TaxonomyNode","TAXONOMYNODE",false);
			bOk = bOk && AddDBXMLTag("Journal","JOURNAL",false);
			bOk = bOk && AddDBXMLTag("Active","ACTIVE",false);

			TDVASSERT(bOk,"Problems getting first, last name and site suffix for posts!");

			// Add Groups
			CTDVString sGroupsXML;
			if(!m_InputContext.GetUserGroups(sGroupsXML, iUserID))
			{
				TDVASSERT(false, "Failed to get user groups");
			}
			else
			{
				sPosts << sGroupsXML;
			}

			sPosts << "</USER>\n";

			sPosts << "</POST>";

			NumToShow--;
			SP.MoveNext();
		}

		sPosts << "</FORUMTHREADHEADERS>";
		bSuccess = CreateFromXMLText(sPosts);

		// Now, see if there were any posts left, and if so, add a MORE attribute
		// to the FORUMTHREADHEADERS element.
		if (bSuccess && !SP.IsEOF())
		{
			CXMLTree* pFNode = m_pTree->FindFirstTagName("FORUMTHREADHEADERS", 0, false);
			TDVASSERT(pFNode != NULL, "NULL node returned - couldn't find FORUMTHREADHEADERS element");

			if (pFNode != NULL)
			{
				pFNode->SetAttribute("MORE","1");
			}
		}
	}
	SP.Release();

	CTDVString StringToCache;
	GetAsString(StringToCache);
	CachePutItem("forumpostheaders", cachename, StringToCache);
	FilterThreadPermissions(pViewer, ForumID, ThreadID, "FORUMTHREADHEADERS");
	UpdateRelativeDates();
	return bSuccess;		
}

/*********************************************************************************

	bool CForum::GetTitle(int iForumID, 
							int iThreadID, 
							bool bIncludeArticle, 
							int* piType, 
							int* pID, 
							CTDVString* psTitle, 
							int* piSiteID, 
							CTDVString* psUrl)

	Author:		Jim Lynn
	Created:	10/03/2000
	Inputs:		iForumID - ID of forum
				iThreadID - ID of thread in forum
	Outputs:	-
	Returns:	true if succeeded, false otherwise
	Purpose:	Builds an XML representation of the founr source, vis:
				<FORUMSOURCE>
					<JOURNAL>
						<USER>
							<USERID>6</USERID>
							<USERNAME>Jim Lynn</USERNAME>
						</USER>
					</JOURNAL>
				</FORUMSOURCE>
				
				or

				<FORUMSOURCE>
					<ARTICLE>
						<H2G2ID>12345</H2G2ID>
						<SUBJECT>Hello there</SUBJECT>
					</ARTICLE>
				</FORUMSOURCE>

				or

				<FORUMSOURCE>
					<USERPAGE>
						<USER>
							<USERID>6</USERID>
							<USERNAME>Jim Lynn</USERNAME>
						</USER>
					</USERPAGE>
				</FORUMSOURCE>

				or 

				<FORUMSOURCE>
					<CLUB ID= '1'>
						<NAME>Dharmesh Club</NAME>
					</CLUB>
				</FORUMSOURCE>
				
*********************************************************************************/

bool CForum::GetTitle(int iForumID, int iThreadID, bool bIncludeArticle, int* piType, int* pID, CTDVString* psTitle, int* piSiteID, CTDVString* psUrl)
{
	m_ForumID = iForumID;
	// Create a stored procedure object to use
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetTitle");
		return 0;
	}

	CTDVString sSubject = "";	// Subject based on type found
	int ID = 0;
	int type = 0;
	int site = 0;
	int userid = 0;
	int rfid = 0;
	int clubid = 0;
	int alertinstantly = 0;
	int iHiddenStatus = 0;
	int iArticleStatus = 0;

	CTDVString sFirstNames = "";
	CTDVString sLastName = "";
	CTDVString sArea = ""; 
	int nStatus = 0; 
	int nTaxonomyNode = 0;
	int nJournal = 0;
	int nActive = 0;
	CTDVString sSiteSuffix = "";
	CTDVString sSiteTitle = "";
	CTDVString sUrl = "";

	// Note that this next call will *change* the value of m_ForumID if the ID of the forum in which iThreadID lives doesn't
	// match the given ForumID (due to a dodgy URL, for example).
	bool bSuccess = SP.ForumGetSource(m_ForumID, iThreadID, type, ID, sSubject, site, userid, rfid, clubid, alertinstantly, sFirstNames, sLastName, sArea, nStatus, nTaxonomyNode, nJournal, nActive, sSiteSuffix, sSiteTitle, iHiddenStatus, iArticleStatus, sUrl);
	SP.Release();

	// Fill in return values
	if (piType != NULL)
	{
		*piType = type;
	}

	if (pID != NULL)
	{
		*pID = ID;
	}

	if (psTitle != NULL)
	{
		*psTitle = sSubject;
	}

	if (piSiteID != NULL)
	{
		*piSiteID = site;
	}

	MakeSubjectSafe(&sSubject);

	CTDVString sTitle = "";
	
	if (bSuccess)
	{
		if (type == 0)
		{
			// Get groups
			CTDVString sGroups;
			if(!m_InputContext.GetUserGroups(sGroups, userid))
			{
				TDVASSERT(false, "Failed to get user groups");
			}

			sTitle << "<FORUMSOURCE TYPE='journal'>";
			sTitle << "<JOURNAL><USER>" 
				   << "<USERID>"		<< userid			<< "</USERID>"
				   << "<USERNAME>"		<< sSubject			<< "</USERNAME>"
				   << "<FIRSTNAMES>"	<< sFirstNames		<< "</FIRSTNAMES>"
				   << "<LASTNAME>"		<< sLastName		<< "</LASTNAME>"
				   << "<AREA>"			<< sArea			<< "</AREA>"
				   << "<STATUS>"		<< nStatus			<< "</STATUS>"
				   << "<TAXONOMYNODE>"	<< nTaxonomyNode	<< "</TAXONOMYNODE>"
				   << "<JOURNAL>"		<< nJournal			<< "</JOURNAL>"
				   << "<ACTIVE>"		<< nActive			<< "</ACTIVE>"
				   << "<SITESUFFIX>"	<< sSiteSuffix		<< "</SITESUFFIX>"
				   << "<TITLE>"			<< sSiteTitle		<< "</TITLE>"
				   << sGroups
				   << "</USER></JOURNAL>"
				   << "</FORUMSOURCE>";
		}
		else if (type == 3)
		{
			// It's a review forum
			sTitle << "<FORUMSOURCE TYPE='reviewforum'>";
			sTitle << "<REVIEWFORUM ID='" << rfid << "'>";
			sTitle << "<REVIEWFORUMNAME>" << sSubject << "</REVIEWFORUMNAME>";
			sTitle << "<URLFRIENDLYNAME>" << "RF" << rfid << "</URLFRIENDLYNAME>";
			sTitle << "</REVIEWFORUM></FORUMSOURCE>";

		}
		else if (type == 1)
		{
			sTitle << "<FORUMSOURCE TYPE='article'/>";
		}
		else if (type == 5)
		{
			sTitle << "<FORUMSOURCE TYPE='club'>";
			sTitle << "<CLUB ID='" << clubid  << "'>";
			sTitle << "<NAME>" << sSubject << "</NAME></CLUB>";
		}
		else if (type == 6)
		{
			sTitle << "<FORUMSOURCE TYPE='clubforum'>";
			sTitle << "<CLUB ID='" << clubid <<"'>";
			sTitle << "<NAME>" << sSubject << "</NAME></CLUB>";
		}
		else if (type == 7)
		{
			sTitle << "<FORUMSOURCE TYPE='clubjournal'>";
			sTitle << "<CLUB ID='" << clubid <<"'>";
			sTitle << "<NAME>" << sSubject << "</NAME></CLUB>";
		}
		else if (type == 4)
		{
			// Get groups
			CTDVString sGroups;
			if(!m_InputContext.GetUserGroups(sGroups, userid))
			{
				TDVASSERT(false, "Failed to get user groups");
			}
			
 			sTitle << "<FORUMSOURCE TYPE='privateuser'>";
			
			sTitle << "<USERPAGE><USER>"
				   << "<USERID>"		<< userid			<< "</USERID>"
				   << "<USERNAME>"		<< sSubject			<< "</USERNAME>"
				   << "<FIRSTNAMES>"	<< sFirstNames		<< "</FIRSTNAMES>"
				   << "<LASTNAME>"		<< sLastName		<< "</LASTNAME>"
				   << "<AREA>"			<< sArea			<< "</AREA>"
				   << "<STATUS>"		<< nStatus			<< "</STATUS>"
				   << "<TAXONOMYNODE>"	<< nTaxonomyNode	<< "</TAXONOMYNODE>"
				   << "<JOURNAL>"		<< nJournal			<< "</JOURNAL>"
				   << "<ACTIVE>"		<< nActive			<< "</ACTIVE>"
				   << "<SITESUFFIX>"	<< sSiteSuffix		<< "</SITESUFFIX>"
				   << "<TITLE>"			<< sSiteTitle		<< "</TITLE>"
				   << sGroups
				   << "</USER></USERPAGE>";

			sTitle << "</FORUMSOURCE>";
		}
		else if (type == 8)
		{
			sTitle << "<FORUMSOURCE TYPE='noticeboard'/>";
		}
		else if (type == 9)
		{
			//acs forum - will redirect to the associated url.
			if (psUrl != NULL)
			{
				*psUrl = sUrl;
			}
		}
		else
		{
			// Get groups
			CTDVString sGroups;
			if(!m_InputContext.GetUserGroups(sGroups, userid))
			{
				TDVASSERT(false, "Failed to get user groups");
			}

			sTitle << "<FORUMSOURCE TYPE='userpage'>";
			
			sTitle << "<USERPAGE><USER>" 
				   << "<USERID>"		<< userid			<< "</USERID>"
				   << "<USERNAME>"		<< sSubject			<< "</USERNAME>"
				   << "<FIRSTNAMES>"	<< sFirstNames		<< "</FIRSTNAMES>"
				   << "<LASTNAME>"		<< sLastName		<< "</LASTNAME>"
				   << "<AREA>"			<< sArea			<< "</AREA>"
				   << "<STATUS>"		<< nStatus			<< "</STATUS>"
				   << "<TAXONOMYNODE>"	<< nTaxonomyNode	<< "</TAXONOMYNODE>"
				   << "<JOURNAL>"		<< nJournal			<< "</JOURNAL>"
				   << "<ACTIVE>"		<< nActive			<< "</ACTIVE>"
				   << "<SITESUFFIX>"	<< sSiteSuffix		<< "</SITESUFFIX>"
				   << "<TITLE>"			<< sSiteTitle		<< "</TITLE>"
				   << sGroups
				   << "</USER></USERPAGE>";

			sTitle << "</FORUMSOURCE>";
		}
		bSuccess = CreateFromXMLText(sTitle);

		if (ID > 0)
		{
			if (bIncludeArticle)
			{
				CGuideEntry GuideEntry(m_InputContext);
				CUser* pViewingUser = m_InputContext.GetCurrentUser();
				GuideEntry.Initialise(ID, site, pViewingUser, true, true, true, true);
				if (!GuideEntry.IsDeleted())
				{
					AddInside("FORUMSOURCE", &GuideEntry);
					sTitle = "<H2G2ID>";
					sTitle << ID << "</H2G2ID>";
					AddInside("ARTICLE", sTitle);
				}
				else
				{
					sTitle.Empty();
					sTitle << "<ARTICLE><H2G2ID>" << ID << "</H2G2ID>";
					sTitle << "<SUBJECT>Deleted</SUBJECT>";
					sTitle << "<HIDDEN>" << iHiddenStatus << "</HIDDEN>";
					CXMLStringUtils::AppendStatusTag(iArticleStatus,sTitle);
					sTitle << "</ARTICLE>";
					AddInside("FORUMSOURCE", sTitle);
				}
			}
			else
			{
				sTitle.Empty();
				sTitle << "<ARTICLE><H2G2ID>" << ID << "</H2G2ID>";
				sTitle << "<SUBJECT>" << sSubject << "</SUBJECT>";
				sTitle << "<HIDDEN>" << iHiddenStatus << "</HIDDEN>";
				CXMLStringUtils::AppendStatusTag(iArticleStatus,sTitle);
				sTitle << "</ARTICLE>";
				AddInside("FORUMSOURCE", sTitle);
			}

			//CTDVString sForumID;
			CTDVString sAlertInstantly;

			//sForumID << "<FORUM>" << m_ForumID << "</FORUM>";
			sAlertInstantly << "<ALERTINSTANTLY>" << alertinstantly << "</ALERTINSTANTLY>";
			
			//AddInside("FORUMSOURCE", sForumID);
			AddInside("FORUMSOURCE", sAlertInstantly);
		}
	}
	return bSuccess;
}

int CForum::GetLatestThreadInForum(int iForumID)
{
	m_ForumID = iForumID;
	// Create a stored procedure object to use
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetLatestThreadInForum");
		return 0;
	}

	int retval = SP.ForumGetLatestThreadID(iForumID);
	return retval;
}

bool CForum::GetJournal(CUser* pViewer, int iForumID, int NumToShow, int NumSkipped, bool bShowUserHidden )
{
	m_ForumID = iForumID;
	if (NumToShow > 200) 
	{
		NumToShow = 200;
	}
	CTDVString sPosts = "";

	// Create a stored procedure object to use
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetJournal");
		return 0;
	}

	CTDVString cachename = "J";
	cachename << iForumID << "-" << NumSkipped << "-" << NumSkipped + NumToShow - 1 << ".txt";

	CTDVDateTime dLastDate;
	SP.CacheGetMostRecentThreadDate(iForumID, &dLastDate);
	
	if (!bShowUserHidden && CacheGetItem("journal", cachename, &dLastDate, &sPosts))
	{
		SP.Release();
		CreateFromXMLText(sPosts);
		FilterOnPermissions(pViewer, iForumID, "JOURNALPOSTS", "POST");
		UpdateRelativeDates();
		return true;
	}
	
	// call the stored procedure to fetch the journal entries
	if (!SP.FetchJournalEntries(iForumID))
	{
		sPosts << "<JOURNALPOSTS FORUMID='" << iForumID << "' SKIPTO='" << NumSkipped << "' COUNT='" << NumToShow << "' TOTALTHREADS='0' CANREAD='1' CANWRITE='0'/>";
		return CreateFromXMLText(sPosts);
	}

	bool bSuccess = true;
	
	if (bSuccess)
	{
		sPosts = "<JOURNALPOSTS FORUMID='";
		sPosts << iForumID << "' SKIPTO='" << NumSkipped << "' COUNT='" << NumToShow << "'";
//		sPosts << "MODERATIONSTATUS='" << SP.GetIntField("ModerationStatus") << "'";
		int iTotalThreads = 0;
		bool bDefaultCanRead = 1;
		bool bDefaultCanWrite = 0;

		if (!SP.IsEOF())
		{
			iTotalThreads = SP.GetIntField("ThreadCount");
			bDefaultCanRead = SP.GetBoolField("CanRead");
			bDefaultCanWrite = SP.GetBoolField("CanWrite");
			sPosts << " TOTALTHREADS='" << iTotalThreads << "'";
			if (bDefaultCanRead)
			{
				sPosts << " CANREAD='1'";
			}
			else
			{
				sPosts << " CANREAD='0'";
			}
			if (bDefaultCanWrite)
			{
				sPosts << " CANWRITE='1'";
			}
			else
			{
				sPosts << " CANWRITE='0'";
			}
		}
		else
		{
			sPosts << " TOTALTHREADS='0' CANREAD='1' CANWRITE='0'";
		}
		sPosts << ">";

		// If we got some, skip to the ones we want
		if (NumSkipped > 0)
		{
			SP.MoveNext(NumSkipped);
		}

		CTDVString sPreviousSubject = "";
		int iCount = 0;
		while (!SP.IsEOF() && NumToShow > 0 && iTotalThreads > 0)
		{
			int iThreadID = SP.GetIntField("ThreadID");
			int iPostID = SP.GetIntField("EntryID");
			int iUserID = SP.GetIntField("UserID");
			int iCount = SP.GetIntField("Cnt");
			int iHidden = SP.GetIntField("Hidden");

			CTDVDateTime dLastReply = SP.GetDateField("LastReply");
			CTDVDateTime dDatePosted = SP.GetDateField("DatePosted");
			
			CTDVString sSubject = "";
			CTDVString sText = "";

			//Allow author to view their own user-hidden items.
			bool bShowHidden = (iHidden == CStoredProcedure::HIDDENSTATUSUSERHIDDEN  && bShowUserHidden && pViewer && pViewer->GetUserID() == iUserID);
			
			if ( iHidden > 0 && !bShowHidden )
			{
				sSubject = "Hidden";
				sText = "This post has been hidden";
			}
			else
			{
				SP.GetField("Subject", sSubject);
				SP.GetField("text",sText);
			}
			
			// Make the text safe
			if (SP.GetIntField("PostStyle") != 1) 
			{
				MakeTextSafe(sText);
			}
			else
			{
				CTDVString sTemp;
				sTemp << "<RICHPOST>" << sText << "</RICHPOST>";
				sText = sTemp;
			}
			//MakeSubjectSafe(&sSubject);
			EscapeAllXML(&sSubject);
			
			// Make the two dates suitable for XML
			CTDVString sDatePosted = "";
			dDatePosted.GetAsXML(sDatePosted);
			CTDVString sLastReply = "";
			dLastReply.GetAsXML(sLastReply);
			
			CTDVString sUserName = "";
			SP.GetField("UserName",sUserName);
			EscapeXMLText(&sUserName);

			sPosts << "<POST POSTID='" << iPostID << "'";

			sPosts << " THREADID='" << iThreadID << "'";
			
			sPosts << " HIDDEN='" << iHidden << "'";

			sPosts << ">\n";
			
			sPosts << "<SUBJECT>";

			sPosts << sSubject << "</SUBJECT>\n";

			sPosts << "<DATEPOSTED>" << sDatePosted << "</DATEPOSTED>\n";

			if (iCount > 0)
			{
				sPosts << "<LASTREPLY COUNT='" << iCount << "'>" << sLastReply << "</LASTREPLY>\n";
			}
			
			sPosts << "<USER>";
			sPosts << "<USERID>" << iUserID << "</USERID>";
			sPosts << "<USERNAME>" << sUserName << "</USERNAME>";

			CTDVString sUserArea;
			if (!SP.IsNULL("Area"))
			{
				SP.GetField("Area",sUserArea);
				EscapeXMLText(&sUserArea);
				sPosts << "<AREA>" << sUserArea << "</AREA>";
			}

			CTDVString sTitle;
			if (!SP.IsNULL("Title"))
			{
				SP.GetField("Title",sTitle);
				EscapeXMLText(&sTitle);
				sPosts << "<TITLE>" << sTitle << "</TITLE>";
			}

			InitialiseXMLBuilder(&sPosts, &SP);
			bool bOk = AddDBXMLTag("FirstNames",NULL,false);
			bOk = bOk && AddDBXMLTag("LastName",NULL,false);
			bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);
			bOk = bOk && AddDBXMLTag("Status","STATUS",false);
			bOk = bOk && AddDBXMLTag("TaxonomyNode","TAXONOMYNODE",false);
			bOk = bOk && AddDBXMLTag("Journal","JOURNAL",false);
			bOk = bOk && AddDBXMLTag("Active","ACTIVE",false);

			TDVASSERT(bOk,"Problems getting first, last name and site suffix for posts!");

			// Get user groups
			CTDVString sUserGroups;
			if(!m_InputContext.GetUserGroups(sUserGroups, iUserID))
			{
				TDVASSERT(false, "Failed to get user groups");
			}
			else
			{
				sPosts << sUserGroups;
			}

			sPosts << "</USER>\n";

			sPosts << "<TEXT>" << sText << "</TEXT>\n";

			sPosts << "</POST>";

			NumToShow--;
			SP.MoveNext();
		}

		sPosts << "</JOURNALPOSTS>";
		bSuccess = CreateFromXMLText(sPosts);
		// If we haven't yet reached EOF then set the 'more' flag
		if (bSuccess && !SP.IsEOF() && iTotalThreads > 0)
		{
			// Get the node and add a MORE attribute
			CXMLTree* pFNode = m_pTree->FindFirstTagName("JOURNALPOSTS", 0, false);
			TDVASSERT(pFNode != NULL, "Can't find JOURNALPOSTS node");
			
			if (pFNode != NULL)
			{
				pFNode->SetAttribute("MORE","1");
			}
		}
	}
	SP.Release();

	if ( bSuccess && !bShowUserHidden )
	{
		CTDVString StringToCache;
		GetAsString(StringToCache);
		CachePutItem("journal", cachename, StringToCache);
	}
	
	FilterOnPermissions(pViewer, iForumID, "JOURNALPOSTS","POST");
	UpdateRelativeDates();
	return bSuccess;		
}

/*********************************************************************************

	void CForum::GetUserStatistics(CTDVString &sText)

	Author:		Igor Loboda
	Created:	21/01/2002
	Inputs:		iUserID - ID of the user to get statistics on
				iNumToShow - number of entries to show on the page
				iNumSkipped - number of entries before the first one to show on the page
				iDisplayMode - 0 - postings will be grouped by forums and threads, 1 - postings 
				will not be grouped at all but will be ordered by Date Posted
	Outputs:	sText - string will be transformed
	Returns:	-
	Purpose:	Creates the XML representation of the user statistics:which posts where
				made to which forums under which threads.

*********************************************************************************/

bool CForum::GetUserStatistics(int iUserID, int iNumToShow, int iNumSkipped, 
							   int iDisplayMode, CTDVDateTime dtStartDate, CTDVDateTime dtEndDate)
{
	// Create a stored procedure object to use
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetUserStatistics");
		return 0;
	}

	//Removed caching calls

	CTDVString sPosts = "";
	int iRecordsCount=0;

	/*
			//try to get the User Statistics page from cache
			//construct cache file name
			CTDVString cachename = "US";
			cachename << iUserID << "-" << iDisplayMode << "-" << iNumSkipped 
				<< "-" << iNumSkipped + iNumToShow - 1 << ".txt";
			//get the date of last user posting to set the expiry date for the cache
			CTDVDateTime dLastDate;
			SP.CacheGetFreshestUserPostingDate(iUserID, &dLastDate);
			//check if the page is already in the cache
			if (CacheGetItem("UserStatistics", cachename, &dLastDate, &sPosts))
			{
				SP.Release();
				CreateFromXMLText(sPosts);
				UpdateRelativeDates();
				return true;
			}
	*/

	// call the stored procedure to fetch user statistics
	bool bSuccess = SP.FetchUserStatistics(iUserID, iDisplayMode, dtStartDate, dtEndDate, iRecordsCount);
	
	// If we got some, skip to the ones we want
	if (bSuccess && iNumSkipped > 0)
	{
		bSuccess = SP.MoveNext(iNumSkipped);
	}

	CTDVString sUserName = "";
	if (bSuccess)
	{
		SP.GetField("UserName", sUserName);
		MakeSubjectSafe(&sUserName);
	}

	sPosts = "<USERSTATISTICS";
	sPosts << " USERID='" << iUserID 
			<< "' USERNAME='" << sUserName 
			<< "' DISPLAYMODE='";
	if (iDisplayMode == 0)
	{
		sPosts << "byforum'";
	}
	else
	{
		sPosts << "ungrouped'";
	}
	sPosts << " SKIPTO='" << iNumSkipped 
			<< "' COUNT='" << iNumToShow 
			<< "' TOTAL='" << iRecordsCount 
			<< "'>";

	CTDVString sStartDate = "";
	CTDVString sEndDate = "";
	dtStartDate.GetAsXML(sStartDate);
	dtEndDate.GetAsXML(sEndDate);

	sPosts <<  "<STARTDATE>" << sStartDate << "</STARTDATE>\n"
	<< "<ENDDATE>" << sEndDate << "</ENDDATE>\n"; 
		
	int iPreviousForumID = 0;
	int iPreviousThreadID = 0;
	int iCount = 0;
	while (bSuccess && !SP.IsEOF() && iNumToShow > 0)
	{
		int iForumID = SP.GetIntField("ForumID");
		int iThreadID = SP.GetIntField("ThreadID");
		int iPostID = SP.GetIntField("EntryID");
		int iHidden = SP.GetIntField("Hidden");
		int iSiteID = SP.GetIntField("SiteID");

		CTDVString sTitle = "";
		SP.GetField("Title", sTitle);
		MakeSubjectSafe(&sTitle);

		CTDVString sSubject = "";
		SP.GetField("Subject", sSubject);
		EscapeAllXML(&sSubject);

		CTDVString sFirstSubject = "";
		SP.GetField("FirstSubject", sFirstSubject);
		EscapeAllXML(&sFirstSubject);

		CTDVDateTime dDatePosted = SP.GetDateField("DatePosted");
		CTDVString sDatePosted = "";
		dDatePosted.GetAsXML(sDatePosted);

		//close prefiously opened <THREAD> if any
		if (iThreadID != iPreviousThreadID && iPreviousThreadID != 0)
		{
			sPosts << "</THREAD>";
		}

		//close prefiously opened <FORUM> if any
		if (iForumID != iPreviousForumID && iPreviousForumID != 0)
		{
			sPosts << "</FORUM>";
		}
		
		//check if current forum id differs from the previous one. This will mean
		//that entries for the previous forum are over and we should close
		//the xml element for that forum and start new one for the current forum
		if (iForumID != iPreviousForumID)
		{
			sPosts << "<FORUM FORUMID='" << iForumID << "'>"
				<< "<SUBJECT>" << sTitle << "</SUBJECT>"
				<< "<SITEID>" << iSiteID << "</SITEID>"
				<< "<THREAD THREADID='" << iThreadID << "'>"
				<< "<SUBJECT>" << sFirstSubject << "</SUBJECT>";
			iPreviousForumID = iForumID;
			iPreviousThreadID = iThreadID;
		}
		else
		//check if current thread id differs from the previous one. This will mean
		//that entries for the previous thread are over and we should close
		//the xml element for that thread and start new one for the current thread
		if (iThreadID != iPreviousThreadID)
		{
			sPosts << "<THREAD THREADID='" << iThreadID << "' >"
				<< "<SUBJECT>" << sFirstSubject << "</SUBJECT>";

			iPreviousThreadID = iThreadID;
		}
		CTDVString sBody;
		SP.GetField("text", sBody);
		int iStyle = SP.GetIntField("PostStyle");
		if (iStyle != 1) 
		{
			MakeTextSafe(sBody);
		}
		else
		{
			CTDVString sTemp;
			sTemp << "<RICHPOST>" << sBody << "</RICHPOST>";
			sBody = sTemp;
		}
		sPosts << "<POST POSTID='" << iPostID << "'"
			<< " THREADID='" << iThreadID << "'"
			<< " HIDDEN='" << iHidden << "'>\n"
			<< "<SUBJECT>" << sSubject << "</SUBJECT>\n"
			<< "<BODY>" << sBody << "</BODY>\n"
			<< "<DATEPOSTED>" << sDatePosted << "</DATEPOSTED>\n"
			<< "</POST>";

		/* at the moment we display all records
		if (iHidden <= 0)
			iNumToShow--;
		*/

		iNumToShow--;
		SP.MoveNext();
	}

	//close previous thread xml if there is one
	if (iPreviousThreadID != 0)
	{
		sPosts << "</THREAD>";
	}

	//close previous forum xml if there is one
	if (iPreviousForumID != 0)
	{
		sPosts << "</FORUM>";
	}

	sPosts << "</USERSTATISTICS>";

	bSuccess = CreateFromXMLText(sPosts);

	// If we haven't yet reached EOF then set the 'more' flag
	if (bSuccess && !SP.IsEOF())
	{
		// Get the node and add a MORE attribute
		CXMLTree* pFNode = m_pTree->FindFirstTagName("USERSTATISTICS", 0, false);
		TDVASSERT(pFNode != NULL, "Can't find USERSTATISTICS node");
		
		if (pFNode != NULL)
		{
			pFNode->SetAttribute("MORE","1");
		}
	}
	SP.Release();

	//put the page into the cache
/*	if (bSuccess)
	{
		CTDVString StringToCache;
		GetAsString(StringToCache);
		CachePutItem("UserStatistics", cachename, StringToCache);
	}
*/
	UpdateRelativeDates();

	return bSuccess;		
}

/*********************************************************************************

	void CForum::MakeTextSafe(CTDVString &sText)

	Author:		Jim Lynn
	Created:	12/03/2000
	Inputs:		sText - text to be made safe
	Outputs:	sText - string will be transformed
	Returns:	-
	Purpose:	Converts the plain journal text into a form suitable for XML
				output.

*********************************************************************************/

void CForum::MakeTextSafe(CTDVString &sText)
{
//	CXMLObject::PlainTextToGuideML(&sText);
	CXMLObject::DoPlainTextTranslations(&sText);
}

/*********************************************************************************

	void CForum::MakeSubjectSafe(CTDVString &sText)

	Author:		Jim Lynn
	Created:	12/03/2000
	Inputs:		sText - text to be made safe
	Outputs:	sText - string will be transformed
	Returns:	-
	Purpose:	Converts the plain journal text into a form suitable for XML
				output.

*********************************************************************************/

/*
void CForum::MakeSubjectSafe(CTDVString &sText)
{
	//EscapeXMLText(&sText);
	EscapeAllXML(&sText);
}
*/

/*********************************************************************************

	bool CForum::GetPostContents(int iReplyTo, int *iForumID, int *iThreadID, CTDVString *sUserName, CTDVString *sBody)

	Author:		Jim Lynn
	Created:	19/03/2000
	Inputs:		iReplyTo - ID of the thread to be replied to
	Outputs:	iForumID - ID of the forum
				iThreadID - Thread ID
				sUserName - Username of poster
				sBody - Body of post
	Returns:	true for success, false otherwise
	Purpose:	Used to get the details of a forum post the user is replying to

*********************************************************************************/

bool CForum::GetPostContents(CUser* pViewer, int iReplyTo, int *pForumID, int *pThreadID, CTDVString *pUserName, CTDVString *pBody, CTDVString* pSubject, int* oPostStyle, int* oPostIndex, int* oUserID, CTDVString *pSiteSuffix)
{
	// Setup some local variables
	int iUserID = 0;
	bool bIsEditor = false;
	if (pViewer != NULL)
	{
		iUserID = pViewer->GetUserID();
		if (pViewer->GetIsEditor() || pViewer->GetIsSuperuser())
		{
			bIsEditor = true;
		}
	}
	bool bCanRead = true;
	bool bCanWrite = true;

	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Now call the procedure
	if (!SP.GetPostContents(iReplyTo, iUserID, pForumID, pThreadID, pUserName, pSiteSuffix, pBody, pSubject, &bCanRead, &bCanWrite, oPostStyle, oPostIndex, oUserID))
	{
		TDVASSERT(false, "StoredProcedure Failed in CForum::GetPostContents");
		return false;
	}

	m_ForumID = *pForumID;

	if (!bIsEditor && !bCanRead)
	{
		*pSubject = "Hidden";
		*pBody = "Hidden";
		*pUserName = "Hidden";
		*pSiteSuffix = "Hidden";
		*oUserID = 0;
	}

	return true;
}

/*********************************************************************************

	bool CForum::PostToForum(CUser* pPoster, int iForumID, int iReplyTo, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody, int* oThreadID, int* oPostID, bool* pbProfanityFound
	int iClub, int iNodeID , const TDVCHAR* pPhrases , bool bAllowQueuing, bool* pbWasQueued , bool bIgnoreModeration, int* pSecondsToWait, bool* pbNonAllowedURLsFound)

	Author:		Jim Lynn
	Created:	15/06/2000
	Inputs:		pPoster - user posting
				iForumID - ID of forum we're posting to
				iReplyTo - ID of post we're replying to (or 0)
				iThreadID - ID of thread we're replying to (or 0 for new conv)
				pSubject - ptr to subject line
				pBody - ptr to body of post
				iPostStyle - 2 = plain text, 1 = GuideML
				sType - Used by the notice board. This is the type of notice being posted.
				sEventDate - Used by the notice board code to determines when a event happens in the future.
	Outputs:	oThreadID - ID of the thread posted to
				oPostID - ID of the post created
				pbProfanityFound - A flag that gets set true if the post was forced into moderation.
				pbNonAllowedURLsFound- A flag that gets set to true if the post contains a non allowed url
				pbEmailAddressFound - Indicates email address found.
				pbPreModPostingModId - A value > 0 indicates that post was not actually created due to site option processPreMod.
				pbIsPreModerated - Indicates that post was premoderated .
	Returns:	true if successful, false otherwise
	Purpose:	Posts a thread entry to a conversation, either to create a new
				conversation (in which case ThreadID and ReplyTo are 0) or
				in reply to a particular post.

*********************************************************************************/

bool CForum::PostToForum(CUser* pPoster, int iForumID, int iReplyTo, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody, int iPostStyle, int* oThreadID, int* oPostID, 
						 const TDVCHAR *pType, const TDVCHAR *pEventDate, bool* pbProfanityFound, int iClub, int iNodeID /* = 0*/, const TDVCHAR* pPhrases /* = NULL */, 
						 bool bAllowQueuing /* = false */, bool* pbWasQueued /* = NULL */, bool bIgnoreModeration /* = false */, int* pSecondsToWait /* = NULL */, bool* pbNonAllowedURLsFound /* = NULL */,
						 int* pbPreModPostingModId, bool* pbIsPreModerated, bool* pbEmailAddressFound )
{
	if (pbWasQueued != NULL)
	{
		*pbWasQueued = false;
	}
	if (iPostStyle == 1)
	{
		CTDVString sPost = "<BODY>\n";
		sPost <<pBody << "\n</BODY>";

		CTDVString ParseErrors = ParseXMLForErrors(sPost);
		if (ParseErrors.GetLength() > 0) 
		{
			CreateFromXMLText(ParseErrors);
			return false;
		}
	}
	
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "StoredProcedure Failed in CForum::GetPostContents");
		return false;
	}

	int iUserID = 0;
	if (pPoster != NULL)
	{
		iUserID = pPoster->GetUserID();
		bIgnoreModeration = bIgnoreModeration || pPoster->GetIsEditor() || pPoster->GetIsSuperuser();
	}

	bool bCanRead = true;
	bool bCanWrite = true;
	if (iThreadID > 0)
	{
		SP.GetThreadPermissions(iUserID, iThreadID, bCanRead, bCanWrite);
	}
	else
	{
		SP.GetForumPermissions(iUserID, iForumID, bCanRead, bCanWrite);
	}

	// If we're not ignoring moderation, check to see if the site is closed!
	// If so, then set the can write flag to false.
	if (!bIgnoreModeration && bCanWrite)
	{
		bool bSiteClosed = false;
		if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
		{
			TDVASSERT(false, "Failed to get  site closed status!!!");
			return false;
		}
		bCanWrite = !bSiteClosed;
	}

    // Check the user input for profanities!
	CProfanityFilter ProfanityFilter(m_InputContext);
	CTDVString sCheck = pSubject;
	sCheck << " " << pBody;

	bool bForceModerate = false;		// Forces Moderation Pre/Post  Site Specific .
	bool bForcePreModeration = false;	// Forces PreModeration.
	if ( pbProfanityFound != NULL )
		*pbProfanityFound = false;


    CTDVString sModNotes;
	CProfanityFilter::FilterState filterState = ProfanityFilter.CheckForProfanities(sCheck, &sModNotes);

	if (filterState == CProfanityFilter::FailBlock)
	{
		//represent the submission first time only
		//need to keep track of this
		if ( pbProfanityFound != NULL )
			*pbProfanityFound = true;
		//return immediately - these don't get submitted
		return false;
	}
	else if (filterState == CProfanityFilter::FailRefer)
	{
		bForceModerate = true;
        sModNotes = "Filtered Term Found : " + sModNotes;
		if ( pbProfanityFound != NULL )
			*pbProfanityFound = true;
	}

	if(m_InputContext.IsCurrentSiteURLFiltered() && !(pPoster->GetIsEditor() || pPoster->GetIsNotable()))
	{
		CURLFilter oURLFilter(m_InputContext);
		CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sCheck);
		if (URLFilterState == CURLFilter::Fail)
		{
			if ( pbNonAllowedURLsFound != NULL )
			{
				*pbNonAllowedURLsFound = true;
			}
			//return immediately - these don't get submitted
			return false;
		}
	}

	//Filter for email addresses.
	CEmailAddressFilter emailfilter;
	if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(pPoster->GetIsEditor() || pPoster->GetIsNotable()) && emailfilter.CheckForEmailAddresses(sCheck) )
	{
		//SetDNALastError("CForum::PostToForum","EmailAddressFilter","Email Address Found.");
		if ( pbEmailAddressFound )
		{
			*pbEmailAddressFound = true;
		}
		return false;
	}

	if (!pPoster->GetIsEditor() && !pPoster->GetIsNotable())
	{
		int iSeconds = 0;
		if (SP.CheckUserPostFreq(iUserID,m_InputContext.GetSiteID(),iSeconds))
		{
			if (iSeconds > 0)
			{
				if (pSecondsToWait != NULL)
				{
					*pSecondsToWait = iSeconds;
				}
				//reset profanity message if set
				*pbProfanityFound = false;
				return false;
			}
		}
	}

	bool bIsNotable=false;
	if(pPoster->GetIsNotable())
	{
		bIsNotable = true;
	}	

	// PreModerate first post in discussion if site premoderatenewdiscussions option set.
	if (iReplyTo == 0 && m_InputContext.GetCurrentSiteOptionInt("Moderation", "PreModerateNewDiscussions") )
	{
		if ( !bIgnoreModeration && !bIsNotable )
		{
			bForcePreModeration = true;
		}
	}

	// Now post to the forum
	if ((bIgnoreModeration || bCanWrite) && SP.PostToForum(iUserID, iForumID, iReplyTo, iThreadID, pSubject, pBody, iPostStyle, oThreadID, oPostID, pType, pEventDate, bForceModerate, bForcePreModeration, bIgnoreModeration, iClub, iNodeID, m_InputContext.GetIPAddress(), pPhrases, bAllowQueuing, pbWasQueued, pbPreModPostingModId, pbIsPreModerated, m_InputContext.GetBBCUIDFromCookie(), bIsNotable, sModNotes) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CForum::PostToJournal(int iUserID, int iJournalID, const TDVCHAR *pUsername, const TDVCHAR *pSubject, const TDVCHAR *pBody, int iSiteID, int iPostStyle, bool* pbProfanityFound, bool* pbNonAllowedURLsFound)

	Author:		Jim Lynn
	Created:	15/06/2000
	Inputs:		iUserID - ID of user posting
				iJournalID - Forum ID of the user's journal
				pUserName - username (not used, I think)
				pSubject - Subject line of posting
				pBody - body of journal posting
				iSiteID
				iPostStyle
				pbProfanityFound - if profanites are found
				pbNonAllowedURLsFound - if non allowed urls are found
				pbEmailAddressFound - Indicates an email address was found.
	Outputs:	-
	Returns:	true if succeeded, false otherwise
	Purpose:	posts a new entry to the user's journal

*********************************************************************************/

bool CForum::PostToJournal(int iUserID, int iJournalID, const TDVCHAR *pUsername, const TDVCHAR *pSubject, const TDVCHAR *pBody, int iSiteID, int iPostStyle, bool* pbProfanityFound, bool* pbNonAllowedURLsFound, bool* pbEmailAddressFound )
{
	// Check the user input for profanities!
	CProfanityFilter ProfanityFilter(m_InputContext);
	CTDVString sCheck = pSubject;
	sCheck << " " << pBody;

	bool bForceModerate = *pbProfanityFound = false;
	*pbNonAllowedURLsFound = false;

	CProfanityFilter::FilterState filterState = ProfanityFilter.CheckForProfanities(sCheck);

	if (filterState == CProfanityFilter::FailBlock)
	{
		//represent the submission first time only
		//need to keep track of this
		*pbProfanityFound = true;
		//return immediately - these don't get submitted
		return false;
	}
	else if (filterState == CProfanityFilter::FailRefer)
	{
		bForceModerate = true;
		*pbProfanityFound = true;
	}

	if(m_InputContext.IsCurrentSiteURLFiltered() && !(m_InputContext.GetCurrentUser()->GetIsEditor() || m_InputContext.GetCurrentUser()->GetIsNotable()))
	{
		CURLFilter oURLFilter(m_InputContext);
		CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sCheck);
		if (URLFilterState == CURLFilter::Fail)
		{
			*pbNonAllowedURLsFound = true;
			//return immediately - these don't get submitted
			return false;
		}
	}

	//Filter for email addresses.
	if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(m_InputContext.GetCurrentUser()->GetIsEditor() || m_InputContext.GetCurrentUser()->GetIsNotable()))
	{
		CEmailAddressFilter emailfilter;
		if ( emailfilter.CheckForEmailAddresses(sCheck) )
		{
			//SetDNALastError("CForum::PostToJournal","EmailAddressFilter","Email Address Found.");
			*pbEmailAddressFound = true;
			return false;
		}
	}

	//SuperUsers / Editors are not moderated.
	bool bIgnoreModeration = false;
	if ( m_InputContext.GetCurrentUser() && (m_InputContext.GetCurrentUser()->GetIsSuperuser() || m_InputContext.GetCurrentUser()->GetIsEditor()) )
		bIgnoreModeration = true;

	// Setup the stored procedure object
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Now call the procedure
	if (!SP.PostToJournal(iUserID, iJournalID, pUsername, pSubject, pBody, iSiteID, iPostStyle, bForceModerate, bIgnoreModeration, m_InputContext.GetIPAddress(),m_InputContext.GetBBCUIDFromCookie()))
	{
		TDVASSERT(false, "StoredProcedure Failed in CForum::PostToJournal");
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CForum::GetForumIDFromString(CTDVString& sForumID,int* iForumID)

	Author:		Dharmesh Raithatha
	Created:	2/14/02
	Inputs:		sForumID - either F***** or f****** or ******
	Outputs:	iForumID - value to fill
	Returns:	true if a value was extracted and is > 0, false otherwise
	Purpose:	Given a forumid string of the form F12345 or 12345, it returns the 
				value of the forum
*********************************************************************************/

bool CForum::GetForumIDFromString(const CTDVString& sForumID,int* iForumID)
{
	if (sForumID.IsEmpty())
	{
		return false;
	}

	CTDVString sID = sForumID;

	if (sID.GetAt(0) == 'F' || sID.GetAt(0) == 'f')
	{ 
		sID.RemoveLeftChars(1);
	}

	*iForumID = atoi(sID);

	return (*iForumID > 0);
}

/*********************************************************************************

	bool CForum::GetPostIDFromString(const CTDVString& sPostID,int* iPostID)

	Author:		Dharmesh Raithatha
	Created:	2/21/02
	Inputs:		sPostId - either P***** or p****** or ******
	Outputs:	iPostID - postid returned
	Returns:	true of the value was extracted
	Purpose:	Given the post id in the form P***** or ***** returns the value
				of the postid

*********************************************************************************/

bool CForum::GetPostIDFromString(const CTDVString& sPostID,int* iPostID)
{
	if (sPostID.IsEmpty())
	{
		return false;
	}

	CTDVString sID = sPostID;

	if (sID.GetAt(0) == 'P' || sID.GetAt(0) == 'p')
	{ 
		sID.RemoveLeftChars(1);
	}

	*iPostID = atoi(sID);

	return (*iPostID > 0);

}

bool CForum::GetThreadSubscriptionState(int iUserID, int iThreadID, int iForumID, bool* oForumSubscribed, bool* oThreadSubscribed, int* piLastPostCountRead, int* piLastUserPostID)
{
	m_ForumID = iForumID;
	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Now call the procedure
	bool bThreadSubscribed = false;
	bool bForumSubscribed = false;
	int iLastPostCountRead = 0;
	int iLastUserPostID = 0;
	if (!SP.IsUserSubscribed(iUserID, iThreadID, iForumID, &bThreadSubscribed, &bForumSubscribed, &iLastPostCountRead, &iLastUserPostID))
	{
		TDVASSERT(false, "StoredProcedure Failed in  CForum::GetThreadList");
		return false;
	}

	CTDVString sXML = "<SUBSCRIBE-STATE";

	sXML << " USERID='" << iUserID << "'";
	sXML << " FORUMID='" << iForumID << "'";
	sXML << " THREADID='" << iThreadID << "'";
	
	if (bThreadSubscribed)
	{
		sXML << " THREAD='1'";
		sXML << " LASTPOSTCOUNTREAD='" << iLastPostCountRead << "'";
		if (iLastUserPostID > 0)
		{
			sXML << " LASTUSERPOSTID='" << iLastUserPostID << "'";
		}
	}
	else
	{
		sXML << " THREAD='0'";
	}

	if (bForumSubscribed)
	{
		sXML << " FORUM='1'";
	}
	else
	{
		sXML << " FORUM='0'";
	}

	sXML << "/>";

	if (oForumSubscribed != NULL) 
	{
		*oForumSubscribed = bForumSubscribed;
	}
	if (oThreadSubscribed != NULL) 
	{
		*oThreadSubscribed = bThreadSubscribed;
	}
	if (piLastPostCountRead != NULL)
	{
		*piLastPostCountRead = iLastPostCountRead;
	}
	if (piLastUserPostID != NULL)
	{
		*piLastUserPostID = iLastUserPostID;
	}

	return CreateFromXMLText(sXML);
}

bool CForum::MarkThreadRead(int iUserID, int iThreadID, int iPostID, bool bForce)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.MarkForumThreadRead(iUserID, iThreadID, iPostID, bForce);
	return true;
}


/*********************************************************************************

	bool CForum::SetSubscriptionState(int iUserID, int iThreadID, int iForumID, bool bState)

	Author:		Jim Lynn
	Created:	21/07/2000
	Inputs:		iUserID
				iThreadID - zero if the whole forum is the target
				iForumID - never zero
				bState - true = Subscribe, false = unsubscribe
	Outputs:	-
	Returns:	-
	Purpose:	This function will set the subscription state for a given user to
				either a single thread, or an entire forum. When subscribing to
				a whole forum, you are actually asking for notification about
				new posts, not existing threads. This should be made clear by the
				UI.

*********************************************************************************/

bool CForum::SetSubscriptionState(int iUserID, int iThreadID, int iForumID, bool bState, bool bIsJournal)
{
	CTDVString sXML = "";
	CStoredProcedure SP;
	bool bInitialisedSP = m_InputContext.InitialiseStoredProcedureObject(&SP);

	TDVASSERT(bInitialisedSP, "Failed to create SP in CForum::GetThreadList");
	if (!bInitialisedSP)
	{
		return false;
	}

	if (bIsJournal)
	{
		// Asking to unsubscribe to a journal thread
		SP.UnsubscribeFromJournalThread(iUserID, iThreadID, iForumID);
		sXML << "<SUBSCRIBE-RESULT FROMTHREAD='" << iThreadID << "'";
		int iResult = SP.GetIntField("Result");
		if (iResult > 0)
		{
			CTDVString reason;
			SP.GetField("Reason",reason);
			sXML << " JOURNAL='1' FAILED='" << iResult << "'>" << reason << "</SUBSCRIBE-RESULT>";
		}
		else
		{
			sXML << " JOURNAL='1'/>";
		}

	}
	else if (iThreadID == 0)
	{
		bool bCanRead = false;
		bool bCanWrite = false;
		SP.GetForumPermissions(iUserID, iForumID, bCanRead, bCanWrite);
		if (bCanRead) 
		{
			// (Un)Subscribing to the whole forum
			if (bState)
			{
				// subscribe to whole forum
				SP.SubscribeToForum(iUserID, iForumID);
				sXML << "<SUBSCRIBE-RESULT TOFORUM='" << iForumID << "'/>";
			}
			else
			{
				// unsubscribe to whole forum
				SP.UnsubscribeFromForum(iUserID, iForumID);
				sXML << "<SUBSCRIBE-RESULT FROMFORUM='" << iForumID << "'/>";
			}
		}
		else
		{
			sXML << "<SUBSCRIBE-RESULT";
			if (bState) 
			{
				sXML << " TOFORUM='" << iForumID << "'";
			}
			else
			{
				sXML << " FROMFORUM='" << iForumID << "'";
			}
			sXML << " FAILED='3'>You don't have permission to read this forum</SUBSCRIBE-RESULT>";
		}
	}
	else
	{
		bool bCanRead = false;
		bool bCanWrite = false;
		SP.GetThreadPermissions(iUserID, iThreadID, bCanRead, bCanWrite);
		if (bCanRead) 
		{
			// (Un)Subscribing to a single thread
			if (bState)
			{
				// subscribe
				SP.SubscribeToThread(iUserID, iThreadID, iForumID);
				sXML << "<SUBSCRIBE-RESULT TOTHREAD='" << iThreadID << "'/>";
			}
			else
			{
				// unsubscribe
				SP.UnsubscribeFromThread(iUserID, iThreadID, iForumID);
				sXML << "<SUBSCRIBE-RESULT  FROMTHREAD='" << iThreadID << "'";
				int iResult = SP.GetIntField("Result");
				if (iResult > 0)
				{
					CTDVString reason;
					SP.GetField("Reason",reason);
					sXML << " FAILED='" << iResult << "'>" << reason << "</SUBSCRIBE-RESULT>";
				}
				else
				{
					sXML << "/>";
				}
			}
		}
		else
		{
			sXML << "<SUBSCRIBE-RESULT";
			if (bState) 
			{
				sXML << " TOTHREAD='" << iThreadID << "'";
			}
			else
			{
				sXML << " FROMTHREAD='" << iThreadID << "'";
			}
			sXML << " FAILED='5'>You don't have permission to read this thread</SUBSCRIBE-RESULT>";
		}
	}

	return CreateFromXMLText(sXML);
}

int CForum::GetSiteID()
{
	return m_SiteID;
}

void CForum::SetSiteIDFromTree(const TDVCHAR *pTagName)
{
	CXMLTree* pNode = m_pTree->FindFirstTagName(pTagName);
	if (pNode != NULL)
	{
		m_SiteID = pNode->GetIntAttribute("SITEID");
	}
	
}

void CForum::SetForumIDFromTree(const TDVCHAR *pTagName)
{
	CXMLTree* pNode = m_pTree->FindFirstTagName(pTagName);
	if (pNode != NULL)
	{
		m_ForumID = pNode->GetIntAttribute("FORUMID");
	}
	
}
/*********************************************************************************

	bool CForum::GetForumSiteID(int iForumID, int& iSiteID)

	Author:		Igor Loboda
	Created:	10/042002
	Inputs:		iForumID - forum ID
	Outputs:	iSiteID - site id of the site specified forum resides
	Returns:	true on success
	Purpose:	fetches site id for the given forum

*********************************************************************************/
bool CForum::GetForumSiteID(int iForumID, int iThreadID, int& iSiteID)
{
	m_ForumID = iForumID;
	CStoredProcedure sp;
	if (!m_InputContext.InitialiseStoredProcedureObject(&sp))
	{
		return false;
	}
	
	// Note that this will change the value of m_ForumID if the thread passed in doesn't live in the
	// specified forum. 
	return sp.GetForumSiteID(m_ForumID, iThreadID,iSiteID);
}

/*********************************************************************************

	bool CForum::MoveToSite(CInputContext& inputContext, int iForumID, int iNewSiteID)

	Author:		Igor Loboda
	Created:	11/042002
	Inputs:		iForumID - forum ID
				iNewSiteID - id of the site where to move forum
				inputContext - input context to create storedprocedure object
	Outputs:	-
	Returns:	true on success: forum was moved or there was nothing to move
	Purpose:	moves forum to specified site

*********************************************************************************/
bool CForum::MoveToSite(CInputContext& inputContext, int iForumID, int iNewSiteID)
{
	CStoredProcedure sp;
	if (!inputContext.InitialiseStoredProcedureObject(&sp))
	{
		return false;
	}
	
	return sp.MoveForumToSite(iForumID, iNewSiteID);
}

/*********************************************************************************

	bool CForum::FilterOnPermissions(CUser* pViewer, int ForumID, const TDVCHAR* pTagName)

	Author:		Jim Lynn
	Created:	25/04/2003
	Inputs:		pViewer - user to filter on (of NULL if none)
				ForumID - ID of forum we're looking at
				pTagName - name of tag to check for attributes
	Outputs:	-
	Returns:	true if succeeded
	Purpose:	Checks that the user has read permission on this thread and
				filters out the list if not. Also sets the correct CANREAD and
				CANWRITE attributes on the list.

*********************************************************************************/

bool CForum::FilterOnPermissions(CUser* pViewer, int ForumID, const TDVCHAR* pTagName, const TDVCHAR* pItemName)
{
	bool bCanRead = true;
	bool bCanWrite = true;
	bool bDefaultCanRead = true;
	bool bDefaultCanWrite = true;

	// Check the default attributes if there
	CXMLTree* pNode = m_pTree->FindFirstTagName(pTagName);
	if (pNode == NULL)
	{
		return false;
	}
	if (pNode->DoesAttributeExist("CANREAD"))
	{
		bCanRead = (pNode->GetIntAttribute("CANREAD") == 1);
		bDefaultCanRead = bCanRead;
	}
	if (pNode->DoesAttributeExist("CANWRITE"))
	{
		bCanWrite = (pNode->GetIntAttribute("CANWRITE") == 1);
		bDefaultCanWrite = bCanWrite;
	}

	bool bEditor = false;

	// That gets the database defaults - now query on user specific ones, if necessary
	if (pViewer != NULL && pViewer->GetUserID() != 0)
	{
		// Editors can read/write anything/anywhere
		if (pViewer->GetIsEditor() || pViewer->GetIsSuperuser())
		{
			bCanRead = true;
			bCanWrite = true;
			bEditor = true;
		}
		else
		{
			CStoredProcedure SP;
			if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
			{

				return false;
			}
			SP.GetForumPermissions(pViewer->GetUserID(), ForumID, bCanRead, bCanWrite);
		}
	}

	// Check to see if the site is closed. If it is and we're not an editor, set the canwrite flag to false!
	bool bSiteClosed = false;
	if (!bEditor && bCanWrite)
	{
		bool bSiteClosed = false;
		if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
		{
			TDVASSERT(false, "StoredProcedure Failed in CForum::GetPostContents");
			return false;
		}
		bCanWrite = !bSiteClosed;
	}

	// Now set these attributes
	if (bCanRead)
	{
		pNode->SetAttribute("CANREAD","1");
	}
	else
	{
		pNode->SetAttribute("CANREAD","0");
	}

	if (bCanWrite)
	{
		pNode->SetAttribute("CANWRITE","1");
	}
	else
	{
		pNode->SetAttribute("CANWRITE","0");
	}

	if (bDefaultCanRead)
	{
		pNode->SetAttribute("DEFAULTCANREAD","1");
	}
	else
	{
		pNode->SetAttribute("DEFAULTCANREAD","0");
	}

	if (bDefaultCanWrite)
	{
		pNode->SetAttribute("DEFAULTCANWRITE","1");
	}
	else
	{
		pNode->SetAttribute("DEFAULTCANWRITE","0");
	}
	// And remove contents if CanRead is false
	if (!bCanRead)
	{
		CXMLTree* pChild = pNode->FindFirstTagName(pItemName, pNode, false);
		while (pChild != NULL)
		{
			CXMLTree* pNext = pChild->FindNextTagNode(pItemName, pNode);
			pChild = pChild->DetachNodeTree();
			delete pChild;
			pChild = pNext;
		}
	}

	// If the site is closed then override thread's canwrite attribute to 0. 
	if (bSiteClosed)
	{
		CXMLTree* pChild = pNode->FindFirstTagName(pItemName, pNode, false);
		while (pChild != NULL)
		{
			CXMLTree* pNext = pChild->FindNextTagNode(pItemName, pNode);
			pChild->SetAttribute("CANWRITE", 0); 
			pChild = pNext;
		}
	}
	return true;
}

/*********************************************************************************

	bool CForum::FilterThreadPermissions(CUser* pViewer, int, ForumID int ThreadID, const TDVCHAR* pTagName)

	Author:		Jim Lynn
	Created:	25/04/2003
	Inputs:		pViewer - user to filter on (of NULL if none)
				ForumID - ID of Forum we're looking at
				ThreadID - ID of thread we're looking at
				pTagName - name of tag to check for attributes
	Outputs:	-
	Returns:	true if succeeded
	Purpose:	Checks that the user has read permission on this thread and
				filters out the list if not. Also sets the correct CANREAD and
				CANWRITE attributes on the list.

*********************************************************************************/

bool CForum::FilterThreadPermissions(CUser* pViewer, int ForumID, int Thread, const TDVCHAR* pTagName)
{
	bool bCanRead = true;
	bool bCanWrite = true;
	bool bDefaultCanRead = true;
	bool bDefaultCanWrite = true;

	// Check the default attributes if there
	CXMLTree* pNode = m_pTree->FindFirstTagName(pTagName, 0, false);
	if (pNode == NULL)
	{
		return false;
	}
	if (pNode->DoesAttributeExist("CANREAD"))
	{
		bCanRead = (pNode->GetIntAttribute("CANREAD") == 1);
		bDefaultCanRead = bCanRead;
	}
	if (pNode->DoesAttributeExist("CANWRITE"))
	{
		bCanWrite = (pNode->GetIntAttribute("CANWRITE") == 1);
		bDefaultCanWrite = bCanWrite;
	}

	bool bEditor = false;

	// That gets the database defaults - now query on user specific ones, if necessary
	if (pViewer != NULL && pViewer->GetUserID() != 0)
	{
		// Editors can read/write anything/anywhere
		if (pViewer->GetIsEditor() || pViewer->GetIsSuperuser())
		{
			bCanRead = true;
			bCanWrite = true;
			bEditor = true;
		}
		else
		{
			CStoredProcedure SP;
			if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
			{
				return false;
			}
			SP.GetThreadPermissions(pViewer->GetUserID(), Thread, bCanRead, bCanWrite);
		}
	}

	// Check to see if the site is closed. If it is and we're not an editor, set the canwrite flag to false!
	if (!bEditor && bCanWrite)
	{
		bool bSiteClosed = false;
		if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
		{
			TDVASSERT(false, "StoredProcedure Failed in CForum::GetPostContents");
			return false;
		}
		bCanWrite = !bSiteClosed;
	}

	// Now set these attributes
	if (bCanRead)
	{
		pNode->SetAttribute("CANREAD","1");
	}
	else
	{
		pNode->SetAttribute("CANREAD","0");
	}

	if (bCanWrite)
	{
		pNode->SetAttribute("CANWRITE","1");
	}
	else
	{
		pNode->SetAttribute("CANWRITE","0");
	}

	if (bDefaultCanRead)
	{
		pNode->SetAttribute("DEFAULTCANREAD","1");
	}
	else
	{
		pNode->SetAttribute("DEFAULTCANREAD","0");
	}

	if (bDefaultCanWrite)
	{
		pNode->SetAttribute("DEFAULTCANWRITE","1");
	}
	else
	{
		pNode->SetAttribute("DEFAULTCANWRITE","0");
	}

	// And remove contents if CanRead is false
	if (!bCanRead)
	{
		CXMLTree* pChild = pNode->FindFirstTagName("POST", pNode, false);
		while (pChild != NULL)
		{
			CXMLTree* pNext = pChild->FindNextTagNode("POST", pNode);
			pChild = pChild->DetachNodeTree();
			delete pChild;
			pChild = pNext;
		}
	}
	return true;
}

/*********************************************************************************

	bool CForum::FilterIndividualThreadPermissions(CUser* pViewer, const TDVCHAR* pTagName, const TDVCHAR* pItemName)

		Author:		Mark Howitt
        Created:	16/03/2004
		Inputs:		pViewer - user to filter on
					pTagName - name of tag to check for attributes
					pItemName - Name of the attribute you want to check for
		Returns:	true if succeeded
		Purpose:	Checks each individual thread to see it it's canread flag is set.
					If set to 0 then 

*********************************************************************************/

bool CForum::FilterIndividualThreadPermissions(CUser* pViewer, const TDVCHAR* pTagName, const TDVCHAR* pItemName)
{
	// Editors can read/write anything/anywhere
	if (pViewer != NULL && (pViewer->GetIsEditor() || pViewer->GetIsSuperuser()))
	{
		// Just return ok!
		return true;
	}

	// Get the first node
	CXMLTree* pNode = m_pTree->FindFirstTagName(pTagName);
	if (pNode == NULL)
	{
		return false;
	}

	// Now check each thread to see if it's canread / canwrtie flags are set to 0
	CXMLTree* pChild = pNode->FindFirstTagName(pItemName, pNode, false);
	while (pChild != NULL)
	{
		// If we find a thread with canread = 0 then remove it
		if (pChild->GetNodeType() == CXMLTree::T_NODE && pChild->GetIntAttribute("CANREAD") == 0)
		{
			CXMLTree* pNext = pChild->FindNextTagNode(pItemName, pNode);
			pChild = pChild->DetachNodeTree();
			delete pChild;
			pChild = pNext;
		}
		else
		{
			// Just find the next node
			pChild = pChild->FindNextTagNode(pItemName, pNode);
		}
	}

	return true;
}

/*********************************************************************************

	bool CForum::GetPostingPermission(CUser *pPoster, int iForumID, int iThreadID, bool &bCanRead, bool &bCanWrite)

	Author:		Jim Lynn
	Created:	05/06/2003
	Inputs:		pPoster - user who is posting (or NULL for unregistered)
				iForumID - ID of forum
				iThreadID - ID of thread (or 0 to get posting permission to the forum)
	Outputs:	bCanRead - true if the user can read the forum/thread
				bCanWrite - true if the user can post to the forum/thread
	Returns:	true if succeeded
	Purpose:	Checks permissions on the forum or thread and returns whether the user is allowed to post

*********************************************************************************/

bool CForum::GetPostingPermission(CUser *pPoster, int iForumID, int iThreadID, bool &bCanRead, bool &bCanWrite)
{
	m_ForumID = iForumID;
	bCanRead = true;
	bCanWrite = true;
	bool bIsEditor = false;
	int iUserID = 0;
	if (pPoster != NULL)
	{
		iUserID = pPoster->GetUserID();
		bIsEditor = pPoster->GetIsEditor() || pPoster->GetIsSuperuser();
	}

	if (!bIsEditor)
	{
		CStoredProcedure SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			return false;
		}
		if (iThreadID == 0)
		{
			SP.GetForumPermissions(iUserID, iForumID, bCanRead, bCanWrite);
		}
		else
		{
			SP.GetThreadPermissions(iUserID, iThreadID, bCanRead, bCanWrite);
		}
	}
	return true;
}

/*********************************************************************************

	bool CForum::GetPostsInForum(CUser *pViewer, int iForumID, int iNumPosts, int iNumSkipped, int iAscendingOrder)

	Author:		Jim Lynn
	Created:	05/06/2003
	Inputs:		pViewer - viewing user (or NULL if unregistered)
				iForumID - ID of forum
				iNumPosts - number of posts to display
				iNumSkipped - number of posts to skip before displaying
				iAscendingOrder - dateposted ordering of the results
	Outputs:	-
	Returns:	true if succeeded
	Purpose:	Gets the posts in a forum in a guestbook form, newest first, ignoring threads

*********************************************************************************/

bool CForum::GetPostsInForum(CUser *pViewer, int iForumID, int iNumPosts, int iNumSkipped, int iAscendingOrder)
{
	m_ForumID = iForumID;
	// Make sure this object is empty
	TDVASSERT(IsEmpty(),"Can't call GetPostsInForum if the object isn't empty");
	if (!IsEmpty())
	{
		return false;
	}

	if (iNumPosts > 200) 
	{
		iNumPosts = 200;
	}

	CTDVString sPosts = "";
	
	// Create a stored procedure object to use
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetPostsInForum");
		return false;
	}

	CTDVString cachename = "F";
	cachename << iForumID << "-" << iNumSkipped << "-" << iNumSkipped + iNumPosts - 1 << "-" << iAscendingOrder << ".txt";

	CTDVDateTime dLastDate;
	SP.CacheGetMostRecentThreadDate(iForumID, &dLastDate);
	SP.Release();

	bool bGotCache = false;
	bGotCache = CacheGetItem("forumpostsguestbook", cachename, &dLastDate, &sPosts);
	
	if (bGotCache)
	{
		CreateFromXMLText(sPosts);
		SetSiteIDFromTree("FORUMTHREADPOSTS");  //TODO: Change to match the tree we're creating
		FilterOnPermissions(pViewer, iForumID, "FORUMTHREADPOSTS","POST");
		FilterIndividualThreadPermissions(pViewer,"FORUMTHREADPOSTS","POST");
		UpdateRelativeDates();
		return true;
	}
	
	// Initialise DB object again
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP object in CForum::GetPostsInForum");
		return false;
	}

	//Just get the posts we want not all of them
	//SP.GetForumPostsAsGuestbook(iForumID, iAscendingOrder);
	int iFirstIndex = 0;
	if (iNumSkipped > 0)
	{
		iFirstIndex = iNumSkipped - 1; // get the post before and after the ones we actually want for the more and previous node
	}

	SP.GetForumPostsAsGuestbookSkipAndShow(iForumID, iAscendingOrder, iFirstIndex, iNumPosts + 1);
	// Skip over all the posts we don't care about *except* the one
	// before the first one we display - this is so we can get the ID
	// of the previous post so we can skip back properly
	
	int iLastPostOnPreviousPage = 0;
	int iFirstPostOnNextPage = 0;
	int iTotalPosts = 0;
	bool bDefaultCanRead = true;
	bool bDefaultCanWrite = true;
	int iForumPostCount = 0;
	bool bAlertInstantly = false;
	
	if (!SP.IsEOF())
	{
		bDefaultCanRead = SP.GetBoolField("CanRead");
		bDefaultCanWrite = SP.GetBoolField("CanWrite");
		iTotalPosts = SP.GetIntField("Total");
		iForumID = SP.GetIntField("ForumID");
		m_SiteID = SP.GetIntField("SiteID");
		iForumPostCount = SP.GetIntField("ForumPostCount");
		bAlertInstantly = (SP.GetIntField("AlertInstantly") > 0);
	}
	
	if (iNumSkipped > 0)
	{
		// Skip all but one
		//if (iNumSkipped > 1)
		//{
		//	SP.MoveNext(iNumSkipped - 1);
		//}
		iLastPostOnPreviousPage = SP.GetIntField("EntryID");
		SP.MoveNext();
	}
	

	sPosts << "<FORUMTHREADPOSTS GUESTBOOK='1' FORUMID='" << iForumID << "' ALERTINSTANTLY='" << bAlertInstantly << "' SKIPTO='" << iNumSkipped << "' COUNT='" << iNumPosts << "' ASCORDER='" << iAscendingOrder << "'";
	if (bDefaultCanRead)
	{
		sPosts << " CANREAD='1'";
	}
	else
	{
		sPosts << " CANREAD='0'";
	}
	if (bDefaultCanWrite)
	{
		sPosts << " CANWRITE='1'";
	}
	else
	{
		sPosts << " CANWRITE='0'";
	}

	if (SP.IsEOF())
	{
		GetForumSiteID(iForumID,0, m_SiteID);
	}
	sPosts << " FORUMPOSTCOUNT='" << iForumPostCount << "' ";
	sPosts << " FORUMPOSTLIMIT='" << m_InputContext.GetCurrentSiteOptionInt("Forum", "PostLimit") << "' ";
	sPosts << " TOTALPOSTCOUNT='" << iTotalPosts << "' SITEID='" << m_SiteID << "'>";
	int iCount = 0;
	while (iTotalPosts > 0 && !SP.IsEOF() && iNumPosts > 0)
	{
		int iThisCanRead = SP.GetIntField("CanRead");
		int iThisCanWrite = SP.GetIntField("CanWrite");
		int iPostID = SP.GetIntField("EntryID");
		int iInReplyTo = SP.GetIntField("Parent");
		int iPrevSibling = SP.GetIntField("PrevSibling");
		int iNextSibling = SP.GetIntField("NextSibling");
		int iFirstChild = SP.GetIntField("FirstChild");
		int iUserID = SP.GetIntField("UserID");
		int iHidden = SP.GetIntField("Hidden");
		int iEditor = SP.GetIntField("Editor");
		int iNotable= SP.GetIntField("Notable");
		int iThreadID = SP.GetIntField("ThreadID");
		CTDVString sSubject = "";
		if (iHidden == 3) // 3 means premoderated! - Hidden!
		{
			sSubject = "Hidden";
		}
		else if (iHidden > 0)
		{
			sSubject = "Removed";
		}
		else
		{
			SP.GetField("Subject", sSubject);
		}

		CTDVDateTime dDate = SP.GetDateField("DatePosted");
		CTDVString sDate = "";
		dDate.GetAsXML(sDate);
		
		CTDVString sUserName = "";
		SP.GetField("UserName",sUserName);
		if (sUserName.GetLength() == 0)
		{
			sUserName << "Member " << iUserID;
		}

		CTDVString sText = "";
		if (iHidden == 3) // 3 means premoderated! - Hidden!
		{
			sText = "This post has been Hidden";
		}
		else if (iHidden > 0)
		{
			sText = "This post has been Removed";
		}
		else
		{
			SP.GetField("text",sText);
		}

		if (SP.GetIntField("PostStyle") != 1) 
		{
			MakeTextSafe(sText);
		}
		else
		{
			CTDVString sTemp;
			sTemp << "<RICHPOST>" << sText << "</RICHPOST>";
			sText = sTemp;
		}
		//MakeSubjectSafe(&sSubject);
		EscapeAllXML(&sSubject);

		// start creating the post structure
		sPosts << "<POST POSTID='" << iPostID << "'";
		sPosts << " THREAD='" << iThreadID << "'";
		
		// We have an incrementing index field for the next and
		// previous buttons
		sPosts << " INDEX='" << iCount << "'";
		
		// Put a 'Previous' attribute in if applicable
//			if (iCount > 0)
//			{
//				sPosts << " PREVINDEX='" << iCount-1 << "'";
//			}

		// Always put in a next field, the stylesheet can work it out
//			sPosts << " NEXTINDEX='" << iCount+1 << "'";
		
		// Increment the index here
		iCount++;

		// This *might* be useful...
		if (iInReplyTo > 0)
		{
			sPosts << " INREPLYTO='" << iInReplyTo << "'";
		}

		if (iPrevSibling > 0)
		{
			sPosts << " PREVSIBLING='" << iPrevSibling << "'";
		}

		if (iNextSibling > 0)
		{
			sPosts << " NEXTSIBLING='" << iNextSibling << "'";
		}

		if (iFirstChild > 0)
		{
			sPosts << " FIRSTCHILD='" << iFirstChild << "'";
		}

		sPosts << " HIDDEN='" << iHidden << "'";
		
		// Add the CanRead and CanWrite For the Thread
		sPosts << " CANREAD='" << iThisCanRead << "' CANWRITE='" << iThisCanWrite << "'>";
//			sPosts << ">";

		sPosts << "<SUBJECT>" << sSubject << "</SUBJECT>\n";

		sPosts << "<DATEPOSTED>" << sDate << "</DATEPOSTED>\n";

		sPosts << "<USER><USERID>" << iUserID << "</USERID><USERNAME>";
		if (iHidden > 0)
		{
			sPosts << "Researcher " << iUserID;
		}
		else
		{
			sPosts << sUserName;
		}
		sPosts << "</USERNAME>";
		
		CTDVString sTitle;
		if (!SP.IsNULL("Title"))
		{
			SP.GetField("Title",sTitle);
			EscapeXMLText(&sTitle);
			sPosts << "<TITLE>" << sTitle << "</TITLE>";
		}

		CTDVString sArea;
		if (!SP.IsNULL("Area"))
		{	
			SP.GetField("Area",sArea);
			EscapeXMLText(&sArea);
			sPosts << "<AREA>" << sArea << "</AREA>";
		}
		
		InitialiseXMLBuilder(&sPosts, &SP);
		bool bOk = AddDBXMLTag("FirstNames",NULL,false);
		bOk = bOk && AddDBXMLTag("LastName",NULL,false);
		bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);
		bOk = bOk && AddDBXMLTag("Status","STATUS",false);
		bOk = bOk && AddDBXMLTag("TaxonomyNode","TAXONOMYNODE",false);
		bOk = bOk && AddDBXMLTag("Journal","JOURNAL",false);
		bOk = bOk && AddDBXMLTag("Active","ACTIVE",false);

		TDVASSERT(bOk,"Problems getting first, last name and site suffix for posts!");

		sPosts << "<EDITOR>" << iEditor << "</EDITOR>";
		sPosts << "<NOTABLE>" << iNotable << "</NOTABLE>";

		// Get user groups
		CTDVString sUserGroups;
		if(!m_InputContext.GetUserGroups(sUserGroups, iUserID))
		{
			TDVASSERT(false, "Failed to get user groups");
		}
		else
		{
			sPosts << sUserGroups;
		}

		
		sPosts << "</USER>\n";

		sPosts << "<TEXT>" << sText << "</TEXT>";
		sPosts << "</POST>";

		iNumPosts--;
		SP.MoveNext();
	}

	sPosts << "</FORUMTHREADPOSTS>";
	bool bSuccess = CreateFromXMLText(sPosts);

	// If we haven't yet reached EOF then set the 'more' flag
	if (bSuccess && iTotalPosts > 0 && !SP.IsEOF())
	{
		// Get the node and add a MORE attribute
		CXMLTree* pFNode = m_pTree->FindFirstTagName("FORUMTHREADPOSTS", 0, false);
		TDVASSERT(pFNode != NULL, "Can't find FORUMTHREADPOSTS node");
		
		if (pFNode != NULL)
		{
			pFNode->SetAttribute("MORE","1");
		}

		// Also get the ID of the next post
		iFirstPostOnNextPage = SP.GetIntField("EntryID");
	}

	SP.Release();
	
	if (bSuccess)
	{
		// Now add the PREVINDEX and NEXTINDEX attributes for all the nodes
		CXMLTree* pNode = m_pTree->FindFirstTagName("POST",NULL,false);
		CXMLTree* pPrevNode = NULL;
		int iPrevID = 0;

		// loop through the tree setting this node's PREVINDEX to iPrevID
		// and remembering the previous ID
		while (pNode != NULL)
		{
			int iThisNodeID = pNode->GetIntAttribute("POSTID");
			// If we've got a previous node ID, this one's PREVINDEX should
			// be set to that
			if (iPrevID > 0)
			{
				pNode->SetAttribute("PREVINDEX",iPrevID);
			}
			else
			{
				if (iLastPostOnPreviousPage > 0)
				{
					pNode->SetAttribute("PREVINDEX", iLastPostOnPreviousPage);
				}
			}

			// Now set the NEXTINDEX attribute of the previous node if it
			// exists
			if (pPrevNode != NULL)
			{
				pPrevNode->SetAttribute("NEXTINDEX",iThisNodeID);
			}
			
			// Now remember the current node and ID
			pPrevNode = pNode;
			iPrevID = iThisNodeID;

			// Find the next node in the tree
			pNode = pNode->FindNextTagNode("POST");
		}
		// Now set the attribute on the last node we found
		if ((pPrevNode != NULL) && (iFirstPostOnNextPage > 0))
		{
			pPrevNode->SetAttribute("NEXTINDEX", iFirstPostOnNextPage);
		}
	}
	
	CTDVString StringToCache;
	GetAsString(StringToCache);
	CachePutItem("forumpostsguestbook", cachename, StringToCache);
	FilterOnPermissions(pViewer, iForumID, "FORUMTHREADPOSTS");
	FilterIndividualThreadPermissions(pViewer,"FORUMTHREADPOSTS","THREAD");
	UpdateRelativeDates();
	return bSuccess;		
}

/*********************************************************************************

	static bool CForum::GetForumModerationStatus(CInputContext& inputContext, int iForumID, int& iModerationStatus)

	Author:		Mark Neves
	Created:	15/9/2003
	Inputs:		iForumID - forum ID
				inputContext - input context to create storedprocedure object
	Outputs:	iModerationStatus - moderation status of the specified forum 
	Returns:	true on success
	Purpose:	fetches the moderation status for the given forum

*********************************************************************************/

bool CForum::GetForumModerationStatus(CInputContext& inputContext, int iForumID, int& iModerationStatus)
{
	CStoredProcedure sp;
	if (!inputContext.InitialiseStoredProcedureObject(&sp))
	{
		return false;
	}
	
	return sp.GetForumModerationStatus(iForumID, 0,iModerationStatus);
}

/*********************************************************************************

	static bool CForum::UpdateForumModerationStatus(CInputContext& inputContext, int iForumID, int iNewStatus)

	Author:		Mark Neves
	Created:	17/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Update's the given forum's moderation status

*********************************************************************************/

bool CForum::UpdateForumModerationStatus(CInputContext& inputContext, int iForumID, int iNewStatus)
{
	CStoredProcedure SP;
	if (!inputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	return SP.UpdateForumModerationStatus(iForumID,iNewStatus);
}


int CForum::GetThreadOrderID(CTDVString& sOrderDesc)
{
	// set to default of 1
	int iOrderID = LATESTPOST;
	if(sOrderDesc.CompareText("createdate"))
	{
		return CREATEDATE;
	}
	else if(sOrderDesc.CompareText("latestpost")) 
	{
		return LATESTPOST;
	}
	/*else if(sOrderDesc.CompareText("NUMMESSAGES"))
	{
		return NUMMESSAGES;
	}*/
	
	return iOrderID;
}

bool CForum::GetThreadOrderDesc(const int iThreadOrder, CTDVString& sOrderDesc)
{
	if(!sOrderDesc.IsEmpty())
	{
		sOrderDesc.Empty();
	}

	if(iThreadOrder == CREATEDATE)
	{
		sOrderDesc << "createdate";
	}
	else if(iThreadOrder == LATESTPOST) 
	{
		sOrderDesc << "latestpost";
	}
	/*else if(iThreadOrder == NUMMESSAGES)
	{
		sOrderDesc << "nummessages";
	}*/
	else
	{	
		// set the default
		sOrderDesc << "latestpost";
	}
	return true;
}


/*********************************************************************************

	bool CForum::HideThreadFromUsers(int iThreadID, int iForumID)

		Author:		Mark Howitt
        Created:	17/03/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CForum::HideThreadFromUsers(int iThreadID, int iForumID)
{
	// Create a new StoredProcedure object
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Now Call the required Function
	if (!SP.SetThreadVisibleToUsers(iThreadID,iForumID,false))
	{
		return SetDNALastError("CForum","SetThreadVisibleToUsersFailed","SetThreadVisibleToUsers failed!");
	}

	// Check and return 
	return (SP.GetIntField("ThreadBelongsToForum") == 1);
}

/*********************************************************************************

	bool CForum::UnHideThreadFromUsers(int iThreadID, int iForumID)

		Author:		Mark Howitt
        Created:	17/03/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CForum::UnHideThreadFromUsers(int iThreadID, int iForumID)
{
	// Create a new StoredProcedure object
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Now Call the required Function
	if (!SP.SetThreadVisibleToUsers(iThreadID,iForumID,true))
	{
		return SetDNALastError("CForum","SetThreadVisibleToUsersFailed","SetThreadVisibleToUsers failed!");
	}

	// Check and return 
	return (SP.GetIntField("ThreadBelongsToForum") == 1);
}

bool CForum::UpdateAlertInstantly(CInputContext& inputContext, int iAlert, int iForumID)
{
	// Create a new StoredProcedure object
	CStoredProcedure SP;
	inputContext.InitialiseStoredProcedureObject(&SP);

	// Now Call the required Function
	return SP.UpdateForumAlertInstantly(iAlert, iForumID);
}

int CForum::GetForumID()
{
	return m_ForumID;
}


/*********************************************************************************

	bool CForum::GetForumStyle(int iForumID, int& iForumStyle) 

		Author:		David Williams		
        Created:	25/10/2004
        Inputs:		iForumID - unique ID of forum
        Outputs:	iForumStyle - reference to int to return the Forum Style value
        Returns:	true if successful, false otherwise
        Purpose:	Get the ForumStyle colum from a forum - this is required so 
					the forum can be displayed in the correct format.

*********************************************************************************/

bool CForum::GetForumStyle(int iForumID, int& iForumStyle) 
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetForumStyle(iForumID)) 
	{
		return SetDNALastError("CForum", "GetForumStyleFailed", "GetForumStyle failed!");
	}

	iForumStyle = SP.GetIntField("ForumStyle");
	return true;
}

/*********************************************************************************

	bool CForum::GetEMailAlertSubscriptionStatusForUser(int iUserID, int iForumID)

		Author:		Mark Howitt
		Created:	27/09/2004
		Inputs:		iUserID - The Id of the user you want to get the status for.
					iForumID - THe forum you want to check the status for.
		Outputs:	Subscriptions - A list of subscription values.
		Returns:	true if ok, false if not
		Purpose:	Gets the status of the user subscription to a given forum.
					0 = Not subscription.
					1 = Normal.
					2 = Instant.

					NOTE!!! The user might be subscribed for both instant and normal.
							This system is generic and extendable for new types of subscriptions.
		
*********************************************************************************/
/*
	MARK HOWITT 01/10/04 - This is commented out as it is work that is half completed. This WILL be needed
							and should be reinserted for the subscribe to forum on the forum page.

bool CForum::GetEMailAlertSubscriptionStatusForUser(int iUserID, int iForumID)
{
	// Check the input params
	if (iUserID == 0 || iForumID == 0)
	{
		// Not really a problem, might be called with no user logged in or for a new forum.
		TDVASSERT(false,"CForum::GetEMailAlertSubscriptionStatusForUser - UserID OR ForumID is NULL!");
		return true;
	}

	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetUsersEmailAlertSubscriptionForItem(iUserID,iForumID,(int)CBaseList::IT_FORUM))
	{
		TDVASSERT(false,"Stored Procedure failed in CForum::GetEMailAlertSubscriptionStatusForUser!!!");
		return false;
	}

	// Setup the XML Builder
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = OpenXMLTag("EMAIL-SUBSCRIPTION");

	// Get the subscription values
	int iSubType = 0;
	while (!SP.IsEOF())
	{
		// Get the status value
		iSubType = SP.GetIntField("Subscription");
		if (iSubType == 1)
		{
			bOk = bOk && AddXMLTag("SUBSCRIPTION","normal");
		}
		else if (iSubType == 2)
		{
			bOk = bOk && AddXMLTag("SUBSCRIPTION","instant");
		}
		else
		{
			TDVASSERT(false,"CForum::GetEMailAlertSubscriptionStatusForUser - Invalid Subscription found in database");
		}
		
		SP.MoveNext();
	}

	// Close the tag
	CloseXMLTag("EMAIL-SUBSCRIPTION");

	// return the verdict!!!
	return bOk && CreateFromXMLText(sXML,NULL,true);
}
*/


/*********************************************************************************

	CTDVString CForum::GetPostEditableAttribute(int iPostEditorId, const CTDVDateTime& dateCreated)

	Author:		David van Zijl
    Created:	10/11/2004
    Inputs:		iPostEditorId - ID of user who created the post
				dateCreated - date of when post was created
    Outputs:	-
    Returns:	string value of EDITABLE attribute to go into an xml tag
    Purpose:	Works out whether a post is editable by the current user based on 
				who created it and how long ago. The timeout for editing posts is
				set per site and is specified in minutes. The value of the attribute 
				will either be "0" meaning it can't be edited or "#" where # is
				the number of minutes left to edit, rounded down
				e.g. return value can be ' EDITABLE="0"' or ' EDITABLE="7"'

*********************************************************************************/
int CForum::GetPostEditableAttribute(int iPostEditorId, const CTDVDateTime& dateCreated )
{
	// Get per-site timeout value
	int iTimeout = m_InputContext.GetThreadEditTimeLimit();

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	int iViewingUserId = 0;
	if (pViewingUser != NULL)
	{
		iViewingUserId = pViewingUser->GetUserID();
	}
	if (iTimeout <= 0 || iViewingUserId != iPostEditorId)
	{
		// Not editable
		return 0;
	}

	long liEditable = 0;
	CTDVString sReturnVal;

	COleDateTime currTime = COleDateTime::GetCurrentTime();
	COleDateTimeSpan Difference = currTime - (COleDateTime)dateCreated;
	long liMinutesLeft = (long)((double)iTimeout - Difference.GetTotalMinutes()); // Make sure our result is rounded down

	if (liMinutesLeft >= 0)
	{
		liEditable = liMinutesLeft;
	}

	return liEditable;
}

bool CForum::IsForumATopic(int iSiteID, int iForumID)
{
	return m_InputContext.IsForumATopic(iSiteID, iForumID);
}
