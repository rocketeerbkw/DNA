// ContentSignifSettings.cpp: implementation of the CContentSignifSettings class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
//#include "User.h"
#include "ContentSignifSettings.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CContentSignifSettings::CContentSignifSettings(CInputContext& inputContext)
:CXMLObject(inputContext)
{
}
CContentSignifSettings::~CContentSignifSettings()
{

}

/*********************************************************************************

	bool CContentSignifSettings::GetSiteSpecificContentSignifSettings(int p_iSiteID, CTDVString& p_sxml)

		Author:		James Conway
        Created:	18/04/2005
        Inputs:		p_iSiteID (SiteID you want ContentSignifSettings for) and p_xmlString by reference.
        Outputs:	-
        Returns:	success boolean
        Purpose:	Gets site specific ContentSignif settings and returns them in p_sXML

*********************************************************************************/
bool CContentSignifSettings::GetSiteSpecificContentSignifSettings(int p_iSiteID, CTDVString& p_xmlString) 
{
	CStoredProcedure SP;
	bool bSuccess;
	CTDVString sActionDesc;
	CTDVString sItemDesc;
	CTDVString sSettingType;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CContentSignifSettings::GetSiteSpecificContentSignifSettings", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}
	
	bSuccess = SP.GetSiteSpecificContentSignifSettings(p_iSiteID);

	p_xmlString << "<CONTENTSIGNIFSETTINGS>";

	while(!SP.IsEOF())
	{
		SP.GetField("ACTIONDESC", sActionDesc);
		SP.GetField("ITEMDESC", sItemDesc);
		SP.GetField("SETTINGTYPE", sSettingType);
	
		p_xmlString << "<SETTING TYPE='" << sSettingType << "'>";

		p_xmlString << "<ACTION>"; 
		p_xmlString << "<ID>" << SP.GetIntField("ACTIONID") << "</ID>";
		p_xmlString << "<DESCRIPTION>" << sActionDesc << "</DESCRIPTION>";
		p_xmlString << "</ACTION>"; 

		p_xmlString << "<ITEM>"; 
		p_xmlString << "<ID>" << SP.GetIntField("ITEMID")<< "</ID>";
		p_xmlString << "<DESCRIPTION>" << sItemDesc << "</DESCRIPTION>";
		p_xmlString << "</ITEM>"; 

		p_xmlString << "<VALUE>" << SP.GetIntField("VALUE")<< "</VALUE>";

		p_xmlString << "</SETTING>";

		SP.MoveNext();
	}

	p_xmlString << "</CONTENTSIGNIFSETTINGS>";

	return bSuccess;
}

/*********************************************************************************

	bool CContentSignifSettings::SetSiteSpecificContentSignifSettings(int piSiteID, CTDVString p_param1, CTDVString p_param2, CTDVString p_param3, CTDVString p_param4, CTDVString p_param5, CTDVString p_param6, CTDVString p_param7, CTDVString p_param8, CTDVString p_param9, CTDVString p_param10, CTDVString p_param11, CTDVString p_param12, CTDVString p_param13, CTDVString p_param14, CTDVString p_param15, CTDVString p_param16, CTDVString p_param17, CTDVString p_param18, CTDVString p_param19, CTDVString p_param20, CTDVString p_param21, CTDVString p_param22, CTDVString p_param23, CTDVString p_param24, CTDVString p_param25, CTDVString p_param26, CTDVString p_param27, CTDVString p_param28, CTDVString p_param29, CTDVString p_param30, CTDVString p_param31, CTDVString p_param32, CTDVString p_param33, CTDVString p_param34, CTDVString p_param35)

		Author:		James Conway
        Created:	18/04/2005
        Inputs:		p_iSiteID (SiteID you want ContentSignifSettings for) and increment and decrement values for the site. 
        Outputs:	-
        Returns:	success boolean
        Purpose:	Updates site's ContentSignif settings. 

*********************************************************************************/
bool CContentSignifSettings::SetSiteSpecificContentSignifSettings(int piSiteID, CTDVString p_param1, CTDVString p_param2, CTDVString p_param3, CTDVString p_param4, CTDVString p_param5, CTDVString p_param6, CTDVString p_param7, CTDVString p_param8, CTDVString p_param9, CTDVString p_param10, CTDVString p_param11, CTDVString p_param12, CTDVString p_param13, CTDVString p_param14, CTDVString p_param15, CTDVString p_param16, CTDVString p_param17, CTDVString p_param18, CTDVString p_param19, CTDVString p_param20, CTDVString p_param21, CTDVString p_param22, CTDVString p_param23, CTDVString p_param24, CTDVString p_param25, CTDVString p_param26, CTDVString p_param27, CTDVString p_param28, CTDVString p_param29, CTDVString p_param30, CTDVString p_param31, CTDVString p_param32, CTDVString p_param33, CTDVString p_param34, CTDVString p_param35)
{
	CStoredProcedure SP;
	bool bSuccess;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CContentSignifSettings::SetSiteSpecificContentSignifSettings", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	bSuccess = SP.SetSiteSpecificContentSignifSettings(piSiteID, p_param1, p_param2, p_param3, p_param4, p_param5, p_param6, p_param7, p_param8, p_param9, p_param10, p_param11, p_param12, p_param13, p_param14, p_param15, p_param16, p_param17, p_param18, p_param19, p_param20, p_param21, p_param22, p_param23, p_param24, p_param25, p_param26, p_param27, p_param28, p_param29, p_param30, p_param31, p_param32, p_param33, p_param34, p_param35);

	return bSuccess; 
}

/*********************************************************************************

	bool CContentSignifSettings::DecrementContentSignif(iSiteID)

		Author:		James Conway
        Created:	12/05/2005
        Inputs:		p_iSiteID 
        Outputs:	-
        Returns:	success boolean
        Purpose:	Decrements site's ContentSignif tables.

*********************************************************************************/
bool CContentSignifSettings::DecrementContentSignif(int p_iSiteID)
{
	CStoredProcedure SP;
	bool bSuccess;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CContentSignifSettings::DecrementContentSignif", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	bSuccess = SP.DecrementContentSignif(p_iSiteID);

	return bSuccess; 
}
