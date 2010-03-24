// RecommendEntryPageBuilder.cpp: implementation of the CRecommendEntryPageBuilder class.
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
#include "RecommendEntryPageBuilder.h"
#include "RecommendEntryForm.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CRecommendEntryPageBuilder::CRecommendEntryPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CRecommendEntryPageBuilder object.

*********************************************************************************/

CRecommendEntryPageBuilder::CRecommendEntryPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	// no further construction required
}

/*********************************************************************************

	CRecommendEntryPageBuilder::~CRecommendEntryPageBuilder()
																			 ,
	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CRecommendEntryPageBuilder::~CRecommendEntryPageBuilder()
{
	// no explicit destruction required
}

/*********************************************************************************

	CWholePage* CRecommendEntryPageBuilder::Build()

	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the Recommend An Entry page for Scouts.
				This is a simple page allowing a scout to suggest and entry for
				inclusion in the edited guide, along with their comments as to
				why it should be included.

*********************************************************************************/

bool CRecommendEntryPageBuilder::Build(CWholePage* pWholePage)
{
	CUser*					pViewer = NULL;		// the viewing user xml object
	int						ih2g2ID = 0;		// ID of the entry to recommend
	CTDVString				sComments = "";		// Scouts comments
	CTDVString				sCommand;
	CTDVString				sMode;
	bool					bSuccess = true;

	CRecommendEntryForm	Form(m_InputContext);

	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "RECOMMEND-ENTRY",true);
	// do an error page if non-registered user, or a user who is neither
	// a scout nor an editor
	// otherwise proceed with the recommendation page
	if (pViewer == NULL || !pViewer->GetIsEditor() && !pViewer->GetIsScout())
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-ABLE-TO-RECOMMEND'>You cannot recommend Guide Entries unless you are registered and either an Editor or a Scout.</ERROR>");
	}
	else
	{
		// if there are h2g2ID and comments parameters then get them
		ih2g2ID = m_InputContext.GetParamInt("h2g2id");
		m_InputContext.GetParamString("comments", sComments);
		// is there a cmd parameter and if so what is it?
		if (m_InputContext.ParamExists("Submit"))
		{
			sCommand = "Submit";
		}
		else
		{
			// if not a submit then default to 'Fetch'
			sCommand = "Fetch";
		}
		// produce an appropriate object depending on the command
		if (sCommand.CompareText("submit"))
		{
			// this will submit the recommendation if it is a valid one, or
			// return some error XML if not
			bSuccess = bSuccess && Form.SubmitRecommendation(pViewer, ih2g2ID, sComments);
		}
		else
		{
			// assume command is a view command otherwise
			if (ih2g2ID > 0)
			{
				// CreateFromh2g2ID will return an error code in the XML if the h2g2ID
				// is not a valid one
				bSuccess = bSuccess && Form.CreateFromh2g2ID(pViewer, ih2g2ID, sComments);
			}
			else
			{
				bSuccess = bSuccess && Form.CreateBlankForm(pViewer);
			}
		}
		// if all okay then insert the form XML into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", &Form);
		// now get the display mode parameter, if any
		m_InputContext.GetParamString("mode", sMode);
		if (sMode.GetLength() > 0)
		{
			bSuccess = bSuccess && pWholePage->SetAttribute("H2G2", "MODE", sMode);
		}
	}
	TDVASSERT(bSuccess, "CRecommendEntryPageBuilder::Build() failed");
	return bSuccess;
}
