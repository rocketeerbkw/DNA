#include "stdafx.h"
#include ".\siteconfigpreview.h"

CSiteConfigPreview::CSiteConfigPreview(CInputContext& InputContext) : CSiteConfig(InputContext)
{
}

CSiteConfigPreview::~CSiteConfigPreview(void)
{
}


/*********************************************************************************

	bool CSiteConfigPreview::GetSiteConfig(int iSiteID, CTDVString& sSiteConfig)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		iSiteID = the site in question
        Outputs:	sSiteConfig - A string that will take the value from the database.
        Returns:	true if ok, false if not
        Purpose:	Gets the current SiteConfig data from the database

*********************************************************************************/
bool CSiteConfigPreview::GetSiteConfig(int iSiteID, CTDVString& sSiteConfig)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(SP))
	{
		return SetDNALastError("CSiteConfigPreview","GetSiteConfig","Failed to initialise the storedprocedure!");
	}

	bool bOk = SP.FetchPreviewSiteConfigData(iSiteID);
	if (!bOk)
	{
		SetDNALastError("CSiteConfig","GetSiteConfig","Failed to Get Site Config");
	}
	bOk = bOk && SP.GetField("Config",sSiteConfig);
	return bOk;
}

/*********************************************************************************

	bool CSiteConfigPreview::SetSiteConfig(CStoredProcedure* pSP, int iSiteID, const TDVCHAR* psSiteConfig, const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		SP - An Initialise StoredProcedure object that will call the database.
					psSiteconfig - The new sioteconfig data you want to update the database with.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Updates the siteconfig data with the gicen info.

*********************************************************************************/
bool CSiteConfigPreview::SetSiteConfig(CStoredProcedure* pSP, int iSiteID, const TDVCHAR* psSiteConfig, const TDVCHAR* psEditKey)
{
	// First merge the changes into the current config
	CTDVString sMergedConfig("");
	if (!MergeChangesToExistingConfig(iSiteID,psSiteConfig,sMergedConfig))
	{
		// The error is already set, so just return false.
		return false;
	}

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

	if (psEditKey == NULL || strlen(psEditKey) == 0)
	{
		// Can't update without the editkey!
        return SetDNALastError("CSiteConfig","SetSiteConfig","No Edit Key Given!");
	}

	// Get the value from the URL and call the procedure
	bool bOk = pSP->UpdatePreviewSiteConfigData(sMergedConfig,iSiteID,psEditKey);
	if (!bOk)
	{
		SetDNALastError("CSiteConfig","SetSiteConfig","Failed to update database");
	}
	return bOk;
}

/*********************************************************************************

	bool CSiteConfigPreview::GetPreviewSiteConfig(CTDVString& sSiteConfig, int iSiteID, CTDVString* psEditKey)

		Author:		Mark Howitt
        Created:	10/02/2005
        Inputs:		iSiteID - The id of the site that you want to get the preview data for
        Outputs:	sSiteConfig - a string to take the data
					psEditKey - The value of the current editkey in the database
        Returns:	true if ok, false if not
        Purpose:	Gets the preview siteconfgig data from the database

*********************************************************************************/
bool CSiteConfigPreview::GetPreviewSiteConfig(CTDVString& sSiteConfig, int iSiteID, CTDVString* psEditKey)
{
	// Setup a stored procedure object
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(SP))
	{
		return SetDNALastError("CSiteConfigPreview","GetPreviewSiteConfig","Failed to initialise the storedprocedure!");
	}

	// Now call the procedure
	if (!SP.FetchPreviewSiteConfigData(iSiteID))
	{
		// Errors!
		return SetDNALastError("CSiteConfigPreview","GetPreviewSiteConfig","Failed to get data from data base!");
	}

	// Now get the data from the results
	if (!SP.IsEOF())
	{
		// Get the config from the results
		SP.GetField("config",sSiteConfig);
		if (psEditKey != NULL)
		{
			// Get the edit key value
			SP.GetField("EditKey",*psEditKey);
		}
	}
	return true;
}

