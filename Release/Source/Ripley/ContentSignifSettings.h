// ContentSignifSettings.h: interface for the CContentSignifSettings class.
//
//////////////////////////////////////////////////////////////////////

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

#include "XMLObject.h"

class CContentSignifSettings : public CXMLObject  
{
public:
	CContentSignifSettings(CInputContext& inputContext);
	virtual ~CContentSignifSettings();

	bool GetSiteSpecificContentSignifSettings(int p_iSiteID, CTDVString& xmlString);
	bool SetSiteSpecificContentSignifSettings(int piSiteID, CTDVString p_param1, CTDVString p_param2, CTDVString p_param3, CTDVString p_param4, CTDVString p_param5, CTDVString p_param6, CTDVString p_param7, CTDVString p_param8, CTDVString p_param9, CTDVString p_param10, CTDVString p_param11, CTDVString p_param12, CTDVString p_param13, CTDVString p_param14, CTDVString p_param15, CTDVString p_param16, CTDVString p_param17, CTDVString p_param18, CTDVString p_param19, CTDVString p_param20, CTDVString p_param21, CTDVString p_param22, CTDVString p_param23, CTDVString p_param24, CTDVString p_param25, CTDVString p_param26, CTDVString p_param27, CTDVString p_param28, CTDVString p_param29, CTDVString p_param30, CTDVString p_param31, CTDVString p_param32, CTDVString p_param33, CTDVString p_param34, CTDVString p_param35); 
	bool DecrementContentSignif(int p_iSiteID);
};