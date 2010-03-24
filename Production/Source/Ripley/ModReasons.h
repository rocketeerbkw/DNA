#pragma once
#include "xmlobject.h"
#include <vector>

class CModReasons :
	public CXMLObject
{
public:
	CModReasons(CInputContext& inputContext);
	virtual ~CModReasons(void);

	bool GetModReasons(int iID, bool bIsModClassID = true);

	bool GetModReasons(std::vector<CTDVString>& vecModReasons, int iModClassID);
	bool AddModReason(int iReasonID, CTDVString sDisplayName, CTDVString sEmailName, int iEditorOnly);

protected:
	std::vector<CTDVString> m_vecModReasons;
};
