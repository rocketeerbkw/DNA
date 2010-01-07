// SiteOptions.cpp: implementation of the CSiteOptions class.
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
#include "CGI.h"
#include "SiteOptions.h"
#include "SiteOption.h"
#include "tdvassert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteOptions::CSiteOptions() : CXMLObject(),
	m_pFirstSiteOption(NULL),
	m_pLastSiteOption(NULL)
{
}

CSiteOptions::~CSiteOptions()
{
	Destroy();
}

/*********************************************************************************

	bool CSiteOptions::Destroy()

	Author:		Mark Neves
	Created:	29/03/2006
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Trashes the list of site option objects

*********************************************************************************/

bool CSiteOptions::Destroy()
{
	CSiteOption* pSiteOption = m_pFirstSiteOption;
	while (pSiteOption != NULL)
	{
		CSiteOption* pNext = pSiteOption->GetNext();
		delete pSiteOption;
		pSiteOption = pNext;
	}
	m_pFirstSiteOption = NULL;
	m_pLastSiteOption = NULL;

	return true;
}

/*********************************************************************************

	bool CSiteOptions::GetAllSiteOptions(CGI* pCGI)

		Author:		Mark Neves
        Created:	29/03/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets all the site options from the DB

*********************************************************************************/

bool CSiteOptions::GetAllSiteOptions(CGI* pCGI)
{
	if (pCGI == NULL)
	{
		return SetDNALastError("CSiteOptions","GetAllSiteOptions","Bad params");
	}

	Destroy();

	CStoredProcedure SP;
	pCGI->InitialiseStoredProcedureObject(&SP);

	return GetAllSiteOptions(SP);

}

/*********************************************************************************

	bool CSiteOptions::GetAllSiteOptions(CInputContext& InputContext)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets all the site options from the DB

*********************************************************************************/

bool CSiteOptions::GetAllSiteOptions(CInputContext& InputContext)
{
	Destroy();

	CStoredProcedure SP;
	InputContext.InitialiseStoredProcedureObject(&SP);

	return GetAllSiteOptions(SP);
}

/*********************************************************************************

	bool CSiteOptions::GetAllSiteOptions(CStoredProcedure& SP)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets all the site options from the DB

*********************************************************************************/

bool CSiteOptions::GetAllSiteOptions(CStoredProcedure& SP)
{
	if (!SP.GetAllSiteOptions())
	{
		return SetDNALastError("CSiteOptions","GetAllSiteOptions","Failed to get all site options");
	}

	int			iSiteID = 0;
	CTDVString	sSection;
	CTDVString	sName;
	CTDVString	sValue;
	int			iType = 0;
	CTDVString	sDescription;

	while (!SP.IsEOF())
	{
		CSiteOption* pNewSiteOption = new CSiteOption();

		iSiteID = SP.GetIntField("SiteID");
		SP.GetField("Section",sSection);
		SP.GetField("Name",sName);
		SP.GetField("Value",sValue);
		iType = SP.GetIntField("Type");
		SP.GetField("Description",sDescription);

		pNewSiteOption->Set(iSiteID,sSection,sName,sValue,iType,sDescription);

		if (m_pFirstSiteOption == NULL)
		{
			m_pFirstSiteOption = pNewSiteOption;
			m_pLastSiteOption = pNewSiteOption;
		}
		else
		{
			m_pLastSiteOption->SetNext(pNewSiteOption);
			m_pLastSiteOption = pNewSiteOption;
		}

		SP.MoveNext();
	}

	return true;
}

/*********************************************************************************

	void CSiteOptions::CreateXML(int iSiteID, CTDVString& sXML)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Creates an XML version of the site objects, grouped by Section

*********************************************************************************/

