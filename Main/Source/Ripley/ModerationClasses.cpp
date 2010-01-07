#include "stdafx.h"
#include ".\moderationclasses.h"

CModerationClasses::CModerationClasses(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CModerationClasses::~CModerationClasses(void)
{
}


bool CModerationClasses::GetModerationClasses(void)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.GetModerationClassList();
	CTDVString sClassXML;
	CDBXMLBuilder classbuilder;
	classbuilder.Initialise(&sClassXML, &SP);
	classbuilder.OpenTag("MODERATION-CLASSES");
	while (!SP.IsEOF())
	{
		classbuilder.OpenTag("MODERATION-CLASS", true);
		classbuilder.DBAddIntAttribute("ModClassID", "CLASSID", false, true);
		classbuilder.DBAddTag("Name", "NAME", false, true);
		classbuilder.DBAddTag("Description", "DESCRIPTION", false, true);
		classbuilder.CloseTag("MODERATION-CLASS");
		SP.MoveNext();
	}
	classbuilder.CloseTag("MODERATION-CLASSES");
	return CreateFromXMLText(sClassXML);
}
