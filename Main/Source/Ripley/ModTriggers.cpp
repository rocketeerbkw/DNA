#include "stdafx.h"
#include "ModTriggers.h"

CModTriggers::CModTriggers(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CModTriggers::~CModTriggers(void)
{
}

bool CModTriggers::GetModTriggers()
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CTDVString sModTriggers;
	CDBXMLBuilder xml;

	xml.Initialise(&sModTriggers, &SP);

	//SP.GetModTriggers();

	xml.OpenTag("MOD-TRIGGERS");
	while (!SP.IsEOF())
	{
		xml.OpenTag("MOD-TRIGGER", true);
		xml.DBAddIntAttribute("TRIGGERID","TRIGGERID", false, false);
		xml.DBAddAttribute("TRIGGERTYPE", "TRIGGERTYPE", false, false, true);
		xml.CloseTag("MOD-TRIGGER");		
		SP.MoveNext();
	}
	xml.CloseTag("MOD-TRIGGERS");

	return CreateFromXMLText(sModTriggers);
}