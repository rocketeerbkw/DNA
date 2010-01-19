// MediaAssetBuilder.cpp: implementation of the CMediaAssetBuilder class.
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
#include "tdvassert.h"
#include "PageUI.h"
#include "MediaAssetBuilder.h"
#include "MediaAsset.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMediaAssetBuilder::CMediaAssetBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CMediaAssetBuilder::~CMediaAssetBuilder(void)
{
}

/*********************************************************************************

	CWholePage* CMediaAssetBuilder::Build()

	Author:		Steven Francis
	Created:	11/10/2005
	Inputs:		-
	Outputs:	-
	Returns:	CWholePage containing the page the output.
	Purpose:	

				MEDIAASSET Page Type

				The XML output can look like this:
				<H2G2>
				...
					<MEDIAASSETBUILDER>
						<MEDIAASSETINFO>
							<ACTION></ACTION>
							<ID></ID>
							<MULTI-STAGE>
							... Multi stage required and element fields required for multi step
							</MULTI-STAGE>
							<MEDIAASSET>
								<MEDIAASSETID></MEDIAASSETID>
								<SITEID></SITEID>
								<CAPTION></CAPTION>
								<FILENAME></FILENAME>
								<MIMETYPE></MIMETYPE>
								<CONTENTTYPE></CONTENTTYPE>
								<
								.... Extra extensible fields
								>
								<OWNERID></OWNERID>
								<DATECREATED></DATECREATED>
								<LASTUPDATED></LASTUPDATED>
							</MEDIAASSET>
						</MEDIAASSETINFO>
					</MEDIAASSETBUILDER>
				...
				</H2G2>

*********************************************************************************/
bool CMediaAssetBuilder::Build(CWholePage* pPage)
{
	bool bOK = false;

	// Init page
	if (!InitPage(pPage, "MEDIAASSET", true))
	{
		TDVASSERT(false,"CMediaAssetBuilder::Build() InitPage failed");
		return false;
	}

	CMediaAsset MediaAsset(m_InputContext);

	if (m_InputContext.ParamExists("action") || m_InputContext.ParamExists("id"))
	{
		bOK = MediaAsset.ProcessAction();
	}
	else
	{
		bOK = true;
	}

	pPage->AddInside("H2G2","<MEDIAASSETBUILDER/>");

	pPage->AddInside("MEDIAASSETBUILDER", &MediaAsset);

	if (MediaAsset.ErrorReported())
	{
		return pPage->AddInside("H2G2", MediaAsset.GetLastErrorAsXMLString());

	}

	return bOK;
}