void CSiteOptions::CreateXML(int iSiteID, CTDVString& sXML)
{
	CTDVString sSection;

	CDBXMLBuilder cXMLBuilder(&sXML);

	cXMLBuilder.OpenTag("SITEOPTIONS",true);

	if (iSiteID > 0)
	{
		cXMLBuilder.AddAttribute("SITEID",CTDVString(iSiteID),true);
	}
	else
	{
		cXMLBuilder.AddAttribute("DEFAULTS","1",true);
	}

	// Put in all the options defined for the given site
	CSiteOption* pSiteOption = m_pFirstSiteOption;
	while (pSiteOption != NULL)
	{
		if (pSiteOption->GetSiteID() == iSiteID)
		{
			pSiteOption->AppendXML(sXML);
		}

		pSiteOption = pSiteOption->GetNext();
	}

	if (iSiteID > 0)
	{
		// Put in all the DNA-wide options (i.e. siteid==0) that are not defined for the given site
		CSiteOption* pSiteOption = m_pFirstSiteOption;
		while (pSiteOption != NULL)
		{
			if (pSiteOption->GetSiteID() == 0)
			{
				if (FindSiteOption(iSiteID,pSiteOption->GetSection(),pSiteOption->GetName()) == NULL)
				{
					pSiteOption->AppendXML(sXML);
				}
			}

			pSiteOption = pSiteOption->GetNext();
		}
	}

	cXMLBuilder.CloseTag("SITEOPTIONS");
}

/*********************************************************************************

	void CSiteOptions::Process(CInputContext& InputContext)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Processes params passed in via the given InputContext

*********************************************************************************/

void CSiteOptions::Process(CInputContext& InputContext)
{
	CTDVString cmd;
	InputContext.GetParamString("cmd", cmd);

	if (cmd.CompareText("update"))
	{
		Update(InputContext);
	}
}


/*********************************************************************************

	bool CSiteOptions::Update(CInputContext& InputContext)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Updates site options based on the params in the InputContext.

					It uses data encoded into the param names to work out what needs updating.

					For every option that is being updated has at least one param of the form:
						so_<siteid>_<section>_<name>
						e.g.
						so_18_Forum_PostFreq

					If there exists an "so" (SiteOption) param that equals 1
						e.g. so_18_Forum_PostFreq=1
					then this option is either being set for the first time, or being updated

					If there only exists "so" params that equal 0
						e.g. so_18_Forum_PostFreq=0
					then the optoin is being removed (i.e. deleted)

					For every "so" param being set/updated there exists an "sov" (SiteOptionValue) param
						sov_<siteid>_<section>_<name>
						e.g.
						sov_18_Forum_PostFreq

					This contains the value of the site option.

					Only superusers can update site 0 (pan-DNA) options

*********************************************************************************/

bool CSiteOptions::Update(CInputContext& InputContext)
{
	CUser* pViewingUser = InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		return false;
	}

	// Can't do anything unless you are at least an editor
	if (!pViewingUser->GetIsEditor())
	{
		return false;
	}

	CStoredProcedure SP;
	InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sParamName, sParamValue;

	m_SiteOptionParamMap.clear();

	int n = 0;
	while (InputContext.GetParamString("so_",sParamValue,n,true,&sParamName))
	{
		if (m_SiteOptionParamMap.find(sParamName) == m_SiteOptionParamMap.end())
		{
			m_SiteOptionParamMap[sParamName] = 1;

			// The form must contain a param with the right name and of value 1, otherwise it'll be removed
			bool bRemove = true;
			int i = 0;
			while (bRemove && InputContext.GetParamString(sParamName,sParamValue,i))
			{
				bRemove = (atoi(sParamValue) != 1);
				i++;
			}

			int iSiteID = 0;
			CTDVString sSection, sName;
			DecodeParamName(sParamName,iSiteID,sSection,sName);

			// Check to see if an option with this definition exists
			CSiteOption* pSiteOption = FindSiteOption(0,sSection,sName);
			if (pSiteOption != NULL)
			{
				CTDVString sParamValueName;
				sParamValueName << "sov_" << sParamName.Mid(3);
				InputContext.GetParamString(sParamValueName,sParamValue);

				pSiteOption->ParseValue(sParamValue);

				// Only super users can change Site 0 (i.e. pan-DNA) settings
				if (iSiteID == 0)
				{
					if (pViewingUser->GetIsSuperuser())
					{
						if (!bRemove)
						{
							SP.SetSiteOption(iSiteID,sSection,sName,sParamValue);
						}
					}
				}
				else
				{
					if (bRemove)
					{
						if (FindSiteOption(iSiteID,sSection,sName) != NULL)  // Only delete if it exists
						{
							SP.DeleteSiteOption(iSiteID,sSection,sName);
						}
					}
					else
					{
						SP.SetSiteOption(iSiteID,sSection,sName,sParamValue);
					}
				}
			}
		}

		n++;
	}

	GetAllSiteOptions(InputContext);
	InputContext.Signal("/Signal?action=recache-site");

	return true;
}

