#include "stdafx.h"
#include ".\usertags.h"
#include ".\storedprocedure.h"

CUserTags::CUserTags(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CUserTags::~CUserTags(void)
{
}

bool CUserTags::GetUserTags(void)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	SP.GetUserTags();

	CTDVString sUserTags;
	CDBXMLBuilder xml;
	xml.Initialise(&sUserTags, &SP);

	xml.OpenTag("USER-TAGS");
	while (!SP.IsEOF())
	{
		xml.OpenTag("USER-TAG", true);
		xml.DBAddIntAttribute("UserTagID", "ID", false, true);
		xml.DBAddTag("UserTagDescription", "DESCRIPTION");
		xml.CloseTag("USER-TAG");
		SP.MoveNext();
	}	
	xml.CloseTag("USER-TAGS");
	return CreateFromXMLText(sUserTags);
}
