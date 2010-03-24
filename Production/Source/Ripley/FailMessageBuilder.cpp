// FailMessageBuilder.cpp: implementation of the CFailMessageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "FailMessage.h"
#include "FailMessageBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CFailMessageBuilder::CFailMessageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CFailMessageBuilder::~CFailMessageBuilder()
{

}

bool CFailMessageBuilder::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "FAILMESSAGE", true);
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pPageXML->SetError("<ERROR TYPE='NOT-EDITOR'>You cannot fail a message unless you are logged in as an Editor.</ERROR>");
		return true;
	}

	CFailMessage FailMessage(m_InputContext);
	FailMessage.Process(m_InputContext);

	if (FailMessage.ErrorReported())
	{
		pPageXML->AddInside("H2G2",FailMessage.GetLastErrorAsXMLString());
	}

	pPageXML->AddInside("H2G2",&FailMessage);

		// Check for the redirect param
	if (m_InputContext.ParamExists("redirect"))
	{
		// Get the redirect
		CTDVString sRedirect;
		m_InputContext.GetParamString("redirect",sRedirect);

		// Make sure we unescape it!
		sRedirect.Replace("%26","&");
		sRedirect.Replace("%3F","?");

		// Add the redirect to the page
		pPageXML->Redirect(sRedirect);
	}


	return true;
}