/*********************************************************************************

	void CSiteOptions::DecodeParamName(CTDVString& sParam, int& iSiteID, CTDVString& sSection, CTDVString& sName)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Given a "so" param name, it is decoded into it's three parts

*********************************************************************************/

void CSiteOptions::DecodeParamName(CTDVString& sParam, int& iSiteID, CTDVString& sSection, CTDVString& sName)
{
	int i = sParam.FindText("_");
	int j = sParam.FindText("_",i+1);
    
	CTDVString sSiteID = sParam.Mid(i+1,j-i-1);
	iSiteID = atoi(sSiteID);

	i=j;
	j = sParam.FindText("_",i+1);

	sSection = sParam.Mid(i+1,j-i-1);
	sName = sParam.Mid(j+1);
}

/*********************************************************************************

	CSiteOption* CSiteOptions::FindSiteOption(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CSiteOption* CSiteOptions::FindSiteOption(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)
{
	CSiteOption* pSiteOption = m_pFirstSiteOption;

	while (pSiteOption != NULL)
	{
		if (pSiteOption->GetSiteID() == iSiteID)
		{
			if (pSiteOption->GetSection().CompareText(pSection))
			{
				if (pSiteOption->GetName().CompareText(pName))
				{
					return pSiteOption;
				}
			}
		}

		pSiteOption = pSiteOption->GetNext();
	}

	return NULL;
}

/*********************************************************************************

	CTDVString CSiteOptions::GetValue(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Mark Neves
        Created:	11/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CTDVString CSiteOptions::GetValue(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)
{
	CSiteOption* pSiteOption = FindSiteOption(iSiteID,pSection,pName);
	if (pSiteOption != NULL)
	{
		return pSiteOption->GetValue();
	}
	else
	{
		// If option doesn't exist for the given site, look for default value
		pSiteOption = FindSiteOption(0,pSection,pName);
		if (pSiteOption != NULL)
		{
			return pSiteOption->GetValue();
		}
	}

	return CTDVString("");
}

/*********************************************************************************

	int CSiteOptions::GetValueInt(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Mark Neves
        Created:	11/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

int CSiteOptions::GetValueInt(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)
{
	CSiteOption* pSiteOption = FindSiteOption(iSiteID,pSection,pName);
	if (pSiteOption != NULL)
	{
		return pSiteOption->GetValueInt();
	}
	else
	{
		// If option doesn't exist for the given site, look for default value
		pSiteOption = FindSiteOption(0,pSection,pName);
		if (pSiteOption != NULL)
		{
			return pSiteOption->GetValueInt();
		}
	}

	return 0;
}

/*********************************************************************************

	bool CSiteOptions::GetValueBool(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Mark Neves
        Created:	11/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CSiteOptions::GetValueBool(int iSiteID, const TDVCHAR* pSection, const TDVCHAR* pName)
{
	CSiteOption* pSiteOption = FindSiteOption(iSiteID,pSection,pName);
	if (pSiteOption != NULL)
	{
		return pSiteOption->GetValueBool();
	}
	else
	{
		// If option doesn't exist for the given site, look for default value
		pSiteOption = FindSiteOption(0,pSection,pName);
		if (pSiteOption != NULL)
		{
			return pSiteOption->GetValueBool();
		}
	}

	return false;
}

/*********************************************************************************

	void CSiteOptions::SwapData(CSiteOptions& other)

		Author:		Jim Lynn
        Created:	6/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

void CSiteOptions::SwapData(CSiteOptions& other)
{
	CSiteOption* pFirst = m_pFirstSiteOption;
	CSiteOption* pLast = m_pLastSiteOption;

	m_pFirstSiteOption = other.m_pFirstSiteOption;
	m_pLastSiteOption = other.m_pLastSiteOption;

	other.m_pFirstSiteOption = pFirst;
	other.m_pLastSiteOption = pLast;

	m_SiteOptionParamMap.swap(other.m_SiteOptionParamMap);
}

