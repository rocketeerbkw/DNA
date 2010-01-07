#pragma once
#include "xmlbuilder.h"

class CModeratorManagementBuilder :
	public CXMLBuilder
	{
	public:
		CModeratorManagementBuilder(CInputContext& inputContext);
		virtual ~CModeratorManagementBuilder(void);
		virtual bool Build(CWholePage* pPage);
		bool OpenModerator(CDBXMLBuilder& xml, CStoredProcedure& SP, int& iCurUserID, int& iCurClassID, int& iCurSiteID, CDBXMLBuilder& ClassXML, CDBXMLBuilder& SiteXML);
		bool CloseModerator(CDBXMLBuilder& xml, CStoredProcedure& SP, CDBXMLBuilder& ClassXML, CDBXMLBuilder& SiteXML);
	};
