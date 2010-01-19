// CommentsList.cpp: implementation of the CCommentsList class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2007.

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
#include "CommentsList.h"
#include "XMLTree.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CCommentsList::CCommentsList(CInputContext& inputContext)
																			 ,
	Author:		Steven Francis
	Created:	15/06/2007
	Inputs:		inputContext - input context
	Outputs:	-
	Returns:	-
	Purpose:	Construct a CCommentsList object and provide its member variables with
				suitable default values.

*********************************************************************************/

CCommentsList::CCommentsList(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
	// on further construction
}

/*********************************************************************************

	CCommentsList::~CCommentsList()

	Author:		Steven Francis
	Created:	15/06/2007
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Deallocate any resources acquired specifically by this subclass.

*********************************************************************************/

CCommentsList::~CCommentsList()
{
	// no other destruction than that in the base class
}

/*********************************************************************************

	bool CCommentsList::Initialise()

	Author:		Steven Francis
	Created:	15/06/2007
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not. Should never fail unless called
				on an already initialised object.
	Purpose:	Initialise the post list object by creating empty <COMMENTS-LIST> tags
				within which to insert the actual posts.

*********************************************************************************/

bool CCommentsList::Initialise()
{
	TDVASSERT(m_pTree == NULL, "CCommentsList::Initialise() called with non-NULL tree");
	// TODO: some code
	// put the empty tag in for the base of this xml
	m_pTree = CXMLTree::Parse("<COMMENTS-LIST></COMMENTS-LIST>");
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

	bool CCommentsList::CreateRecentCommentsList(CUser* pViewer, int iUserID, int iMaxNumber, int iSkip)

	Author:		Steven Francis
	Created:	15/06/2007
	Inputs:		pViewer -  the viewing user
				iUserID - user ID of the user whose most recent comments this object should contain.
				iSkip - the number of records to skip
				iShow - the maximum number of comments to include in list.
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates the list of the most recent comments by this
				user, however that is defined. Will automatically initialise object
				so should only be called on an uninitialised object.

*********************************************************************************/

bool CCommentsList::CreateRecentCommentsList(CUser* pViewer, int iUserID, int iSkip, int iShow)
{
	TDVASSERT(m_pTree == NULL, "CCommentsList::CreateRecentCommentsList() called with non-NULL tree");
	TDVASSERT(iUserID > 0, "CCommentsList::CreateRecentCommentsList(...) called with non-positive ID");
	TDVASSERT(iShow > 0, "CCommentsList::CreateRecentCommentsList(...) called with non-positive number of comments to show");
	
	// check object is not already initialised
	if (m_pTree != NULL || iUserID <= 0 || iShow <= 0)
	{
		return false;
	}

	bool bShowPrivate = false;
	if (pViewer != NULL && (iUserID == pViewer->GetUserID() || pViewer->GetIsEditor()))
	{
		bShowPrivate = true;
	}

	// create the root tag to insert everything inside
	if (!Initialise())
	{
		// failed, so delete any partial tree that was created
		delete m_pTree;
		m_pTree = NULL;
		return false;
	}
	
	// Find the root in the current XML tree
	CXMLTree* pCommentListRoot = m_pTree->FindFirstTagName("COMMENTS-LIST");

	// Put COUNT and SKIPTO attributes in the root attribute
	if (pCommentListRoot != NULL)
	{
		pCommentListRoot->SetAttribute("SHOW", iShow);
		pCommentListRoot->SetAttribute("SKIP", iSkip);
	}

	int iSiteId = 0;
	// Always pass SiteID into GetUsersMostRecentPosts
	iSiteId = m_InputContext.GetSiteID();

	int iCount = 0;

	// create a stored procedure object to access the database
	CStoredProcedure SP;
	bool bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);

	// now call the appropriate SP in the DB
	if (bSuccess && SP.GetUsersMostRecentComments(iUserID, iSiteId, iSkip, iShow ))
	{
		// Check to see if we found anything
		CTDVString sUserName;
		if (!SP.IsEOF())
		{
			// Get the user name
			SP.GetField("UserName", sUserName);
			EscapeXMLText(&sUserName);
		}

		if (pCommentListRoot != NULL)
		{
			// If the username is empty then put the default MemberID value in
			if (sUserName.IsEmpty())
			{
				sUserName << "Member " << iUserID;
			}

			CTDVString sUserElement;
			InitialiseXMLBuilder(&sUserElement, &SP);
			bSuccess = bSuccess && OpenXMLTag("User");
			bSuccess = bSuccess && AddXMLIntTag("UserID", iUserID);
			bSuccess = bSuccess && AddXMLTag("UserName", sUserName);
			bSuccess = bSuccess && AddDBXMLTag("Area", NULL, false);
			bSuccess = bSuccess && AddDBXMLTag("FirstNames", NULL, false);
			bSuccess = bSuccess && AddDBXMLTag("LastName", NULL, false);
			bSuccess = bSuccess && AddDBXMLIntTag("Status", NULL, false);
			bSuccess = bSuccess && AddDBXMLIntTag("TaxonomyNode", NULL, false);
			bSuccess = bSuccess && AddDBXMLIntTag("Active", NULL, false);
			//bSuccess = bSuccess && AddDBXMLTag("Title",NULL,false);
			//bSuccess = bSuccess && AddDBXMLTag("SiteSuffix",NULL,false);

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
				AddInside("COMMENTS-LIST", sUserElement);
			}
		}

		if (iSkip > 0 && !SP.IsEOF())
		{
			SP.MoveNext(iSkip);
		}
			
		CTDVString sComments;
		InitialiseXMLBuilder(&sComments, &SP);
		bSuccess = bSuccess && OpenXMLTag("COMMENTS", false);
		bSuccess = bSuccess && CloseXMLTag("COMMENTS");
		// then add it inside the comments-list object
		bSuccess = bSuccess && CXMLObject::AddInside("COMMENTS-LIST", sComments);

		while (!SP.IsEOF() && bSuccess && iShow > 0)
		{
			int iCommentSiteID = 0;
			CTDVString sCommentXML;
			InitialiseXMLBuilder(&sCommentXML, &SP);

			// Setup the Post Tag and Attributes
			bSuccess = bSuccess && OpenXMLTag("COMMENT");//, true);
			//bSuccess = bSuccess && AddDBXMLIntAttribute("COUNTCOMMENTS", NULL, false, true);

			bSuccess = bSuccess && AddDBXMLIntTag("SiteID", NULL, true, &iCommentSiteID);

			bSuccess = bSuccess && AddDBXMLTag("SUBJECT");

			bSuccess = bSuccess && AddDBXMLDateTag("DatePosted", NULL, false, true);

			bSuccess = bSuccess && AddDBXMLIntTag("FORUMID");
			bSuccess = bSuccess && AddDBXMLTag("ForumTitle");
			bSuccess = bSuccess && AddDBXMLIntTag("ForumPostCount");
			bSuccess = bSuccess && AddDBXMLTag("URL");
			bSuccess = bSuccess && AddDBXMLIntTag("PostIndex");

			bSuccess = bSuccess && AddDBXMLTag("Text");

			bSuccess = bSuccess && AddDBXMLDateTag("ForumCloseDate", NULL, false, true);

			// Finally close the COMMENT tag
			bSuccess = bSuccess && CloseXMLTag("COMMENT");

			// then add it inside this object
			bSuccess = bSuccess && CXMLObject::AddInside("COMMENTS", sCommentXML);

			SP.MoveNext();
			iShow--;
			iCount++;
		}

		// Set a MORE attribute if we haven't hit EOF
		if (bSuccess &&  pCommentListRoot != NULL)
		{
			if (!SP.IsEOF())
			{
				pCommentListRoot->SetAttribute("MORE", "1");
			}
			pCommentListRoot->SetAttribute("COUNT", iCount);
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
		CTDVString cachename = "COMLIST";
		cachename << iUserID << "-" << iSkip << "-" << (iSkip + iShow) << ".txt"; 
		CTDVString StringToCache;
		CreateCacheText(&StringToCache);
		CachePutItem("recentposts",cachename, StringToCache);
	}

	// return whether successfull or not
	return bSuccess;
}
