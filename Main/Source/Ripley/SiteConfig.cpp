// SiteConfig.cpp: implementation of the CSiteConfig class.
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
#include "InputContext.h"
#include "MultiStep.h"
#include "SiteConfig.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "User.h"
#include <algorithm>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteConfig::CSiteConfig(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CSiteConfig::~CSiteConfig()
{
}

/*********************************************************************************

	bool CSiteConfig::Initialise()

	Author:		Mark Neves
	Created:	03/02/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CSiteConfig::Initialise()
{
	Destroy();
	return true;
}

/*********************************************************************************

	bool CSiteConfig::EditConfig(CInputContext& inputContext)

	Author:		Mark Neves
	Created:	03/02/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CSiteConfig::EditConfig(CInputContext& inputContext)
{
	if (!Initialise())
	{
		return false;
	}

	if (!CreateEditConfig())
	{
		return SetDNALastError("CSiteConfig","EditConfig","Failed to init XML");
	}

	int iSiteId = m_InputContext.GetSiteID();
	if ( m_InputContext.ParamExists("siteId") ) 
	{
		iSiteId = m_InputContext.GetParamInt("siteid");
	}

	CMultiStep Multi(m_InputContext, "SITECONFIG");
	if (!Multi.ProcessInput())
	{
		return SetDNALastError("CSiteConfig","EditConfig","Failed to process input");
	}

	CTDVString sSiteConfig;
	GetSiteConfig(iSiteId,sSiteConfig);

	if ( !sSiteConfig.IsEmpty() )
	{
		//If there is one element named site config ten it is assumed this element 
		//should contain the entire SiteConfig Inner XML.
		bool bPopulateElementFromRoot = false;
		if ( Multi.GetNumberOfElements() == 1 )
		{
			CTDVString sName, sValue;
			if ( Multi.GetElementFromIndex(0,sName,sValue) )
			{
				if ( sName == "SITECONFIG" )
					bPopulateElementFromRoot = true;
			}
		}

		if ( bPopulateElementFromRoot )
		{
			//Populate element with entire contents of Site Config.
			Multi.FillElementFromXML("SITECONFIG",sSiteConfig);
		}
		else
		{
			//No match for element SITECONFIG found at root level so populate elements from XML children
			Multi.FillElementsFromXML(sSiteConfig);
		}
	}

	CTDVString sXML = Multi.GetAsXML();
	AddInside("SITECONFIG-EDIT",sXML);

	//The Current Site should be available in the current site XML or from sitelist.
	//AddInside("SITECONFIG-EDIT", MakeUrlNameXML(NULL,m_InputContext.GetSiteID()));

	return true;
}

/*********************************************************************************

	bool CSiteConfig::UpdateConfig(CInputContext& inputContext, bool& bMultiStepReady)

	Author:		Mark Neves
	Created:	03/02/2004
	Inputs:		-
	Outputs:	bMultiStepReady - A flag that takes the current status of the multistep.
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CSiteConfig::UpdateConfig(CInputContext& inputContext, bool& bMultiStepReady)
{
	bool bOK = true;
	if (!Initialise())
	{
		return false;
	}

    // Initialise this object's underlying XML structure
	if (!CreateEditConfig())

	{
		SetDNALastError("CSiteConfig","UpdateConfig","Failed to construct XML");
        bOK = false;
	}

	CUser* pViewer = inputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditorOnAnySite() )
	{
		SetDNALastError("CSiteConfig","UpdateConfig","You cannot administer a site unless you are logged in as an Editor");
	    bOK = false;
    }

	CMultiStep Multi(m_InputContext, "SITECONFIG");
	if (!Multi.ProcessInput() )
	{
        CopyDNALastError("CSiteConfig",Multi);
        bOK = false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);


	bMultiStepReady = false;
	if (bOK && Multi.ReadyToUse())
    {
        CTDVString sSiteConfigXML;
        bOK = bOK && Multi.GetAllElementsAsXML(sSiteConfigXML);

		//Ensure Site Config is enclosed in <SITECONFIG> element
		if ( sSiteConfigXML.Left(12) != "<SITECONFIG>" )
		{
			sSiteConfigXML = "<SITECONFIG>" + sSiteConfigXML + "</SITECONFIG>";
	    }

        // Check it can be parsed
	    CXMLTree* pCurrentConfig = CXMLTree::Parse(sSiteConfigXML);
	    if ( pCurrentConfig == NULL )
	    {
		    return SetDNALastError("CSiteConfig","UpdateConfig","Failed to create a tree from the current site config");
	    }

		CTDVString sEditKey;
		m_InputContext.GetParamString("EditKey",sEditKey);

        std::vector<int> vSites;
		pViewer->GetSitesUserIsEditorOf(pViewer->GetUserID(),vSites);

        //Get List of sites to update
        std::vector<int> vSitesToUpdate;
        for ( int i = 0; i < m_InputContext.GetParamCount("siteId"); ++i )
            vSitesToUpdate.push_back( m_InputContext.GetParamInt("siteId",i));

        //Update current site if none specified.
        if ( vSitesToUpdate.size() == 0 )
            vSitesToUpdate.push_back(m_InputContext.GetSiteID());

        // Handle update of multiple sites.
        for ( std::vector<int>::iterator iter = vSitesToUpdate.begin(); iter != vSitesToUpdate.end(); ++iter )
        {
            int iSiteId = *iter; 

            //Check user is superuser / editor on site concerned.
            std::vector<int>::iterator itereditor = std::find(vSites.begin(),vSites.end(), iSiteId);
            if ( pViewer->GetIsSuperuser() || itereditor != vSites.end() )
	        {
	            if ( !SetSiteConfig(&SP,iSiteId,sSiteConfigXML,sEditKey) )
                {
                    AddInside("SITECONFIG-EDIT",GetLastErrorObject());
                }
            }
            else
            {
                CTDVString sShortName;
                m_InputContext.GetShortName(sShortName, iSiteId);
                AddInside("SITECONFIG-EDIT",CreateErrorXMLString("CSiteConfig","NOT-EDITOR","You cannot administer site " +  sShortName + " unless you are logged in as an Editor"));
            }
        }

		bMultiStepReady = bOK;
	}
    //else
    //{
    //    bOK = false;
    //    if ( !ErrorReported() )
    //        SetDNALastError("CSiteConfig","UpdateConfig","Unable to apply edits. The XML maybe poorly formed.");
    //}

    if ( Multi.ErrorReported() )
    {
        CopyDNALastError("CSiteConfig",Multi);
        bOK = false;
    }

	// Add the multistep data, even if an error has occurred
	CTDVString sXML = Multi.GetAsXML();
	AddInside("SITECONFIG-EDIT",sXML);

	return bOK;
}

/*********************************************************************************

	bool CSiteConfig::CreateEmptyConfig()

	Author:		Mark Neves
	Created:	03/02/2004
	Inputs:		-
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Creates a blank site config XML string.
				Used when the site has no config information in the DB

*********************************************************************************/

