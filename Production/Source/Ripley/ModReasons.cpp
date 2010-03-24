#include "stdafx.h"
#include ".\modreasons.h"

CModReasons::CModReasons(CInputContext& inputContext) :CXMLObject(inputContext)
{
}

CModReasons::~CModReasons(void)
{
}


bool CModReasons::GetModReasons(int iID, bool bIsModClassID /* = true */)
{
	//if bIsModClassID is false then it means siteID
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CTDVString sUserStatuses;
	CDBXMLBuilder xml;

	xml.Initialise(&sUserStatuses, &SP);

	SP.GetModReasons(iID, bIsModClassID);

	xml.OpenTag("MOD-REASONS");
	while(!SP.IsEOF())
	{
		xml.OpenTag("MOD-REASON", true);
		xml.DBAddIntAttribute("ReasonID", "ReasonID", false, false);
		CTDVString sEmailName;
		SP.GetField("EmailName", sEmailName);
		m_vecModReasons.push_back(sEmailName);
		xml.DBAddAttribute("DisplayName", "DisplayName", false, false, false);
		xml.DBAddAttribute("EmailName", "EmailName", false, false, false);
		xml.DBAddAttribute("EditorsOnly", "EditorsOnly", false, false, true);
		xml.CloseTag("MOD-REASON");
		SP.MoveNext();
	}
	xml.CloseTag("MOD-REASONS");

	return CreateFromXMLText(sUserStatuses);
}

bool CModReasons::GetModReasons(std::vector<CTDVString>& vecModReasons, int iModClassID)
{
	GetModReasons(iModClassID);
	vecModReasons = m_vecModReasons;
	return true;
}


bool CModReasons::AddModReason(int iReasonID, CTDVString sDisplayName, CTDVString sEmailName, int iEditorOnly)
{
	//TODO: Add code to call SP to add new ModReason
	//Check ModReasons table seems it's not using identity column
	return true;
}