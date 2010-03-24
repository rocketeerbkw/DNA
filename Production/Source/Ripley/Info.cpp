// Info.cpp: implementation of the CInfo class.
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
#include "Info.h"
#include "tdvassert.h"
#include "TDVDateTime.h"
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

	CInfo::CInfo(CInputContext& inputContext)

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		inputContext - input context object allowing abstracted 
					access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	Construct an instance of the class. Note that any initialisation that
				could possibly fail is put in a seperate initialise method.

*********************************************************************************/

CInfo::CInfo(CInputContext& inputContext) : CXMLObject(inputContext)
{

}

/*********************************************************************************

	CInfo::~CInfo()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CInfo class. Functionality due when we start allocating memory

*********************************************************************************/

CInfo::~CInfo()
{

}


/*********************************************************************************

	CInfo::Initialise()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Builds a bunch of XML to represent a bunch of user metrics mimicking the user.cgi script.

*********************************************************************************/

bool CInfo::Initialise(int iSiteID)
{
	CTDVString sCacheName = "Info_";
	sCacheName << iSiteID << ".txt";
	CTDVString sInfoXML = "";

	CTDVDateTime dExpires(60*5);		// Make it expire after 5 minutes

	// get the cached version if we can
	if (CacheGetItem("Info", sCacheName, &dExpires, &sInfoXML))
	{
		// make sure object was successfully created from cached text
		if (CreateFromCacheText(sInfoXML))
		{
			UpdateRelativeDates();
			return true;
		}
	}

	// get a stored procedure object via the database context
	CStoredProcedure StoredProcedure;
	bool bGotSP = m_InputContext.InitialiseStoredProcedureObject(&StoredProcedure);
	TDVASSERT(bGotSP, "The stored procedure refused to come from CreateStoredProcedureObject()");

	// if we haven't got a recent enough cache then go get the data from the DB
	sInfoXML << "<INFO>";

	// 37076 users have registered since we launched on 28th April 1999
	sInfoXML << "<TOTALREGUSERS>";
	sInfoXML << StoredProcedure.TotalRegisteredUsers();
	sInfoXML << "</TOTALREGUSERS>";

	// There are currently 1050 submitted guide entries in the queue.
	// This now redundant with removal of queue system
//	sInfoXML << "<SUBMITTEDQUEUE>";
//	sInfoXML << pStoredProcedure->SubmittedQueueSize();
//	sInfoXML << "</SUBMITTEDQUEUE>";

	// There are currently 1068 approved entries in the Guide. 
	sInfoXML << "<APPROVEDENTRIES>";
	sInfoXML << StoredProcedure.TotalApprovedEntries(iSiteID);
	sInfoXML << "</APPROVEDENTRIES>";

	// Top Ten most prolific forum posters in last 24 hours
	sInfoXML << "<PROLIFICPOSTERS>";

	CTDVString sProlificBlock = "";
	if (StoredProcedure.FetchProlificPosters(sProlificBlock, iSiteID))
	{
		sInfoXML << sProlificBlock;
	}
	else
	{
		sInfoXML << "No even remotely prolific posters at the moment :(";
	}
		
	sInfoXML << "</PROLIFICPOSTERS>";

	// Top Ten most erudite forum posters in last 24 hours
	sInfoXML << "<ERUDITEPOSTERS>";

	CTDVString sEruditeBlock = "";
	if (StoredProcedure.FetchEruditePosters(sEruditeBlock, iSiteID))
	{
		sInfoXML << sEruditeBlock;
	}
	else
	{
		sInfoXML << "No even remotely erudite posters at the moment :(";
	}
		
	sInfoXML << "</ERUDITEPOSTERS>";

	// Top Ten longest posts in last 24 hours
	// removed so as not to encourage long posts just so as to appear on this page
//	sInfoXML << "<LONGESTPOSTS>";
//	CTDVString sMightyBlock = "";
//	if (pStoredProcedure->FetchMightyPosts(sMightyBlock))
//	{
//		sInfoXML << sMightyBlock;
//	}
//	else
//	{
//		sInfoXML << "No even remotely mighty posts at the moment :(";
//	}
//	sInfoXML << "</LONGESTPOSTS>";

	// Top Twenty most recently updated conversations
	sInfoXML << "<RECENTCONVERSATIONS>";
	
	CTDVString sFreshConversationBlock = "";
	if (StoredProcedure.FetchFreshestConversations(sFreshConversationBlock, iSiteID))
	{
		sInfoXML << sFreshConversationBlock;
	}
	else
	{
		sInfoXML << "No even remotely recent conversations at the moment :(";
	}
	
	sInfoXML << "</RECENTCONVERSATIONS>";

	// Articles updated in last 24 hours
	sInfoXML << "<FRESHESTARTICLES>";
	
	CTDVString sFreshestArticles = "";
	if (StoredProcedure.FetchFreshestArticles(sFreshestArticles, iSiteID))
	{
		sInfoXML << sFreshestArticles;
	}
	else
	{
		sInfoXML << "No even remotely recent updated articles at the moment :(";
	}
	
	sInfoXML << "</FRESHESTARTICLES>";

	sInfoXML << "</INFO>";

	// now create our tree from this XML text
	bool bSuccess = CreateFromXMLText(sInfoXML);
	// if successful then cache this new objects data
	if (bSuccess)
	{
		CTDVString StringToCache;
		CreateCacheText(&StringToCache);
		CachePutItem("Info", sCacheName, StringToCache);
	}
	// delete unneeded objects
	// return success value
	return bSuccess;
}

