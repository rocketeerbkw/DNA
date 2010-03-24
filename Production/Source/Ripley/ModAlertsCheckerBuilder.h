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

#if defined (_ADMIN_VERSION)

#include "XMLBuilder.h"

class CInputContext;
class CTDVString;
class CWholePage;

/*
class CModAlertsCheckerBuilder
Author:		Igor Loboda
Created:	15/07/2005
Inherits:	CXMLBuilder
Purpose:	Builds the XML for the alerts checker page
*/

class CModAlertsCheckerBuilder : public CXMLBuilder  
{
	public:
		CModAlertsCheckerBuilder(CInputContext& inputContext);
		bool Build(CWholePage* pPage);

	protected:
		bool GetComplaintsStatsXml(CTDVString& sXml);
};

#endif // _ADMIN_VERSION
