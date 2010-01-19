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
#include "ImageLibraryBuilder.h"
#include "UploadedImage.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CImageLibraryBuilder::CImageLibraryBuilder(CInputContext& inputContext)
	: 
	CXMLBuilder(inputContext),
	m_ImageLibrary(inputContext)
{
}

CImageLibraryBuilder::~CImageLibraryBuilder()
{

}

/*********************************************************************************

	CWholePage* CImageLibraryBuilder::Build()

	Author:		Dharmesh Raithatha
	Created:	5/29/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CImageLibraryBuilder::Build(CWholePage* pPage)
{
	if (!InitPage(pPage,"IMAGELIBRARY", true))
	{
		return false;
	}

	ProcessParams(pPage);

	return true;
}


/*********************************************************************************

	bool CImageLibraryBuilder::ProcessParams()

	Author:		Mark Neves
	Created:	12/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/


void CImageLibraryBuilder::ProcessParams(CWholePage* pPage)
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (!pViewingUser)
	{
		ErrorMessage(pPage, "NoUser", "Tried to perform an action with no user logged in");
		return;
	}

	CTDVString sAction;
	if (!m_InputContext.GetParamString("action", sAction))
	{
		return;
	}

	if (sAction.CompareText("upload"))
	{
		CUploadedImage image(m_InputContext);
		if (m_ImageLibrary.Upload("file", image) != CImageLibrary::ERR_OK)
		{
			ErrorMessage(pPage, "Upload failed", "");
			return;
		}

		return;
	}

	return;
}

void CImageLibraryBuilder::ErrorMessage(CWholePage* pPage, const TDVCHAR* sType, 
	const TDVCHAR* sMsg)
{
	InitPage(pPage, "IMAGELIBRARY", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	pPage->AddInside("H2G2", sError);
}