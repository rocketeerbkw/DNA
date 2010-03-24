// WhosOnlineBuilder.cpp: implementation of the CWhosOnlineBuilder class.
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
#include "WhosOnlineBuilder.h"
#include "WhosOnlineObject.h"
#include "tdvassert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CWhosOnlineBuilder::CWhosOnlineBuilder(CInputContext& inputContext)

	Author:		Oscar Gillespie
	Created:	08/03/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CArticlePageBuilder object.

*********************************************************************************/

CWhosOnlineBuilder::CWhosOnlineBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
// no further construction required
}

/*********************************************************************************

	CWhosOnlineBuilder::~CWhosOnlineBuilder()

	Author:		Oscar Gillespie
	Created:	08/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated.
				We don't use any memory in CWhosOnlineBuilder yet so the destructor does
				sod all. The base class will zap the memory it used.

*********************************************************************************/

CWhosOnlineBuilder::~CWhosOnlineBuilder()
{
// no explicit destruction required
}

/*********************************************************************************

	CWholePage* CWhosOnlineBuilder::Build()

	Author:		Oscar Gillespie
	Created:	08/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWhosOnlinePage containing the entire XML for the article page.
	Purpose:	Construct a whos online page... basically a list of users that are online

*********************************************************************************/

bool CWhosOnlineBuilder::Build(CWholePage* pPageXML)
{
	CWhosOnlineObject WhosOnlineObject(m_InputContext); // the real xml object to contain the xml which says whos online

	
	bool bSuccess = true; // success tracking boolean variable
	bSuccess = InitPage(pPageXML, "ONLINE",false,false);

	if (bSuccess)
	{
		// initialise the whos online object
		CTDVString sOrderBy = "none";

		if (m_InputContext.ParamExists("orderby"))
		{
			m_InputContext.GetParamString("orderby", sOrderBy);
		}

		bool bCurrentSiteOnly = false;
		if ( m_InputContext.GetParamInt("thissite",0) == 1 )
		{
			bCurrentSiteOnly = true;
		}
		bSuccess = WhosOnlineObject.Initialise(sOrderBy, m_InputContext.GetSiteID(),bCurrentSiteOnly );
	}
	// if all still well then add the whosonlineobject xml inside the H2G2 tag
	if (bSuccess)
	{
		bSuccess = pPageXML->AddInside("H2G2", &WhosOnlineObject);
	}

	// finally if everything worked then return the page that was built
	return bSuccess;
}