bool CInfo::CreateRecentConversations(int iSiteID, int iSkip, int iShow)
{
	CTDVString sCacheName = "Info_Conv_";
	sCacheName << iSiteID << "_" << iSkip << "_" << iShow << ".txt";

	CTDVString sXML;
	CTDVDateTime dExpires(60*5);		// Make it expire after 5 minutes

	// get the cached version if we can
	if (CacheGetItem("Info", sCacheName, &dExpires, &sXML))
	{
		// make sure object was successfully created from cached text
		if (CreateFromCacheText(sXML))
		{
			UpdateRelativeDates();
			return true;
		}
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	sXML = "<INFO><RECENTCONVERSATIONS>";
	CTDVString sConvXML;
	SP.FetchFreshestConversations(sConvXML, iSiteID, iSkip, iShow);
	sXML << sConvXML << "</RECENTCONVERSATIONS></INFO>";
	bool bSuccess = CreateFromXMLText(sXML);
	CXMLTree* pFNode = m_pTree->FindFirstTagName("INFO");
	TDVASSERT(pFNode != NULL, "NULL node returned - couldn't find INFO element");

	if (pFNode != NULL)
	{
		pFNode->SetAttribute("SKIPTO",iSkip);
		pFNode->SetAttribute("COUNT",iShow);
		pFNode->SetAttribute("MODE","conversations");
	}

	// if successful then cache this new objects data
	if (bSuccess)
	{
		CTDVString StringToCache;
		CreateCacheText(&StringToCache);
		CachePutItem("Info", sCacheName, StringToCache);
	}
	return bSuccess;
}

bool CInfo::CreateRecentArticles(int iSiteID, int iSkip, int iShow)
{
	CTDVString sCacheName = "Info_Articles_";
	sCacheName << iSiteID << "_" << iSkip << "_" << iShow << ".txt";

	CTDVString sXML;
	CTDVDateTime dExpires(60*5);		// Make it expire after 5 minutes

	// get the cached version if we can
	if (CacheGetItem("Info", sCacheName, &dExpires, &sXML))
	{
		// make sure object was successfully created from cached text
		if (CreateFromCacheText(sXML))
		{
			UpdateRelativeDates();
			return true;
		}
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	sXML = "<INFO><FRESHESTARTICLES>";
	CTDVString sConvXML;
	SP.FetchFreshestArticles(sConvXML, iSiteID, iSkip, iShow);
	sXML << sConvXML << "</FRESHESTARTICLES></INFO>";
	bool bSuccess = CreateFromXMLText(sXML);
	CXMLTree* pFNode = m_pTree->FindFirstTagName("INFO");
	TDVASSERT(pFNode != NULL, "NULL node returned - couldn't find INFO element");

	if (pFNode != NULL)
	{
		pFNode->SetAttribute("SKIPTO",iSkip);
		pFNode->SetAttribute("COUNT",iShow);
		pFNode->SetAttribute("MODE","articles");
	}

	// if successful then cache this new objects data
	if (bSuccess)
	{
		CTDVString StringToCache;
		CreateCacheText(&StringToCache);
		CachePutItem("Info", sCacheName, StringToCache);
	}
	return bSuccess;

}

bool CInfo::CreateTotalRegUsers()
{
	CTDVString sCacheName = "Info_TotalRegUsers.txt";

	if (!UseCacheFile(sCacheName))
	{
		CTDVString sXML;
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);

		// 37076 users have registered since we launched on 28th April 1999
		sXML << "<INFO><TOTALREGUSERS>";
		sXML << SP.TotalRegisteredUsers();
		sXML << "</TOTALREGUSERS></INFO>";

		bool bSuccess = CreateFromXMLText(sXML);
		TDVASSERT(bSuccess, "CInfo::CreateTotalRegUsers - CreateFromXMLText failed");

		// if successful then cache this new objects data
		if (bSuccess)
		{
			Cache(sCacheName);
		}
		return bSuccess;
	}

	return true;
}


bool CInfo::CreateTotalApprovedEntries(int iSiteID)
{
	CTDVString sCacheName = "Info_TotalApprovedEntries_";
	sCacheName << iSiteID << ".txt";

	if (!UseCacheFile(sCacheName))
	{
		CTDVString sXML;
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);

		sXML << "<INFO><APPROVEDENTRIES>";
		sXML << SP.TotalApprovedEntries(iSiteID);
		sXML << "</APPROVEDENTRIES></INFO>";

		bool bSuccess = CreateFromXMLText(sXML);
		TDVASSERT(bSuccess, "CInfo::CreateTotalApprovedEntries - CreateFromXMLText failed");

		// if successful then cache this new objects data
		if (bSuccess)
		{
			Cache(sCacheName);
		}
		return bSuccess;
	}

	return true;
}

