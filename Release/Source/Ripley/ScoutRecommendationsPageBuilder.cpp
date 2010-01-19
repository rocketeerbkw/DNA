// ScoutRecommendationsPageBuilder.cpp: implementation of the CScoutRecommendationsPageBuilder class.
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
#include "ScoutRecommendationsPageBuilder.h"
#include "ScoutRecommendationsForm.h"
#include "WholePage.h"
#include "PageUI.h"
#include "ArticleList.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CScoutRecommendationsPageBuilder::CScoutRecommendationsPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CScoutRecommendationsPageBuilder object.

*********************************************************************************/

CScoutRecommendationsPageBuilder::CScoutRecommendationsPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	// no further construction required
}

/*********************************************************************************

	CScoutRecommendationsPageBuilder::~CScoutRecommendationsPageBuilder()

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CScoutRecommendationsPageBuilder::~CScoutRecommendationsPageBuilder()
{
}

/*********************************************************************************

	CWholePage* CScoutRecommendationsPageBuilder::Build()

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the scout recommendations page, and processes
				requests to accept or reject scout recommendations.

*********************************************************************************/

bool CScoutRecommendationsPageBuilder::Build(CWholePage* pWholePage)
{
	CUser*		pViewer = NULL;
	bool		bSuccess = true;

	CArticleList Recommendations(m_InputContext);

	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "SCOUT-RECOMMENDATIONS",true);
	// do an error page if not an editor or a scout
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsScout()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot allocate recommended entries to sub editors unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// create the list of scout recommendations
		bSuccess = bSuccess && Recommendations.CreateUndecidedRecommendationsList();
		// and add it into the page inside a suitable tag
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<UNDECIDED-RECOMMENDATIONS/>");
		bSuccess = bSuccess && pWholePage->AddInside("UNDECIDED-RECOMMENDATIONS", &Recommendations);
	}
	TDVASSERT(bSuccess, "CSubEditorAllocationPageBuilder::Build() failed");
	return bSuccess;
}

#endif // _ADMIN_VERSION
