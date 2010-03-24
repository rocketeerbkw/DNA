// SiteOption.cpp: implementation of the CSiteOption class.
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


#include "stdafx.h"
#include "SiteOption.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteOption::CSiteOption() : CXMLObject(),
	m_pNext(NULL)
{
}

CSiteOption::~CSiteOption()
{
}

/*********************************************************************************

	void CSiteOption::Set(int iSiteID, CTDVString& sSection,CTDVString& sName, CTDVString& sValue,int iType, CTDVString& sDescription)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Sets the data of a site option

*********************************************************************************/

void CSiteOption::Set(int iSiteID, CTDVString& sSection,CTDVString& sName, CTDVString& sValue,int iType, CTDVString& sDescription)
{
	m_iSiteID = iSiteID;
	m_sSection = sSection;
	m_sName = sName;
	m_sValue = sValue;
	m_iType = iType;
	m_sDescription = sDescription;
}

/*********************************************************************************

	void CSiteOption::AppendXML(CTDVString& sXML)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Appends the XML version of the site option to the given string

*********************************************************************************/

void CSiteOption::AppendXML(CTDVString& sXML)
{
	CDBXMLBuilder cXMLBuilder(&sXML);

	cXMLBuilder.OpenTag("SITEOPTION",true);

	if (m_iSiteID > 0)
	{
		cXMLBuilder.AddAttribute("GLOBAL","0",true);
		cXMLBuilder.AddIntTag("SITEID",m_iSiteID);
	}
	else
	{
		cXMLBuilder.AddAttribute("GLOBAL","1",true);
		cXMLBuilder.AddTag("DEFINITION","1");
	}

	cXMLBuilder.AddTag("SECTION",m_sSection);
	cXMLBuilder.AddTag("NAME",m_sName);
	cXMLBuilder.AddTag("VALUE",m_sValue);
	cXMLBuilder.AddIntTag("TYPE",m_iType);
	cXMLBuilder.AddTag("DESCRIPTION",m_sDescription);

	cXMLBuilder.CloseTag("SITEOPTION");
}


/*********************************************************************************

	CTDVString CSiteOption::GetValue()

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets the value

*********************************************************************************/

CTDVString CSiteOption::GetValue()
{
	return m_sValue;
}

/*********************************************************************************

	int CSiteOption::GetValueInt()

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets the value as an int

*********************************************************************************/

int CSiteOption::GetValueInt()
{
	return atoi(m_sValue);
}

/*********************************************************************************

	bool CSiteOption::GetValueBool()

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets the value as a bool

*********************************************************************************/

bool CSiteOption::GetValueBool()
{
	return GetValueInt() != 0;
}

/*********************************************************************************

	void CSiteOption::ParseValue(CTDVString& sValue)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Parses the value into a legal string representation based on the type of this
					site option

*********************************************************************************/

void CSiteOption::ParseValue(CTDVString& sValue)
{
	if (IsTypeBool())
	{
		int i = atoi(sValue);
		if (i != 0) i=1;
		sValue = CTDVString(i);
	}
	else if (IsTypeInt())
	{
		sValue = CTDVString(atoi(sValue));
	}
	else if (IsTypeString())
	{
		// Just leave the value as it is!
	}
}

