// CUploadPageBuilder.cpp: implementation of the CUploadPageBuilder class.
//

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
#include "Upload.h"
#include "UploadPageBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CUploadPageBuilder::CUploadPageBuilder(CInputContext& inputContext)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CUploadPageBuilder::CUploadPageBuilder(CInputContext& inputContext)
  : CXMLBuilder(inputContext)
{

}

/*********************************************************************************

	CUploadPageBuilder::~CUploadPageBuilder()

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CUploadPageBuilder::~CUploadPageBuilder()
{

}


/*********************************************************************************

	CWholePage* CUploadPageBuilder::Build()

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CUploadPageBuilder::Build(CWholePage* pPageXML)
{
	bool bSuccess = true;
	bSuccess = InitPage(pPageXML, "UPLOAD",true);
	if (!bSuccess)
	{
		return false;
	}

	CUpload Upload(m_InputContext);

	CTDVString sAction;
	m_InputContext.GetParamString("action",sAction);

	bool bOK = false;
	int iErrorCode = CUpload::ERRORCODE_UNKOWNCOMMAND;

	if (sAction.CompareText("new"))
	{
		int iTeamID,iUserID,iFileType;
		CTDVString sTeamID,sUserID,sFileName,sFileType,sEnc;

		iTeamID   = m_InputContext.GetParamInt("teamid");
		iUserID   = m_InputContext.GetParamInt("userid");
		iFileType = m_InputContext.GetParamInt("filetype");

		m_InputContext.GetParamString("filename",sFileName);
		m_InputContext.GetParamString("enc",sEnc);

		int iUploadID = 0;
		bOK = Upload.Add(iTeamID,iUserID,sFileName,iFileType,iUploadID);
		if (!bOK)
		{
			iErrorCode = CUpload::ERRORCODE_NEWFAILED;
		}
	}

	CTDVString sXML = "<UPLOAD>";

	sXML << "<ACTION>" << sAction << "</ACTION>";
	sXML << "<RESULT>" << bOK     << "</RESULT>";
	if (!bOK)
	{
		sXML << "<ERRORCODE>" << iErrorCode << "</ERRORCODE>";
	}

	sXML << "</UPLOAD>";
	pPageXML->AddInside("H2G2",sXML);

	return true;
}