bool CInfo::CreateProlificPosters(int iSiteID)
{
	CTDVString sCacheName = "Info_ProlificPosters_";
	sCacheName << iSiteID << ".txt";

	if (!UseCacheFile(sCacheName))
	{
		CTDVString sXML;

		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);

		sXML << "<INFO><PROLIFICPOSTERS>";

		CTDVString sProlificBlock;
		if (SP.FetchProlificPosters(sProlificBlock, iSiteID))
		{
			sXML << sProlificBlock;
		}
		else
		{
			sXML << "No even remotely prolific posters at the moment :(";
		}
			
		sXML << "</PROLIFICPOSTERS></INFO>";


		bool bSuccess = CreateFromXMLText(sXML);
		TDVASSERT(bSuccess, "CInfo::CreateProlificPosters - CreateFromXMLText failed");

		// if successful then cache this new objects data
		if (bSuccess)
		{
			Cache(sCacheName);
		}
		return bSuccess;
	}

	return true;
}

bool CInfo::CreateEruditePosters(int iSiteID)
{
	CTDVString sCacheName = "Info_EruditePosters_";
	sCacheName << iSiteID << ".txt";

	if (!UseCacheFile(sCacheName))
	{
		CTDVString sXML;

		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);

		sXML << "<INFO><ERUDITEPOSTERS>";

		CTDVString sEruditeBlock;
		if (SP.FetchEruditePosters(sEruditeBlock, iSiteID))
		{
			sXML << sEruditeBlock;
		}
		else
		{
			sXML << "No even remotely erudite posters at the moment :(";
		}
			
		sXML << "</ERUDITEPOSTERS></INFO>";

		bool bSuccess = CreateFromXMLText(sXML);
		TDVASSERT(bSuccess, "CInfo::CreateEruditePosters - CreateFromXMLText failed");

		// if successful then cache this new objects data
		if (bSuccess)
		{
			Cache(sCacheName);
		}
		return bSuccess;
	}

	return true;
}

bool CInfo::CreateBlank()
{
	CTDVString sXML = "<INFO>No specific info requested</INFO>";
	return CreateFromXMLText(sXML);
}

bool CInfo::UseCacheFile(CTDVString& sCacheName)
{
	CTDVString sXML;
	CTDVDateTime dExpires(60*5);		// Make it expire after 5 minutes

	// get the cached version if we can
	if (CacheGetItem("Info", sCacheName, &dExpires, &sXML))
	{
		// make sure object was successfully created from cached text
		if (CreateFromCacheText(sXML))
		{
			UpdateRelativeDates();
			return true;
		}
	}
	return false;
}

void CInfo::Cache(CTDVString& sCacheName)
{
	CTDVString StringToCache;
	CreateCacheText(&StringToCache);
	CachePutItem("Info", sCacheName, StringToCache);
}
