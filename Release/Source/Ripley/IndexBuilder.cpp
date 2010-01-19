// IndexBuilder.cpp: implementation of the CIndexBuilder class.
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
#include "IndexBuilder.h"
#include "pageUI.h"
#include "Index.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CIndex::CIndex(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for our the Index Building class

*********************************************************************************/

CIndexBuilder::CIndexBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

/*********************************************************************************

	CIndexBuilder::~CIndexBuilder()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CIndexBuilder class. Functionality due when we start allocating memory

*********************************************************************************/

CIndexBuilder::~CIndexBuilder()
{

}

/*********************************************************************************

	CWholePage* CIndexBuilder::Build()

	Author:		Oscar Gillespie
	Created:	14/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes a whole XML page holding the Index of articles on the guide

*********************************************************************************/

bool CIndexBuilder::Build(CWholePage* pPageXML)
{
	CIndex Index(m_InputContext);

	bool bSuccess = true;

	// first create the page root into which to insert the article
	bSuccess = InitPage(pPageXML, "INDEX",true);

	CTDVString sLetter = "";
	if (bSuccess)
	{

		int iShow = m_InputContext.GetParamInt("show");
		if (iShow == 0)
		{
			iShow = 50;
		}
		else if (iShow > 400)
		{
			iShow = 400;
		}

		int iSkip = m_InputContext.GetParamInt("skip");
		
		bool bShowApproved = (m_InputContext.ParamExists("official"));

		bool bShowSubmitted = (m_InputContext.ParamExists("submitted"));

		bool bShowUnapproved = (m_InputContext.ParamExists("user"));

		if ( ! (bShowApproved || bShowSubmitted || bShowUnapproved))
		{
			bShowApproved = true;
		}

		// Get the Type Filter info from the URL if there is any
		const int iTypesCount = m_InputContext.GetParamCount("Type");
		int iTypesList[10];
		for (int i = 0; i < iTypesCount && i < 9; i++)
		{
			iTypesList[i] = m_InputContext.GetParamInt("type",i);
		}

		// Get the group filter info from the url if there is any
		CTDVString sGroupFilter;
		m_InputContext.GetParamString("Group",sGroupFilter);

		// Check to see if we are trying to order the results
		CTDVString sOrderBy;
		m_InputContext.GetParamString("OrderBy",sOrderBy);
		
		// find out which letter they want to look at in the index (from the url)
		bool bGotLetter = m_InputContext.GetParamString("let", sLetter);
		if (bGotLetter)
		{
			// Check to see if we're trying to look for all indexed articles
			if (sLetter.CompareText("all"))
			{
				// Empty the string as this means everything!
				sLetter.Empty();
			}
			else
			{
				// only use the first digit of the parameter they gave us
				sLetter = sLetter.Left(1);
			}

			// initialise the Index object with this letter
			bSuccess = Index.Initialise(sLetter, m_InputContext.GetSiteID(), bShowApproved, bShowSubmitted, bShowUnapproved, iShow, iSkip, sGroupFilter, iTypesCount, iTypesList, sOrderBy);
		}
		else
		{
			// if they didn't specify a letter then give them the default index page ('a' for now)
			bSuccess = Index.Initialise("a", m_InputContext.GetSiteID(), bShowApproved, bShowSubmitted, bShowUnapproved, iShow, iSkip, sGroupFilter, iTypesCount, iTypesList, sOrderBy);
		}
	}

	if (bSuccess)
	{
		// add the Index block of XML inside the PageXML
		bSuccess = pPageXML->AddInside("H2G2", &Index);
	}

	if (bSuccess)
	{
		// tell the page XML what kind of page it is (it would have a hard time working it out otherwise)
		pPageXML->SetPageType("INDEX");
	}

	return bSuccess;
}