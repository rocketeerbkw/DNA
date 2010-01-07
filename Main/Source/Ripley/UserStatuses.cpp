#include "stdafx.h"
#include ".\userstatuses.h"

CUserStatuses::CUserStatuses(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CUserStatuses::~CUserStatuses(void)
{
}

bool CUserStatuses::GetUserStatuses(void)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CTDVString sUserStatuses;
	CDBXMLBuilder xml;

	xml.Initialise(&sUserStatuses, &SP);

	SP.GetUserStatuses();

	xml.OpenTag("USER-STATUSES");
	while(!SP.IsEOF())
	{
		xml.OpenTag("USER-STATUS", true);
		xml.DBAddIntAttribute("UserStatusID", "UserStatusID", false, false);
		xml.DBAddAttribute("UserStatusDescription", "UserStatusDescription", false, false, true);
		xml.CloseTag("USER-STATUS");
		SP.MoveNext();
	}
	xml.CloseTag("USER-STATUSES");

	return CreateFromXMLText(sUserStatuses);
}

CTDVString CUserStatuses::GetDescription( int ModStatusId )
{
    switch ( ModStatusId )
    {
    case STANDARD:
        return "STANDARD";
    case PREMODERATED:
        return "PREMODERATED";
    case POSTMODERATED:
        return "POSTMODERATED";
    case SENDFORREVIEW:
        return "SENDFORREVIEW";
    case RESTRICTED:
        return "RESTRICTED";
    default:
        return "";
    }

}
