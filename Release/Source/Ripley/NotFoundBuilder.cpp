// NotFoundBuilder.cpp: implementation of the CNotFoundBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "NotFoundBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNotFoundBuilder::CNotFoundBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CNotFoundBuilder::~CNotFoundBuilder()
{

}

bool CNotFoundBuilder::Build(CWholePage* pPage)
{
	if (!InitPage(pPage,"NOTFOUND",true))
	{
		return false;
	}
	CTDVString sName;
	m_InputContext.GetParamString("name", sName);
	CXMLObject::EscapeXMLText(&sName);
	CTDVString sXML = "<ARTICLENAME>";
	sXML << sName << "</ARTICLENAME>";
	pPage->AddInside("H2G2", sXML);
	return true;
}
