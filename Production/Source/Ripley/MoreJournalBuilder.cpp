// MoreJournalBuilder.cpp: implementation of the CMoreJournalBuilder class.
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
#include "Forum.h"
#include "PageUI.h"
#include "tdvassert.h"
#include "MoreJournalBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMoreJournalBuilder::CMoreJournalBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CMoreJournalBuilder::~CMoreJournalBuilder()
{

}

bool CMoreJournalBuilder::Build(CWholePage* pPage)
{
	int iJournal = m_InputContext.GetParamInt("journal");
	int iUserID = m_InputContext.GetParamInt("userid");
	int iNumShow = m_InputContext.GetParamInt("show");
	if (iNumShow == 0)
	{
		iNumShow = 8;
	}
	int iNumSkipped = m_InputContext.GetParamInt("skip");
	if (iNumSkipped <0)
	{
		iNumSkipped = 0;
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	
	// all the XML objects we need to build the page
	CForum Forum(m_InputContext);

	// Now initialise those objects that need it.
	bool bPageSuccess = false;
	bPageSuccess = InitPage(pPage, "JOURNAL",true);
	TDVASSERT(bPageSuccess, "Failed to initialise WholePage in MoreJournalBuilder");
	bool bSuccess = bPageSuccess;
	
	// get the journal posts we want from the forum
	bSuccess = bSuccess && Forum.GetJournal(pViewingUser, iJournal, iNumShow, iNumSkipped);

	// Put in the wrapping <JOURNAL> tag which has the user ID in it
	CTDVString sXML = "<JOURNAL USERID='";
	sXML << iUserID << "'/>";
	bSuccess = bSuccess && pPage->AddInside("H2G2", sXML);
	// Insert the forum into the page
	bSuccess = bSuccess && pPage->AddInside("JOURNAL",&Forum);

	CForum Journal(m_InputContext);
	bSuccess = bSuccess && Journal.GetTitle(iJournal, 0, false);
	bSuccess = bSuccess && pPage->AddInside("H2G2",&Journal);

	// OK, I think that's us done.
	return bPageSuccess;
}
