// PostList.cpp: implementation of the CPostList class.
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
#include "PostList.h"
#include "XMLTree.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"
#include ".\TagItem.h"
#include "forum.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CPostList::CPostList(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		inputContext - input context
	Outputs:	-
	Returns:	-
	Purpose:	Construct a CPostList object and provide its member variables with
				suitable default values.

*********************************************************************************/

CPostList::CPostList(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
	// on further construction
}

/*********************************************************************************

	CPostList::~CPostList()

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Deallocate any resources acquired specifically by this subclass.

*********************************************************************************/

CPostList::~CPostList()
{
	// no other destruction than that in the base class
}

/*********************************************************************************

	bool CPostList::Initialise()

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not. Should never fail unless called
				on an already initialised object.
	Purpose:	Initialise the post list object by creating empty <POST-LIST> tags
				within which to insert the actual posts.

*********************************************************************************/

bool CPostList::Initialise()
{
	TDVASSERT(m_pTree == NULL, "CPostList::Initialise() called with non-NULL tree");
	// TODO: some code
	// put the empty tag in for the base of this xml
	m_pTree = CXMLTree::Parse("<POST-LIST></POST-LIST>");
	// parse should always succeed unless memory problems
	if (m_pTree != NULL)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CPostList::CreateRecentPostsList(int iUserID)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		iUserID - user ID of the user whose most recent posts this object
					should contain.
				iMaxNumber - the maximum number of posts to include in list.
					Defaults to a value of ten.
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates the actual list of the most recent forum postings by this
				user, however that is defined. Will automatically initialise object
				so shouldonly be called on an uninitialised object.

*********************************************************************************/

bool CPostList::CreateRecentPostsList(CUser* pViewer, int iUserID, int iMaxNumber, int iSkip, int iPostType)
{
	return CreateRecentPostsList2(pViewer,iUserID,iMaxNumber,iSkip,iPostType);
	
// Code below commented out since its never reached.
// Jamesp 26/04/05
/*	TDVASSERT(m_pTree == NULL, "CPostList::CreateRecentPostsList() called with non-NULL tree");
	TDVASSERT(iUserID > 0, "CPostList::CreateRecentPostsList(...) called with non-positive ID");
	TDVASSERT(iMaxNumber > 0, "CPostList::CreateRecentPostsList(...) called with non-positive max number of posts");

	if (iMaxNumber > 200)
	{
		iMaxNumber = 200;
	}

	CTDVString cachename = "PL";
	cachename << iUserID << "-" << iSkip << "-" << (iSkip + iMaxNumber - 1) << ".txt"; 
	
	CStoredProcedure SP;

	// check object is not already initialised
	if (m_pTree != NULL || iUserID <= 0 || iMaxNumber <= 0)
	{
		return false;
	}

	bool bShowPrivate = false;
	if (pViewer != NULL && (iUserID == pViewer->GetUserID() || pViewer->GetIsEditor()))
	{
		bShowPrivate = true;
	}
	
	CTDVDateTime dExpires(60*5);		// Make it expire after 5 minutes
	CTDVString sXML;

//	if (CacheGetItem("recentposts", cachename, &dExpires, &sXML))
//	{
//		// make sure object was successfully created from cached text
//		if (CreateFromCacheText(sXML))
//		{
//			UpdateRelativeDates();
//			return true;
//		}
//	}

	// create the root tag to insert everything inside
	bool bSuccess = this->Initialise();
	
	// Find the root in the current XML tree
	CXMLTree* pArticleRoot = m_pTree->FindFirstTagName("POST-LIST");

	// Put COUNT and SKIPTO attributes in the root attribute
	if (pArticleRoot != NULL)
	{
		pArticleRoot->SetAttribute("COUNT", iMaxNumber);
		pArticleRoot->SetAttribute("SKIPTO", iSkip);
	}
	
	// create a stored procedure object to access the database
	if (bSuccess)
	{
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			bSuccess = false;
		}
	}
	// now call the appropriate SP in the DB
	if (bSuccess)
	{
		bSuccess = SP.GetUsersMostRecentPosts(iUserID);
	}
	// if all okay then extract the fields data for each post and build the XML
	if (bSuccess)
	{
		int iThreadID = 0;
		int iForumID = 0;
		int iSiteID = 1;
		CTDVString subject;
		CTDVDateTime postDate;
		CTDVDateTime replyDate;
		bool bReplies = false;
		int iPrivate = 0;
		CTDVString postDateXML;
		CTDVString replyDateXML;
		CTDVString postXML;
		CTDVString sUsername;
		CTDVString sJournalArea;
		CTDVString sJournalTitle;
		CTDVString sFirstPosterArea;
		CTDVString sFirstPosterTitle;
		CTDVString sJournalName;
		CTDVString sForumTitle;
		int iJournalUserID;
		int iYourLastPost = 0;
		int iFirstPosterUserID = 0;
		CTDVString sFirstPosterUserName;
		CTDVString sType;
		CTDVString sArea;
		CTDVString sTitle;
		CTDVString sSiteSuffix;
		CTDVString sFirstNames;
		CTDVString sLastName;

		if (!SP.IsEOF())
		{
			SP.GetField("UserName", sUsername);
			EscapeXMLText(&sUsername);

			if (!SP.IsNULL("Area"))
			{
				SP.GetField("Area",sArea);
				EscapeXMLText(&sArea);
			}

			if (!SP.IsNULL("Title"))
			{
				SP.GetField("Title",sTitle);
				EscapeXMLText(&sTitle);
			}

			if (!SP.IsNULL("SiteSuffix"))
			{
				SP.GetField("SiteSuffix",sSiteSuffix);
				EscapeXMLText(&sSiteSuffix);
			}

			if (!SP.IsNULL("FirstNames"))
			{
				SP.GetField("FirstNames",sFirstNames);
				EscapeXMLText(&sFirstNames);
			}

			if (!SP.IsNULL("LastName"))
			{
				SP.GetField("LastName",sLastName);
				EscapeXMLText(&sLastName);
			}
		}

		if (sUsername.GetLength() == 0)
		{
			sUsername << "Member " << iUserID;
		}
		
		if (pArticleRoot != NULL)
		{
			CTDVString sUserElement;
			sUserElement << "<USER><USERID>" << iUserID << "</USERID>"
						 << "<USERNAME>" << sUsername << "</USERNAME>";

			if (!sArea.IsEmpty())
			{
				sUserElement << "<AREA>" << sArea << "</AREA>";
			}

			if (!sTitle.IsEmpty())
			{
				sUserElement << "<TITLE>" << sTitle << "</TITLE>";
			}

			if (!sSiteSuffix.IsEmpty())
			{
				sUserElement << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>";
			}
			
			if (!sFirstNames.IsEmpty())
			{
				sUserElement << "<FIRSTNAMES>" << sFirstNames << "</FIRSTNAMES>";
			}
			
			if (!sTitle.IsEmpty())
			{
				sUserElement << "<LASTNAME>" << sLastName << "</LASTNAME>";
			}

			sUserElement << "</USER>";

			AddInside("POST-LIST",sUserElement);
		}

		if (iSkip > 0 && !SP.IsEOF())
		{
			SP.MoveNext(iSkip);
		}
		
		// Handle CountPosts and LastPostReadIndex
		
		// continue until out of data or something goes wrong
		while (!SP.IsEOF() && bSuccess && iMaxNumber > 0)
		{
			iPrivate = SP.GetIntField("Private");
			// check for success of each operation as we go along
			iThreadID = SP.GetIntField("ThreadID");
			bSuccess = (iThreadID != 0);
			iForumID = SP.GetIntField("ForumID");
			bSuccess = (iForumID != 0);
			iSiteID = SP.GetIntField("SiteID");
			iJournalUserID = SP.GetIntField("Journal");
			SP.GetField("JournalName",sJournalName);
			if (!SP.IsNULL("JournalArea"))
			{
				SP.GetField("JournalArea",sJournalArea);
				EscapeXMLText(&sJournalArea);
			}

			if (!SP.IsNULL("JournalTitle"))
			{
				SP.GetField("JournalTitle",sJournalTitle);
				EscapeXMLText(&sJournalTitle);
			}
			
			EscapeAllXML(&sJournalName);
			SP.GetField("ForumTitle", sForumTitle);
			EscapeAllXML(&sForumTitle);
			bSuccess = bSuccess && SP.GetField("FirstSubject", subject);
			MakeSubjectSafe(&subject);
			int iCountPosts = SP.GetIntField("CountPosts");
			int iLastPostCountRead = 0;
			bool bGotLastCountRead = bShowPrivate && !SP.IsNULL("LastPostCountRead");
			if (bGotLastCountRead) 
			{
				iLastPostCountRead = SP.GetIntField("LastPostCountRead");
			}
			// get dates with relative date info
			postDate = SP.GetDateField("MostRecent");
			bSuccess = bSuccess && postDate.GetAsXML(postDateXML, true);
			replyDate = SP.GetDateField("LastReply");
			bSuccess = bSuccess && replyDate.GetAsXML(replyDateXML, true);

			iYourLastPost = SP.GetIntField("YourLastPost");

			bReplies = SP.GetBoolField("Replies");

			iFirstPosterUserID = SP.GetIntField("FirstPosterUserID");
			SP.GetField("FirstPosterUserName",sFirstPosterUserName);
			if (!SP.IsNULL("FirstPosterArea"))
			{
				SP.GetField("FirstPosterArea",sFirstPosterArea);
				EscapeXMLText(&sFirstPosterArea);
			}
			else
			{
				sFirstPosterArea.Empty();
			}

			if (!SP.IsNULL("FirstPosterTitle"))
			{
				SP.GetField("FirstPosterTitle",sFirstPosterTitle);
				EscapeXMLText(&sFirstPosterTitle);
			}
			else
			{
				sFirstPosterTitle.Empty();
			}

			EscapeXMLText(&sFirstPosterUserName);
			
			// Get the type for the thread
			SP.GetField("Type",sType);

			if (bSuccess)
			{
				MakeSubjectSafe(&subject);
				// construct the xml representing this post
				postXML = "<POST";
				postXML << " COUNTPOSTS='" << iCountPosts << "'";
				if (bGotLastCountRead) 
				{
					postXML << " LASTPOSTCOUNTREAD='" << iLastPostCountRead << "'";
				}
				postXML << " PRIVATE='" << iPrivate << "'>";
				postXML << "<SITEID>" << iSiteID << "</SITEID>";
				postXML << "<HAS-REPLY>" << bReplies << "</HAS-REPLY>";

				postXML << "<THREAD" << " FORUMID=\"" << iForumID << "\"";
				postXML <<	" THREADID=\"" << iThreadID << "\"";
				postXML <<	" TYPE=\"" << sType << "\">";

				postXML <<		"<SUBJECT>" << subject << "</SUBJECT>";
				postXML <<		"<REPLYDATE>" << replyDateXML << "</REPLYDATE>";
				if (iJournalUserID > 0)
				{
					postXML << "<JOURNAL USERID='" << iJournalUserID << "'>" << sJournalName;
					if (!sJournalArea.IsEmpty())
					{
						postXML << "<AREA>" << sJournalArea << "</AREA>";
					}
					if (!sJournalTitle.IsEmpty())
					{
						postXML << "<TITLE>" << sJournalTitle << "</TITLE>";
					}
					postXML << "</JOURNAL>";
				}
				postXML << "<FORUMTITLE>" << sForumTitle << "</FORUMTITLE>";
				// Only add the LASTPOST item if we got it from the database
				if (iYourLastPost > 0)
				{
					postXML << "<LASTUSERPOST POSTID=\"" << iYourLastPost << "\">";
					postXML <<		"<DATEPOSTED>" << postDateXML << "</DATEPOSTED>";
					postXML << "</LASTUSERPOST>";
				}
				postXML << "</THREAD>";

				postXML << "<FIRSTPOSTER>";
				postXML << "<USER><USERID>" << iFirstPosterUserID << "</USERID>"
						<< "<USERNAME>" << sFirstPosterUserName << "</USERNAME>";
				if (!sFirstPosterArea.IsEmpty())
				{
						postXML << "<AREA>" << sFirstPosterArea << "</AREA>";
				}

				if (!sFirstPosterTitle.IsEmpty())
				{
						postXML << "<TITLE>" << sFirstPosterTitle << "</TITLE>";
				}
						
				postXML	<< "</USER>" << "</FIRSTPOSTER>";

				// Only add the LAST-POST item if we got it from the database
				postXML << "</POST>";
				// then add it inside this object
				bSuccess = CXMLObject::AddInside("POST-LIST", postXML);
			}
			SP.MoveNext();
			iMaxNumber--;
		}
		// Set a MORE attribute if we haven't hit EOF
		if (bSuccess && !SP.IsEOF() && (pArticleRoot != NULL))
		{
			pArticleRoot->SetAttribute("MORE","1");
		}
	}
	if (bSuccess)
	{
		SP.Release();
	}
	else
	{
		// failed, so delete any partial tree that was created
		delete m_pTree;
		m_pTree = NULL;
	}

	if (bSuccess)
	{
		CTDVString StringToCache;
		//GetAsString(StringToCache);
		CreateCacheText(&StringToCache);
		CachePutItem("recentposts",cachename, StringToCache);
	}
	RemovePrivatePosts(bShowPrivate);

	// return whether successfull or not
	return bSuccess;*/
}

/*********************************************************************************

	bool CPostList::CreateRecentPostsList2(int iUserID)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		iUserID - user ID of the user whose most recent posts this object
					should contain.
				iMaxNumber - the maximum number of posts to include in list.
					Defaults to a value of ten.
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates the actual list of the most recent forum postings by this
				user, however that is defined. Will automatically initialise object
				so shouldonly be called on an uninitialised object.

*********************************************************************************/

bool CPostList::CreateRecentPostsList2(CUser* pViewer, int iUserID, int iMaxNumber, int iSkip, int iPostType )
{
	TDVASSERT(m_pTree == NULL, "CPostList::CreateRecentPostsList() called with non-NULL tree");
	TDVASSERT(iUserID > 0, "CPostList::CreateRecentPostsList(...) called with non-positive ID");
	TDVASSERT(iMaxNumber > 0, "CPostList::CreateRecentPostsList(...) called with non-positive max number of posts");
	
	// check object is not already initialised
	if (m_pTree != NULL || iUserID <= 0 || iMaxNumber <= 0)
	{
		return false;
	}

	bool bShowPrivate = false;
	if (pViewer != NULL && (iUserID == pViewer->GetUserID() || pViewer->GetIsEditor()))
	{
		bShowPrivate = true;
	}

	//Allow post authors to see their user-deleted notices and events.
	bool bShowUserHidden = bShowPrivate && (iPostType == 1 || iPostType == 2);

	// create the root tag to insert everything inside
	if (!Initialise())
	{
		// failed, so delete any partial tree that was created
		delete m_pTree;
		m_pTree = NULL;
		RemovePrivatePosts(bShowPrivate);
		return false;
	}
	
	// Find the root in the current XML tree
	CXMLTree* pArticleRoot = m_pTree->FindFirstTagName("POST-LIST");

	// Put COUNT and SKIPTO attributes in the root attribute
	if (pArticleRoot != NULL)
	{
		pArticleRoot->SetAttribute("COUNT", iMaxNumber);
		pArticleRoot->SetAttribute("SKIPTO", iSkip);
	}

	int iSiteId = 0;
	// Always pass SiteID into GetUsersMostRecentPosts
	iSiteId = m_InputContext.GetSiteID();

	// create a stored procedure object to access the database
	CStoredProcedure SP;
	bool bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);

	// now call the appropriate SP in the DB
	if (bSuccess && SP.GetUsersMostRecentPosts(iUserID,iPostType,iSkip+iMaxNumber, bShowUserHidden, iSiteId ))
	{
		// Check to see if we found anything
		CTDVString sUserName;
		if (!SP.IsEOF())
		{
			// Get the user name
			SP.GetField("UserName",sUserName);
			EscapeXMLText(&sUserName);
		}

		if (pArticleRoot != NULL)
		{
			// If the username is empty then put the default MemberID value in
			if (sUserName.IsEmpty())
			{
				sUserName << "Member " << iUserID;
			}

			CTDVString sUserElement;
			InitialiseXMLBuilder(&sUserElement, &SP);
			bSuccess = bSuccess && OpenXMLTag("User");
			bSuccess = bSuccess && AddXMLIntTag("UserID",iUserID);
			bSuccess = bSuccess && AddXMLTag("UserName",sUserName);
			bSuccess = bSuccess && AddDBXMLTag("Area",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("FirstNames",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("LastName",NULL,false);
			bSuccess = bSuccess && AddDBXMLIntTag("Status", NULL, false);
			bSuccess = bSuccess && AddDBXMLIntTag("TaxonomyNode", NULL, false);
			// Removed USERJOURNAL tag because it can't be inferred without a SiteID
			// And it's never used by any skins
			//bSuccess = bSuccess && AddDBXMLIntTag("UserJournal", "Journal", false);
			bSuccess = bSuccess && AddDBXMLIntTag("Active", NULL, false);
			bSuccess = bSuccess && AddDBXMLTag("Title",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("SiteSuffix",NULL,false);

			// Groups
			CTDVString sGroups;
			if(!m_InputContext.GetUserGroups(sGroups, iUserID))
			{
				TDVASSERT(false, "Failed to get user groups");
			}
			else
			{
				sUserElement += sGroups;
			}

			bSuccess = bSuccess && CloseXMLTag("User");

			if (bSuccess)
			{
				AddInside("POST-LIST",sUserElement);
			}
		}

		if (iSkip > 0 && !SP.IsEOF())
		{
			SP.MoveNext(iSkip);
		}
		
		// Handle CountPosts and LastPostReadIndex
		// continue until out of data or something goes wrong
		CTDVString sPostType;
		CTDVString sThreadSubject;
		CDNAIntArray NoticeThreadIDArray;
		int iThreadID = 0;
		int iSiteID = 0;		
		int iIsPostingFromVisibleSite = 0; 

		CForum Forum(m_InputContext);

		while (!SP.IsEOF() && bSuccess && iMaxNumber > 0)
		{
			iIsPostingFromVisibleSite = SP.GetIntField("IsPostingFromVisibleSite"); 
			if (iIsPostingFromVisibleSite == 1)
			{
				CTDVString sPostXML;
				InitialiseXMLBuilder(&sPostXML, &SP);

				// Setup the Post Tag and Attributes
				bSuccess = bSuccess && OpenXMLTag("Post",true);
				bSuccess = bSuccess && AddDBXMLIntAttribute("CountPosts");

				if (bShowPrivate)
				{
					bSuccess = bSuccess && AddDBXMLIntAttribute("LastPostCountRead");
				}

				// Add User-Hidden Status.
				if ( bShowUserHidden && SP.FieldExists("Hidden") && SP.GetIntField("Hidden") > 0 )
					bSuccess = bSuccess && AddDBXMLIntAttribute("HIDDEN");

				int iYourLastPost = SP.GetIntField("YourLastPost");			
		
				//add the editbale attribute
				if ( bSuccess && pViewer != NULL )
				{
					CTDVString sEditable;
					if ( pViewer->GetUserID() !=  iUserID)
					{
						sEditable = " EDITABLE='0'";
					}
					else
					{
						if (iYourLastPost > 0 )
						{
							CTDVDateTime DateMostRecent = SP.GetDateField("MostRecent");				
							sEditable << " EDITABLE='" << Forum.GetPostEditableAttribute(pViewer->GetUserID(), DateMostRecent) << "'";
						}
						else
						{
							sEditable = " EDITABLE='0'";
						}
					}
					sPostXML = sPostXML + sEditable + " ";				
				}

				bSuccess = bSuccess && AddDBXMLIntAttribute("Private",NULL,true,true);

				// Add the siteid and reply details
				bSuccess = bSuccess && AddDBXMLIntTag("SiteID",NULL,true,&iSiteID);
				bSuccess = bSuccess && AddDBXMLIntTag("Replies","HAS-REPLY");

				// Setup a Thread Tag and Attributes
				bSuccess = bSuccess && OpenXMLTag("Thread",true);
				bSuccess = bSuccess && AddDBXMLIntAttribute("ForumID");
				bSuccess = bSuccess && AddDBXMLIntAttribute("ThreadID",NULL,true,false,&iThreadID);

				// Add the first post id if it exists in the result set
				if (SP.FieldExists("FirstPostID"))
				{
					bSuccess = bSuccess && AddDBXMLIntAttribute("FirstPostID",NULL,true);
				}

				bSuccess = bSuccess && AddDBXMLAttribute("Type",NULL,false,true,true,&sPostType);
				bSuccess = bSuccess && AddDBXMLDateTag("EventDate",NULL,false,true);
				bSuccess = bSuccess && AddDBXMLDateTag("DateFirstPosted",NULL,false,true);

				// See if we've got an notice or event, if so then get the taginfo for the post
				if (sPostType.CompareText("notice") || sPostType.CompareText("event"))
				{
					// Add the threadid to the array so we can get the tag details later
					NoticeThreadIDArray.Add(iThreadID);
				}

				// Add the Subject 
				bSuccess = bSuccess && AddDBXMLTag("FirstSubject","SUBJECT",true,true,&sThreadSubject);
				bSuccess = bSuccess && AddDBXMLDateTag("LastReply","REPLYDATE",true,true);			

				// If we have a journal user then put the following in...
				if (SP.GetIntField("Journal") > 0)
				{
					bSuccess = bSuccess && OpenXMLTag("JOURNAL",true);
					bSuccess = bSuccess && AddDBXMLIntAttribute("Journal","USERID",true,true);
					bSuccess = bSuccess && AddDBXMLTag("JournalName","UserName",true,false);
					bSuccess = bSuccess && AddDBXMLTag("JournalArea","Area",false);
					bSuccess = bSuccess && AddDBXMLTag("JournalFirstNames","FirstNames",false);
					bSuccess = bSuccess && AddDBXMLTag("JournalLastName","LastName",false);
					bSuccess = bSuccess && AddDBXMLTag("JournalTitle","Title",false);
					bSuccess = bSuccess && AddDBXMLTag("JournalSiteSuffix","SiteSuffix",false);

					bSuccess = bSuccess && CloseXMLTag("JOURNAL");
				}

				// Get the ForumInfo and Last post details
				bSuccess = bSuccess && AddDBXMLTag("ForumTitle");
				//int iYourLastPost = SP.GetIntField("YourLastPost");
				if (iYourLastPost > 0)
				{
					bSuccess = bSuccess && OpenXMLTag("LASTUSERPOST",true);
					bSuccess = bSuccess && AddXMLIntAttribute("POSTID",iYourLastPost,true);
					bSuccess = bSuccess && AddDBXMLDateTag("MostRecent","DATEPOSTED",true,true);
					bSuccess = bSuccess && CloseXMLTag("LASTUSERPOST");
				}

				// Close the ThreadTag
				bSuccess = bSuccess && CloseXMLTag("Thread");

				// Add the first poster info
				int iFirstPostUserID = 0;
				bSuccess = bSuccess && OpenXMLTag("FIRSTPOSTER");
				bSuccess = bSuccess && OpenXMLTag("USER");
				bSuccess = bSuccess && AddDBXMLIntTag("FirstPosterUserID","UserID",false,&iFirstPostUserID);
				bSuccess = bSuccess && AddDBXMLTag("FirstPosterUserName","UserName",false,false);
				bSuccess = bSuccess && AddDBXMLTag("FirstPosterArea","Area",false);
				bSuccess = bSuccess && AddDBXMLTag("FirstPosterFirstNames","FirstNames",false);
				bSuccess = bSuccess && AddDBXMLTag("FirstPosterLastName","LastName",false);
				bSuccess = bSuccess && AddDBXMLIntTag("FirstPosterStatus", "Status", false);
				bSuccess = bSuccess && AddDBXMLIntTag("FirstPosterTaxonomyNode", "TaxonomyNode", false);
				bSuccess = bSuccess && AddDBXMLIntTag("FirstPosterJournal", "Journal", false);
				bSuccess = bSuccess && AddDBXMLIntTag("FirstPosterActive", "Active", false);
				bSuccess = bSuccess && AddDBXMLTag("FirstPosterSiteSuffix","SiteSuffix",false);
				bSuccess = bSuccess && AddDBXMLTag("FirstPosterTitle","Title",false);

				// Groups
				CTDVString sGroups;
				if(!m_InputContext.GetUserGroups(sGroups, iFirstPostUserID))
				{
					TDVASSERT(false, "Failed to get user groups");
				}
				else
				{
					sPostXML += sGroups;
				}

				bSuccess = bSuccess && CloseXMLTag("USER");
				bSuccess = bSuccess && CloseXMLTag("FIRSTPOSTER");

				// Finally close the POST tag
				bSuccess = bSuccess && CloseXMLTag("POST");

				// then add it inside this object
				bSuccess = CXMLObject::AddInside("POST-LIST", sPostXML);
			}

			SP.MoveNext();
			iMaxNumber--;
		}

		// Now insert the tag info for any notices or events found
		if (NoticeThreadIDArray.GetSize() > 0)
		{
			// Set up some locals
			CTDVString sTaggedNodeInfo;
			int iNoticeThreadID = 0;
			CTagItem TagItem(m_InputContext);

			// Now go through the list adding the taginfo into the XML
			for (int i = 0; i < NoticeThreadIDArray.GetSize(); i++)
			{
				// Get the ThreadId for the current Index
				iNoticeThreadID = NoticeThreadIDArray[i];
				sTaggedNodeInfo.Empty();

				// Get the Tagging locations!
				if (TagItem.InitialiseFromThreadId(iNoticeThreadID,iSiteID,pViewer,&sThreadSubject,false) && TagItem.GetAllNodesTaggedForItem())
				{
					// Get the taginfo from the tagitem object and insert it into the page
					TagItem.GetAsString(sTaggedNodeInfo);
					AddInsideWhereIntAttributeEquals("THREAD","THREADID",iNoticeThreadID,sTaggedNodeInfo,1);
				}
				else
				{
					// Setup an error for this post!
					SetDNALastError("CPostList::CreateRecentPostsList2","FailedToGetTagInfo","Failed to get Tagging Info for post");
					bSuccess = bSuccess && CXMLObject::AddInside("POST-LIST", GetLastErrorAsXMLString());
				}
			}
		}

		// Set a MORE attribute if we haven't hit EOF
		if (bSuccess && !SP.IsEOF() && (pArticleRoot != NULL))
		{
			pArticleRoot->SetAttribute("MORE","1");
		}
	}

	if (bSuccess)
	{
		SP.Release();
	}
	else
	{
		// failed, so delete any partial tree that was created
		delete m_pTree;
		m_pTree = NULL;
	}

	if (bSuccess)
	{
		CTDVString cachename = "PL";
		cachename << iUserID << "-" << iSkip << "-" << (iSkip + iMaxNumber - 1) << ".txt"; 
		CTDVString StringToCache;
		CreateCacheText(&StringToCache);
		CachePutItem("recentposts",cachename, StringToCache);
	}

	RemovePrivatePosts(bShowPrivate);

	// return whether successfull or not
	return bSuccess;
}

/*********************************************************************************

	bool CPostList::CreateSubscribedForumsRecentPostsList(int iUserID)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		iUserID - user ID of the user for whom to get the list of recent
					postings in the forums they subscribe to.
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates the actual list of the most recent forum postings on forums
				this user subscribes to. Will automatically initialise object
				so shouldonly be called on an uninitialised object.

*********************************************************************************/

bool CPostList::CreateSubscribedForumsRecentPostsList(int iUserID)
{
	// TODO: the code
	TDVASSERT(false, "Unimplemented method CPostList::CreateSubscribedForumsRecentPostsList called");
	return false;
}

bool CPostList::RemovePrivatePosts(bool bShowPrivate)
{
	if (!bShowPrivate)
	{	
		CXMLTree* pNode = m_pTree->FindFirstTagName("POST", NULL, false);
		while (pNode != NULL)
		{
			CXMLTree* pNext = pNode->FindNextTagNode("POST", NULL);
			if (pNode->GetIntAttribute("PRIVATE") == 1)
			{
				pNode = pNode->DetachNodeTree();
				delete pNode;
			}
			pNode = pNext;
		}
	}
	return true;
}

bool CPostList::MarkAllRead(int iUserID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.MarkAllThreadsRead(iUserID);
	return true;
}
