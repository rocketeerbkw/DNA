// ScoutRecommendationsForm.cpp: implementation of the CScoutRecommendationsForm class.
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
#include "ScoutRecommendationsForm.h"
#include "InputContext.h"
#include "GuideEntry.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CScoutRecommendationsForm::CScoutRecommendationsForm(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
	// no further construction required
}

CScoutRecommendationsForm::~CScoutRecommendationsForm()
{
	// no further destruction required
}

/*********************************************************************************

	bool CScoutRecommendationsForm::CreateBlankForm()

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the XML for a blank scout recommendations form.

*********************************************************************************/

bool CScoutRecommendationsForm::CreateBlankForm()
{
	TDVASSERT(m_pTree == NULL, "CScoutRecommendationsForm::CreateBlankForm() called with non-NULL m_pTree");

	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// build the XML for all the basic elements required
	CTDVString	sFormXML = "<SCOUT-RECOMMENDATIONS-FORM>";

	sFormXML << "<H2G2ID/>";
	sFormXML << "<SUBJECT/>";
	sFormXML << "<BODY/>";
	sFormXML << "<COMMENTS/>";
	sFormXML << "<AUTHOR/>";
	sFormXML << "<SCOUT/>";
	sFormXML << "<FUNCTIONS/>";
	sFormXML << "</SCOUT-RECOMMENDATIONS-FORM>";

	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

#endif // _ADMIN_VERSION
