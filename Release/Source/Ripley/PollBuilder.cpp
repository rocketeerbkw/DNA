// Implementation for CPollBuilder
// James Pullicino
// Jan 05

#include "stdafx.h"
#include "TDVString.h"
#include "TDVAssert.h"
#include "User.h"

#include "PollBuilder.h"
#include "Poll.h"
#include "Polls.h"


/*********************************************************************************

	CPollBuilder::CPollBuilder(CInputContext& inputContext)

		Author:		James Pullicino
        Created:	11/01/2005
        Inputs:		CInputContext&
        Outputs:	-
        Returns:	-
        Purpose:	-
*********************************************************************************/

CPollBuilder::CPollBuilder(CInputContext& inputContext)
: CXMLBuilder(inputContext)
{
	
}

CPollBuilder::~CPollBuilder()
{

}


/*********************************************************************************

	bool CPollBuilder::Build(CWholePage* pPage)

		Author:		James Pullicino
        Created:	12/01/2005
        
		URL Inputs: pollid - ID of poll
					other 

        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CPollBuilder::Build(CWholePage* pPage)
{
	// Init page
	if (!InitPage(pPage, "POLL", true))
	{
		TDVASSERT(false,"CPollBuilder::Build() InitPage failed");
		return false;
	}

	// Get poll id
	int nPollID = m_InputContext.GetParamInt("pollid");
	
	// Get poll object. 
	CPolls polls(m_InputContext);
	CPoll *pPoll = polls.GetPoll(nPollID);
	
	// Auto delete pPoll
	CAutoDeletePtr<CPoll> autoPoll(pPoll);
	
	if(!pPoll)
	{
		// CPolls contains error element. Insert it into page
		if(!pPage->AddInside("H2G2", &polls))
		{
			TDVASSERT(false, "CPollBuilder::Build AddInside failed");
			return false;
		}

		return true;
	}

	// Let poll process URL input
	CTDVString sRedirectURL;
	if(!pPoll->ProcessParamsFromBuilder(sRedirectURL))
	{
		TDVASSERT(false, "CPollBuilder::Build() ProcessParamsFromBuilder failed");
	}

	// Check if redirect is wanted
	if(!sRedirectURL.IsEmpty())
	{
		// Redirect
		if(!pPage->Redirect(sRedirectURL))
		{
			TDVASSERT(false, "CPollBuilder::Build pPage->Redirect failed");
			return false;
		}
	}
	else // No Redirect
	{
		// Add xml results
		if(!pPage->AddInside("H2G2", pPoll))
		{
			TDVASSERT(false, "CPollBuilder::Build AddInside failed");
			return false;
		}
	}

	return true;
}