/*********************************************************************************

	bool CSiteConfigPreview::MakePreviewSiteConfigActive(int iSiteID)

		Author:		Mark Howitt
        Created:	15/02/2005
        Inputs:		iSiteId - The id of the site you want to copy the preview config to active
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Copies the preview config into the active config.

*********************************************************************************/
bool CSiteConfigPreview::MakePreviewSiteConfigActive(int iSiteID)
{
	// Get the data from the preview
	CTDVString sConfig;
	if (!GetPreviewSiteConfig(sConfig,iSiteID))
	{
		// Problems!
		return false;
	}

	// Now set the config in the active
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if (!CSiteConfig::SetSiteConfig(&SP,iSiteID,sConfig,""))
	{
		// Problems!
		return false;
	}

	// Return ok!
	return true;
}

/*********************************************************************************

		Author:		Mark Howitt
		Created:	19/07/2007
		Inputs:		iSiteID - The id of the site that is being updated
					sChangedConfig - The new changes that need to be merged with the current config.
		Outputs:	sMergedConfig - The new merged config.
		Returns:	True if everything went ok, false if not.
		Purpose:	Merges the changes to the current config. This is done by replacing matching level 1 nodes
					in the current config from the changes config. This means only matching nodes will be updated,
					non matching are left alone.

					e.g

					Current Config...

					<SITECONFIG>
						<TAGA>abc</TAGA>
						<TAGB>def</TAGB>
						<TAGC>ghi</TAGC>
					</SITECONFIG>

					Changes Config...

					<SITECONFIG>
						<TAGA>123</TAGA>
						<TAGC>789</TAGC>
					</SITECONFIG>

					Result of merge...

					<SITECONFIG>
						<TAGA>123</TAGA>
						<TAGB>def</TAGB>
						<TAGC>789</TAGC>
					</SITECONFIG>

*********************************************************************************/
bool CSiteConfigPreview::MergeChangesToExistingConfig(int iSiteID, const TDVCHAR* sChangedConfig, CTDVString& sMergedConfig)
{
	// Get the current config as a node tree
	CTDVString sCurrentConfig("");
	CTDVString sEditKey("");
	if (!GetPreviewSiteConfig(sCurrentConfig,iSiteID,&sEditKey))
	{
		// The error has already be set, just return false.
		return false;
	}

	// Now create the tree from the config string
	CXMLTree* pCurrentConfig = CXMLTree::Parse(sCurrentConfig);
	if (pCurrentConfig == NULL)
	{
		SetDNALastError("CSiteConfigPreview","MergeChangesToExistingConfig","Failed to create a tree from the current site config");
	}
	
	// Now create the tree from the changed config
	CXMLTree* pChangedConfig = CXMLTree::Parse(sChangedConfig);
	if (pChangedConfig == NULL)
	{
		SetDNALastError("CSiteConfigPreview","MergeChangesToExistingConfig","Failed to create a tree from the changed site config");
	}

	// Now go through all the children of the changed tree and replace/insert them into the current
	CXMLTree* pCurrentNode = pChangedConfig->GetFirstChild();
	CXMLTree* pNextChild = NULL;
	if (pCurrentNode != NULL)
	{
		// Now get the first child of the siteconfig root
		pCurrentNode = pCurrentNode->GetFirstChild();
		while (pCurrentNode != NULL)
		{
			// Try to find the same node in the current config
			CXMLTree* pMatching = pCurrentConfig->FindFirstTagName("/SITECONFIG/" + pCurrentNode->GetName());

			// If we found a match, remove it and replace it with the new one.
			if (pMatching != NULL)
			{
				// Remove the node
				pMatching->DetachNodeTree();
				delete pMatching;
				pMatching = NULL;
			}

			// Get the next child
			pNextChild = pCurrentNode->GetNextSibling();

			// Detatch the node and insert it into the current config
			pCurrentNode->DetachNodeTree();
			pCurrentConfig->GetFirstChild()->AddChild(pCurrentNode);

			// Now set the current node to the next child
			pCurrentNode = pNextChild;
		}
	}

	// Now get the update current config as a string
	pCurrentConfig->OutputXMLTree(sMergedConfig);

	// Finish by tidying up
	delete pCurrentConfig;
	delete pChangedConfig;
	return true;
}