bool CSiteConfig::CreateEmptyConfig()
{
	bool bOK = Initialise();
	bOK = bOK && CreateFromXMLText("<SITECONFIG/>");

	if (!bOK)
	{
		return SetDNALastError("CSiteConfig","CreateEmptyConfig","Failed to create empty config");
	}

	return bOK;
}

/*********************************************************************************

	bool CSiteConfig::CreateEditConfig()

	Author:		Mark Neves
	Created:	03/02/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CSiteConfig::CreateEditConfig()
{
	bool bOK = Initialise();
	bOK = bOK && CreateFromXMLText("<SITECONFIG-EDIT/>");

	if (!bOK)
	{
		return SetDNALastError("CSiteConfig","CreateEditConfig","Failed to create for edit");
	}

	return bOK;
}

/*********************************************************************************

	CTDVString CSiteConfig::MakeUrlNameXML(CStoredProcedure* pSP = NULL,int iSiteID = 0)

	Author:		Mark Neves
	Created:	04/02/2004
	Inputs:		pSP = ptr to a stored procedure object, if there is one
					  This should hold Site data
					  If NULL, one will be created locally
				iSiteID = the site to use to fetch data if pSP is NULL
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CTDVString CSiteConfig::MakeUrlNameXML(CStoredProcedure* pSP,int iSiteID)
{
	CStoredProcedure SP;
	if (pSP == NULL)
	{
		// If no SP supplied, populate the local one with site data
		if (!m_InputContext.InitialiseStoredProcedureObject(SP))
		{
			SetDNALastError("CSiteConfig","MakeUrlNameXML","Failed to initialise the storedprocedure!");
			return "";
		}
		SP.FetchSiteData(iSiteID);
		pSP = &SP;
	}

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,pSP);
	bool bOk = AddDBXMLTag("URLName");
	TDVASSERT(bOk,"SiteConfig: Failed to get URL from DB");

	return sXML;
}

/*********************************************************************************

	bool CSiteConfig::GetSiteConfig(int iSiteID,CTDVString& sSiteConfig)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		iSiteID = the site in question
        Outputs:	sSiteConfig - A string that will take the value from the database.
        Returns:	true if ok, false if not
        Purpose:	Gets the SiteConfig data from the database for the given site

*********************************************************************************/
bool CSiteConfig::GetSiteConfig(int iSiteID,CTDVString& sSiteConfig)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(SP))
	{
		return SetDNALastError("CSiteConfig","GetSiteConfig","Failed to initialise the storedprocedure!");
	}

	bool bOk = SP.FetchSiteData(iSiteID);
	if (!bOk)
	{
		SetDNALastError("CSiteConfig","GetSiteConfig","Failed to Get Site Config");
	}
	bOk = bOk && SP.GetField("Config",sSiteConfig);
	return bOk;
}

/*********************************************************************************

	bool CSiteConfig::SetSiteConfig(CStoredProcedure* pSP, int iSiteID, const TDVCHAR* psSiteConfig, const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		pSP - An Initialise StoredProcedure object, 
						  or NULL if this func is to set up a local one
					iSiteID = the site to apply it to
					psSiteconfig - The new sioteconfig data you want to update the database with.
					psEditKey = the edit key for the edit
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Updates the siteconfig data with the given info.

					NB: psEditKey is ignored in the base class implementation

*********************************************************************************/
bool CSiteConfig::SetSiteConfig(CStoredProcedure* pSP, int iSiteID, const TDVCHAR* psSiteConfig, const TDVCHAR* psEditKey)
{
	CStoredProcedure SP;
	if (pSP == NULL)
	{
		// If no SP supplied, initialise the local one and point to that
		if (!m_InputContext.InitialiseStoredProcedureObject(SP))
		{
			return SetDNALastError("CSiteConfig","SetSiteConfig","Failed to initialise the storedprocedure!");
		}
		pSP = &SP;
	}

	bool bOk = pSP->UpdateSiteConfig(iSiteID,psSiteConfig);
	if (bOk)
	{
		m_InputContext.SetSiteConfig(psSiteConfig);
		m_InputContext.SiteDataUpdated();
		m_InputContext.Signal("/Signal?action=recache-site");
	}
	else
	{
		SetDNALastError("CSiteConfig","SetSiteConfig","Failed to update database");
	}
	return bOk;
}
