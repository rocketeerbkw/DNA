// MediaAsset.cpp: implementation of the CMediaAsset class.
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
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "MultiStep.h"
#include "User.h"
#include "MediaAsset.h"
#include "MediaAssetSearchPhrase.h"
#include "ProfanityFilter.h"
#include "Config.h"
#include "MediaAssetModController.h"
#include "ArticleSearchPhrase.h"
#include "PollContentRating.h"

const int FIRSTCUT  = 100000000;
const int SECONDCUT = 100000;
const int THIRDCUT  = 100;


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CMediaAsset::CMediaAsset(CInputContext& inputContext) : CXMLObject(inputContext), m_bManualUpload(false), m_bUpdate(false)
{
}

CMediaAsset::~CMediaAsset(void)
{
}

/*********************************************************************************

	bool CMediaAsset::ProcessAction()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Processes the actions to view, create and update
				Assets. We have the one function to create or update governed by
				whether we have an assetid or not
*********************************************************************************/
bool CMediaAsset::ProcessAction()
{
	CTDVString sAction;
	bool bOK = false;
	bool bAddToLibrary = false;
	m_bUpdateDataLoaded = false;
	m_bExternalLink = false;

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	// Check to see if the site is closed, if so then only editors can do anything at this point!	
	bool bSiteClosed = false;
	if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
	{
		// Report back to the user
		return SetDNALastError("CMediaAsset:ProcessAction", "SITEDETAILS","Failed to get the sites open / close status.");
	}

	if (m_InputContext.ParamExists("action"))
	{
		m_InputContext.GetParamString("action",sAction);
	}
	else
	{
		//Default action is view
		sAction = "view";
	}

	if (m_InputContext.ParamExists("AddToLibrary"))
	{
		if(m_InputContext.GetParamInt("AddToLibrary") == 1)
		{
			bAddToLibrary = true;
		}
	}

	if (m_InputContext.ParamExists("updatedatauploaded"))
	{
		if(m_InputContext.GetParamInt("updatedatauploaded") == 1)
		{
			m_bUpdateDataLoaded = true;
		}
	}

	int iMediaAssetID = 0;
	int iH2G2ID = 0;

	if (sAction.CompareText("update"))
	{
		if (pViewingUser == NULL)
		{
			return SetDNALastError("CMediaAsset:ProcessAction", "ProcessAction", "No logged in user");
		}

		if (bSiteClosed && !pViewingUser->GetIsEditor())
		{
			// Report back to the user
			return SetDNALastError("CMediaAsset:ProcessAction", "SITECLOSED", "You cannot update Media Assets Entries while the site is closed.");
		}

		if (m_InputContext.ParamExists("ID"))
		{
			iMediaAssetID = m_InputContext.GetParamInt("ID");
		}
		else
		{
			return SetDNALastError("CMediaAsset:ProcessAction", "Process Action", "no id parameter passed in");
		}

		if (m_InputContext.ParamExists("h2g2id"))
		{
			iH2G2ID = m_InputContext.GetParamInt("h2g2id");
		}

		if(iMediaAssetID > 0)
		{
			m_bManualUpload = true;
			m_bUpdate = true;
			m_bExternalLink = false;

			if (m_InputContext.DoesCurrentSiteAllowedMAExternalLinks())
			{
				if (m_InputContext.ParamExists("externallink"))
				{
					if (m_InputContext.GetParamInt("externallink") == 1)
					{
						m_bExternalLink = true;
					}
				}
			}
			bOK = ProcessCreateUpdate(iMediaAssetID, bAddToLibrary, iH2G2ID);
		}
		else
		{
			return SetDNALastError("CMediaAsset:ProcessAction", "Process Action", "zero or negative parameter passed in");
		}

	}
	else if (sAction.CompareText("create"))
	{
		if (pViewingUser == NULL)
		{
			return SetDNALastError("CMediaAsset:ProcessAction", "ProcessAction", "No logged in user");
		}

		if (bSiteClosed && !pViewingUser->GetIsEditor())
		{
			// Report back to the user
			return SetDNALastError("CMediaAsset:ProcessAction", "SITECLOSED", "You cannot create Media Assets Entries while the site is closed.");
		}

		m_bManualUpload = false;
		if (m_InputContext.ParamExists("manualupload"))
		{
			if (m_InputContext.GetParamInt("manualupload") == 1)
			{
				m_bManualUpload = true;
			}
		}

		m_bExternalLink = false;
		if (m_InputContext.DoesCurrentSiteAllowedMAExternalLinks())
		{
			if (m_InputContext.ParamExists("externallink"))
			{
				if (m_InputContext.GetParamInt("externallink") == 1)
				{
					m_bExternalLink = true;
				}
			}
		}

		bOK = ProcessCreateUpdate(iMediaAssetID, bAddToLibrary);
	}
	else if (sAction.CompareText("showusersassets"))
	{
		bOK = ProcessShowUsersMediaAssets();
	}
	else if (sAction.CompareText("showusersarticleswithassets"))
	{
		bOK = ProcessShowUsersArticlesWithMediaAssets();
	}
	else if (sAction.CompareText("showftpuploadqueue"))
	{
		bOK = ProcessShowFTPUploadQueue();
	}
	else if (sAction.CompareText("reprocessfaileduploads"))
	{
		if (m_InputContext.ParamExists("rpmaid"))
		{
			iMediaAssetID = m_InputContext.GetParamInt("rpmaid");
		}
		bOK = ProcessReprocessFailedUploads(iMediaAssetID);
	}
	else
	{
		bOK = ProcessView();
	}

	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::ProcessView()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Processes the view action to view a particular Assets
*********************************************************************************/
bool CMediaAsset::ProcessView()
{
	int iMediaAssetID = 0;
	if (m_InputContext.ParamExists("ID"))
	{
		iMediaAssetID   = m_InputContext.GetParamInt("ID");
	}
	else
	{
		return SetDNALastError("CMediaAsset", "Process View", "no id parameter passed in");
	}

	if(iMediaAssetID > 0)
	{
		return ViewMediaAsset(iMediaAssetID, m_InputContext.GetSiteID());
	}
	else
	{
		return SetDNALastError("CMediaAsset", "Process View", "zero or negative parameter passed in");
	}

}
/*********************************************************************************

	bool CMediaAsset::ProcessReprocessFailedUploads()

	Author:		Steven Francis
	Created:	20/01/2006
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Processes the reprocessfaileduploads action to reset the upload status for the 
				failed items in the upload queue so an attempt is made to reprocess
*********************************************************************************/
bool CMediaAsset::ProcessReprocessFailedUploads(int iMediaAssetID)
{
	bool bOk = true;
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		return SetDNALastError("CMediaAsset", "ProcessReprocessFailedUploads", "No logged in user");
	}

	if ( pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser() )
	{
		CStoredProcedure SP;
		if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			return SetDNALastError("CMediaAsset", "ProcessReprocessFailedUploads", "m_InputContext.InitialiseStoredProcedureObject failed.");
		}

		InitialiseXMLBuilder(NULL,&SP);

		if(!SP.ReprocessFailedUploads(m_InputContext.GetSiteID(), iMediaAssetID))
		{
			return SetDNALastError("CMediaAsset", "ProcessReprocessFailedUploads", "ReprocessFailedUploads failed");
		}							
		bOk = bOk && OpenXMLTag("MEDIAASSETUPLOADQUEUE", false);
		bOk = bOk && AddXMLTag("ACTION", "reprocessfaileduploads");
		if (iMediaAssetID > 0)
		{
			bOk = bOk && AddXMLIntTag("MEDIAASSETID", iMediaAssetID );
		}
		bOk = bOk && AddXMLTag("RESULT", "SUCCESS");
		bOk = bOk && CloseXMLTag("MEDIAASSETUPLOADQUEUE");

		if (bOk)
		{
			CTDVString sMediaAssetUploadQueueXML;
			sMediaAssetUploadQueueXML = GetBuilderXML();
			CreateFromXMLText(sMediaAssetUploadQueueXML);
		}
	}
	else
	{
		return SetDNALastError("CMediaAsset", "ProcessReprocessFailedUploads", "Must be superuser or editor to reprocess the queue");
	}
		
	return bOk;

}

/*********************************************************************************

	bool CMediaAsset::ProcessShowFTPUploadQueue()

	Author:		Steven Francis
	Created:	20/01/2006
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Processes the showftpuploadqueue action to view a
				list the status of the ftp upload queue
*********************************************************************************/
bool CMediaAsset::ProcessShowFTPUploadQueue()
{
	bool bOk = true;
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		return SetDNALastError("CMediaAsset", "ProcessShowFTPUploadQueue", "No logged in user");
	}

	if ( pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser() )
	{
		CStoredProcedure SP;
		if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			return SetDNALastError("CMediaAsset", "ProcessShowFTPUploadQueue", "m_InputContext.InitialiseStoredProcedureObject failed.");
		}

		InitialiseXMLBuilder(NULL,&SP);

		if(!SP.GetFTPUploadQueue(m_InputContext.GetSiteID()))
		{
			return SetDNALastError("CMediaAsset", "ProcessShowFTPUploadQueue", "ProcessShowFTPUploadQueue failed");
		}							
		bOk = bOk && OpenXMLTag("MEDIAASSETUPLOADQUEUE", false);
		bOk = bOk && AddXMLTag("ACTION", "showftpuploadqueue");
		if(!SP.IsEOF())
		{
			while(!SP.IsEOF())
			{
				bOk = bOk && OpenXMLTag("MEDIAASSET", true);
					int iMediaAssetID = SP.GetIntField("MEDIAASSETID");
					bOk = bOk && AddXMLIntAttribute("MEDIAASSETID", iMediaAssetID, true);

					bOk = bOk && AddDBXMLIntTag("UPLOADSTATUS", NULL, false);
					bOk = bOk && AddDBXMLTag("MIMETYPE", NULL, false);
					bOk = bOk && AddDBXMLIntTag("SITEID", NULL, false);
					bOk = bOk && AddDBXMLTag("SERVER", NULL, false);
				bOk = bOk && CloseXMLTag("MEDIAASSET");

				SP.MoveNext();
			}
		}
		bOk = bOk && CloseXMLTag("MEDIAASSETUPLOADQUEUE");

		if (bOk)
		{
			CTDVString sMediaAssetUploadQueueXML;
			sMediaAssetUploadQueueXML = GetBuilderXML();
			CreateFromXMLText(sMediaAssetUploadQueueXML);
		}
	}
	else
	{
		return SetDNALastError("CMediaAsset", "ProcessShowFTPUploadQueue", "Must be superuser or editor to look at the queue");
	}
		
	return bOk;

}

/*********************************************************************************

	bool CMediaAsset::ProcessShowUsersArticlesWithMediaAssets()

	Author:		Steven Francis
	Created:	11/01/2006
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Processes the showusersarticleswithassets action to view a
				particular users Articles that have Media Assets
*********************************************************************************/
bool CMediaAsset::ProcessShowUsersArticlesWithMediaAssets()
{
	int			iUserID = 0;			// the user ID in the URL
	int			iCurrentUserID = 0;		// the user ID of the current logged in user
	int			iContentType = 0;		// the content type in the URL

	// get the user ID from the URL => zero if not present
	// TODO: something appropriate if no ID provided
	iUserID = m_InputContext.GetParamInt("UserID");

	if (m_InputContext.ParamExists("ContentType"))
	{
		iContentType = m_InputContext.GetParamInt("ContentType");
	}

	//Get Sort by.
	CTDVString sSortBy="";
	if ( m_InputContext.ParamExists("sortby") )
	{
		m_InputContext.GetParamString("sortby", sSortBy);
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
        iCurrentUserID = -1;
	}
	else
	{
        iCurrentUserID = pViewingUser->GetUserID();
	}

	bool bOwner = false;
	if (iUserID == iCurrentUserID)
	{
		bOwner = true;
	}

	if(iUserID > 0)
	{
		return ViewUsersArticlesWithMediaAssets(iUserID, iContentType, bOwner, sSortBy);
	}
	else
	{
		return SetDNALastError("CMediaAsset", "ProcessShowUsersArticlesWithMediaAssets", "zero or negative parameter passed in");
	}

}

/*********************************************************************************

	bool CMediaAsset::ProcessShowUsersMediaAssets()

	Author:		Steven Francis
	Created:	05/12/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Processes the showusersassets action to view a
				particular users Media Assets
*********************************************************************************/
bool CMediaAsset::ProcessShowUsersMediaAssets()
{
	int			iUserID = 0;			// the user ID in the URL
	int			iCurrentUserID = 0;		// the user ID of the current logged in user
	int			iContentType = 0;		// the content type in the URL

	// get the user ID from the URL => zero if not present
	// TODO: something appropriate if no ID provided
	iUserID = m_InputContext.GetParamInt("UserID");

	if (m_InputContext.ParamExists("ContentType"))
	{
		iContentType = m_InputContext.GetParamInt("ContentType");
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
        iCurrentUserID = -1;
	}
	else
	{
        iCurrentUserID = pViewingUser->GetUserID();
	}

	//Get Sort by.
	CTDVString sSortBy="";
	if ( m_InputContext.ParamExists("sortby") )
	{
		m_InputContext.GetParamString("sortby", sSortBy);
	}

	bool bOwner = false;
	if (iUserID == iCurrentUserID)
	{
		bOwner = true;
	}

	if(iUserID > 0)
	{
		return ViewUsersMediaAssets(iUserID, iContentType, bOwner, sSortBy);
	}
	else
	{
		return SetDNALastError("CMediaAsset", "ProcessShowUsersMediaAssets", "zero or negative parameter passed in");
	}

}
/*********************************************************************************

	bool CMediaAsset::ProcessCreateUpdate()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		iMediaAssetID , bAddToLibrary, iH2G2ID = 0
	Outputs:	-
	Returns:	bool
	Purpose:	Processes the update action for the builder to update Assets
				Gets the user entered information from a CMultiStep object
*********************************************************************************/
bool CMediaAsset::ProcessCreateUpdate(int iMediaAssetID, bool bAddToLibrary, int iH2G2ID /*= 0*/)
{
	bool bOK = true;
	bool bCreated = false;
	bool bGotFileDetails = false;
	CTDVString sReturnedXML = "";
	CTDVString sAction = "";
	int iCurrentUserID = 0;

	const char *pFileBuffer;

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		return SetDNALastError("CMediaAsset", "ProcessCreateUpdate", "No logged in user");
	}

	iCurrentUserID = pViewingUser->GetUserID();

	CMultiStep Multi(m_InputContext, "ASSET");

	if (m_bManualUpload)
	{
		//Multi.AddRequiredParam("filename");
		Multi.AddRequiredParam("mimetype");

		if (m_bExternalLink)
		{
			Multi.AddRequiredParam("externallinkurl");
		}
	}
	else
	{
		Multi.AddRequiredParam("file", "", false, true);
		Multi.AddRequiredParam("filename");
	}


	Multi.AddRequiredParam("contenttype");
	Multi.AddRequiredParam("caption");
	Multi.AddRequiredParam("mediaassetdescription");
	Multi.AddRequiredParam("mediaassetkeyphrases");

	if (m_bUpdate)
	{
		Multi.AddRequiredParam("hidden");
	}
	else
	{
		Multi.AddRequiredParam("termsandconditions");
	}

	if(m_bUpdate && iMediaAssetID > 0 && !m_bUpdateDataLoaded)
	{
		//If this is an update operation and we haven't got the data to be updated yet then
		// get the stuff from the database for this asset id we're updating and poke the values 
		// into the multistep
		CTDVString sReturnedFilename;
		CTDVString sReturnedCaption;
		CTDVString sReturnedMimeType;
		CTDVString sReturnedDescription;
		CTDVString sReturnedMultiElementsXML;

		CTDVString sReturnedMediaAssetKeyPhrases;

		CTDVString sReturnedMediaAssetExternalURLLink;

		int iReturnedContentType;
		int iReturnedOwnerID;
		int iReturnedHidden;

		sAction = "update";
		bOK = GetMediaAsset(iMediaAssetID, m_InputContext.GetSiteID(), sReturnedCaption,
									sReturnedFilename, sReturnedMimeType, &iReturnedContentType, 
									sReturnedMultiElementsXML, &iReturnedOwnerID, sReturnedMediaAssetKeyPhrases, 
									sReturnedDescription, &iReturnedHidden, sReturnedMediaAssetExternalURLLink);
		if (bOK)
		{
			if (pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser())
			{
				CTDVString sMultiElementsXML;
				CTDVString sContentType(iReturnedContentType); 
				CTDVString sHidden(iReturnedHidden); 

				CTDVString sBodyXML = "<GUIDE>" + sReturnedMultiElementsXML + "</GUIDE>";
				
				// Need to "seed" the MultiStep object with the body text, so that if an _msxml param is not
				// supplied on the URL, it can generate one from a combination of the required fields and
				// the contents of the guide's body
				Multi.SetMSXMLSeed(sBodyXML);
				
				//Fills in XML
				if (!Multi.ProcessInput())
				{
					return SetDNALastError("CMediaAsset", "ProcessCreateUpdate-Update", "Failed to process update input");
				}

				Multi.SetRequiredValue("contenttype", sContentType);
				Multi.SetRequiredValue("caption", sReturnedCaption);
				Multi.SetRequiredValue("mimetype", sReturnedMimeType);

				Multi.SetRequiredValue("mediaassetkeyphrases", sReturnedMediaAssetKeyPhrases);

				Multi.SetRequiredValue("mediaassetdescription", sReturnedDescription);

				Multi.SetRequiredValue("hidden", sHidden);
				// Extra extendedable element stuff removed for time being

				sMultiElementsXML << "<EXTRAELEMENTXML>";
				sMultiElementsXML << sReturnedMultiElementsXML;
				sMultiElementsXML << "</EXTRAELEMENTXML>";

				if (m_bExternalLink)
				{
					Multi.SetRequiredValue("externallinkurl", sReturnedMediaAssetExternalURLLink);
				}

				Multi.FillElementsFromXML(sMultiElementsXML);

				m_bUpdateDataLoaded = true;
			}
			else
			{
				return SetDNALastError("CMediaAsset", "ProcessCreateUpdate", "You must be the owner or an editor to update asset info.");
			}
		}
	}
	else
	{
		if (!Multi.ProcessInput())
		{
			return SetDNALastError("CMediaAsset", "ProcessCreateUpdate", "Failed to process input");
		}
		if (Multi.ErrorReported())
		{
			CopyDNALastError("CMediaAsset", Multi);
		}
	}

	if(m_bUpdate)
	{
		sAction = "update";
	}
	else
	{
		sAction = "create";
	}

	if (Multi.ReadyToUse())
	{
		//The real deal so try to put everything in the database
		CTDVString sMultiElementsXML="";
		CTDVString sCaption="";
		CTDVString sFilename="";
		CTDVString sMimeType="";
		CTDVString sDescription="";

		CTDVString sExternalLinkURL ="";

		int iContentType = 0;
		int iFileLength = 0;
		int iHidden = 0;

		CTDVString sMediaAssetKeyPhrases="";

		bool bEscaped = true;
				
		Multi.GetRequiredValue("contenttype", iContentType);

		if (m_bManualUpload)
		{
			CTDVString sInMimeType;

			//It's going to be a manual upload so get values entered from the form
			//Multi.GetRequiredValue("filename", sFilename, &bEscaped);
			Multi.GetRequiredValue("mimetype", sInMimeType, &bEscaped);
			//Make sure we have a good style mimetype
			FixMimeType(sInMimeType, sMimeType);

			if (m_bExternalLink)
			{
				Multi.GetRequiredValue("externallinkurl", sExternalLinkURL, &bEscaped);
			}
		}
		else
		{

			if (!Multi.GetRequiredFileData("file", &pFileBuffer, iFileLength, sMimeType, &sFilename))
			{
			//Get the values from the file itself
			//bGotFileDetails = GetFileDetails(iContentType, sMimeType, iFileLength);
			//Filename left as blank it will be the Media Asset ID
			//if (!bGotFileDetails)
			//{
				//Problems with the file details so back out
				//Check what to do whether to just jump ship or set multi step to error somehow
				//maybe jus drop out and check before doing the create and upload
				if (Multi.ErrorReported())
				{
					CopyDNALastError("CMediaAsset", Multi);
				}
				return false;
			}
			int iFilesContentType = 0;

			if (!IsMimeTypeSupported(sMimeType, iFilesContentType))
			{
				return SetDNALastError("CMediaAsset", "ProcessCreateUpdate - IsMimeTypeSupported", "File format not supported. " + sMimeType);
			}

			//Check that the selected Content type
			if (iFilesContentType != iContentType)
			{
				return SetDNALastError("CMediaAsset", "ProcessCreateUpdate - ContentTypeMismatch", "Format of the file doesn't match the Content Type selected. " + sMimeType);
			}		

			int iTotalUploadSize; 
			bool bWithinLimit; 
			CTDVDateTime dtNextLimitStartDate;

			if (!CheckUsersFileUploadLimit(iFileLength, iCurrentUserID, iTotalUploadSize, bWithinLimit, dtNextLimitStartDate))
			{
				//Error in the actual stored procedure just return that
				return false;
			}
			if (!bWithinLimit)
			{
				ExceedsUploadLimitErrorInfo(iFileLength, iTotalUploadSize, dtNextLimitStartDate);
				return SetDNALastError("CMediaAsset", "ProcessCreateUpdate - CheckUsersFileLimit", "User has exceeded weekly upload limit. ");
			}

			CTDVString sContentType(iContentType);
			Multi.SetRequiredValue("contenttype", sContentType);
			Multi.SetRequiredValue("filename", sFilename);
		}

		Multi.GetRequiredValue("caption", sCaption, &bEscaped);
		Multi.GetRequiredValue("mediaassetdescription", sDescription, &bEscaped);

		Multi.GetRequiredValue("mediaassetkeyphrases", sMediaAssetKeyPhrases, &bEscaped);

		if(m_bUpdate)
		{
			Multi.GetRequiredValue("hidden", iHidden);
		}
		// Check the user input for profanities - before adding the asset.
		// Asset will not be created if there is a profanity found.
		CProfanityFilter ProfanityFilter(m_InputContext);
		CTDVString sProfanity = "";

		CProfanityFilter::FilterState filterState = 
			ProfanityFilter.CheckForProfanities(sMediaAssetKeyPhrases, &sProfanity);

		if (filterState == CProfanityFilter::FailBlock || filterState == CProfanityFilter::FailRefer)
		{
			return SetDNALastError("CMediaAsset", "ProcessCreateUpdate - CheckForProfanities", "Key Phrases contain a banned word. Profanity Found = " + sProfanity);
		}

		//Extra extendedable element stuff removed for time being
		Multi.GetAllElementsAsXML(sMultiElementsXML);

		CTDVString strIPAddress = m_InputContext.GetIPAddress();
	
		bool bSkipModeration = false;
		if ( pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser())
		{
			bSkipModeration = true;
		}

		bOK = CreateUpdateMediaAsset(iMediaAssetID, m_InputContext.GetSiteID(), sCaption, 
									sFilename, sMimeType, iContentType, sMultiElementsXML, 
									iCurrentUserID, sMediaAssetKeyPhrases, sDescription, 
									bAddToLibrary, iFileLength, strIPAddress, bSkipModeration, 
									iHidden, iH2G2ID, sExternalLinkURL, sReturnedXML);

		if (bOK)
		{
			if(!m_bManualUpload)
			{
				bOK = UploadMediaAsset(iMediaAssetID, pFileBuffer, iFileLength, bAddToLibrary, bSkipModeration);
			}
			else //Need to create an entry in the moderation queue for a manually entered media asset
			{
				if (!bSkipModeration)
				{
					bOK = QueueMediaAssetForModeration(iMediaAssetID, m_InputContext.GetSiteID());
				}
			}
		}
		bCreated = true;
	}

	CTDVString sMediaAssetXML;
	sMediaAssetXML << "<MEDIAASSETINFO>";
	sMediaAssetXML << "<ACTION>";
	sMediaAssetXML << sAction;
	sMediaAssetXML << "</ACTION>";
	sMediaAssetXML << "<ID>";
	sMediaAssetXML << iMediaAssetID;
	sMediaAssetXML << "</ID>";
	if(m_bManualUpload)
	{	
		sMediaAssetXML << "<MANUALUPLOAD>1</MANUALUPLOAD>";
	}
	if(m_bExternalLink)
	{	
		sMediaAssetXML << "<EXTERNALLINK>1</EXTERNALLINK>";
	}	
	if(m_bUpdate)
	{	
		sMediaAssetXML << "<UPDATEH2G2ID>";
		sMediaAssetXML << iH2G2ID;
		sMediaAssetXML << "</UPDATEH2G2ID>";
	}
	if(m_bUpdateDataLoaded)
	{	
		sMediaAssetXML << "<UPDATEDATAUPLOADED>1</UPDATEDATAUPLOADED>";
	}
	sMediaAssetXML << Multi.GetAsXML();
	if (bCreated && bOK)
	{
		sMediaAssetXML << sReturnedXML;
	}
	sMediaAssetXML << "</MEDIAASSETINFO>";

	CreateFromXMLText(sMediaAssetXML);

	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::CreateUpdateMediaAsset()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		int *piMediaAssetID,
				int iSiteID, 
				const TDVCHAR* pCaption,
				const TDVCHAR* pFilename, 
				const TDVCHAR* pMimeType, 
				int iContentType,
				const TDVCHAR* pMultiElementsXML 
				int iOwnerID,
				const TDVCHAR* pMediaAssetKeyPhrases,
				const TDVCHAR* pDescription
				const TDVCHAR* pIPAddress
				bool bSkipModeration
				int Hidden
				int H2G2ID if article media asset for updating
				const TDVCHAR* pExternalLinkURL - External link URL

	Outputs:	sReturnedXML - The formed XML contained the created asset
	Returns:	bool
	Purpose:	Creates or Updates a Media Asset, calls the correct stored procedure based 
				on if we have an Media Asset ID or not
*********************************************************************************/
bool CMediaAsset::CreateUpdateMediaAsset(int& iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType,
									const TDVCHAR* pMultiElementsXML, int iOwnerID, 
									const TDVCHAR* pMediaAssetKeyPhrases, const TDVCHAR* pDescription,
									bool bAddToLibrary, int iFileLength,
									const TDVCHAR* pIPAddress, bool bSkipModeration, 
									int iHidden, int iH2G2ID, const TDVCHAR* pExternalLinkURL, 
									CTDVString& sReturnedXML)
{
	CTDVString sResult;
	CStoredProcedure SP;
	bool bOK = true;
	CTDVDateTime dtDateCreated;
	CTDVDateTime dtLastUpdated;

	sReturnedXML = "";

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "CreateUpdateMediaAsset", "InitialiseStoredProcedureObject Failed");
	}
	else
	{
		if(iMediaAssetID > 0)
		{
			if (SP.UpdateMediaAsset(iMediaAssetID, iSiteID, pCaption,
									pFilename, pMimeType, iContentType, 
									pMultiElementsXML, iOwnerID, pDescription, 
									dtDateCreated, dtLastUpdated, iHidden, pExternalLinkURL))
			{
				//Remove the existing ones and add the new lot
				bOK = bOK && RemoveArticleAndMediaAssetKeyPhrases(iMediaAssetID, iH2G2ID);

				//Add the tags back to the media asset
				bOK = bOK && AddMediaAssetKeyPhrases(iMediaAssetID, pMediaAssetKeyPhrases);
				
				//if it's attached to an article then add those tags back to the article too
				if (iH2G2ID > 0)
				{
					bOK = bOK && AddArticleMediaAssetKeyPhrases(iH2G2ID, pMediaAssetKeyPhrases);
				}

				bOK = bOK && CreateMediaAssetXML(iMediaAssetID, iSiteID, pCaption,
								pFilename, pMimeType, iContentType, 
								pMultiElementsXML, iOwnerID, pDescription, 
								bAddToLibrary, dtDateCreated, dtLastUpdated, 
								sReturnedXML, false, 0, iHidden, pExternalLinkURL);
			}
			else
			{
				return SetDNALastError("CMediaAsset", "CreateUpdateMediaAsset", "zero or negative parameter passed in");
			}
		}
		else
		{
			if (SP.CreateMediaAsset(&iMediaAssetID, iSiteID, pCaption,
									pFilename, pMimeType, iContentType, 
									pMultiElementsXML, iOwnerID, pDescription, 
									bAddToLibrary, dtDateCreated, dtLastUpdated, 
									iFileLength, pIPAddress, bSkipModeration,
									pExternalLinkURL))
			{
				if (iMediaAssetID > 0)
				{
					bOK = bOK && AddMediaAssetKeyPhrases(iMediaAssetID, pMediaAssetKeyPhrases);

					bOK = bOK && CreateMediaAssetXML(iMediaAssetID, iSiteID, pCaption,
									pFilename, pMimeType, iContentType, 
									pMultiElementsXML, iOwnerID, pDescription, 
									bAddToLibrary, dtDateCreated, dtLastUpdated, 
									sReturnedXML, false, 0, iHidden,
									pExternalLinkURL);
				}
				else
				{
					return SetDNALastError("CMediaAsset", "CreateUpdateMediaAsset", "CreateMediaAsset Stored procedure return a zero or negative ID value");
				}
			}
			else
			{
				return SetDNALastError("CMediaAsset", "CreateUpdateMediaAsset", "CreateMediaAsset Stored procedure failed");
			}
		}
	}
	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::ViewMediaAsset()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		int iMediaAssetID, 
				int iSiteID
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to bring back the XML to view an Asset
*********************************************************************************/
bool CMediaAsset::ViewMediaAsset(int iMediaAssetID, int iSiteID)
{
	CStoredProcedure SP;

	bool bOk = true;
	CTDVString sMediaAssetKeyPhrases;
	int iOwnerID = 0;
	CTDVString sUserXMLBlock;
	CTDVString sFTPPath;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "ViewMediaAsset", "InitialiseStoredProcedureObject Failed");
	}
	else
	{
		InitialiseXMLBuilder(NULL,&SP);

		if (SP.GetMediaAsset(iMediaAssetID))
		{
			if(!SP.IsEOF())
			{
				bOk = bOk && OpenXMLTag("MEDIAASSETINFO");
					bOk = bOk && AddXMLTag("ACTION", "View");
					bOk = bOk && AddXMLIntTag("ID", iMediaAssetID);
					bOk = bOk && OpenXMLTag("MEDIAASSET", true);
						bOk = bOk && AddXMLIntAttribute("MEDIAASSETID", iMediaAssetID, true);

						bOk = bOk && GenerateFTPDirectoryString(iMediaAssetID, sFTPPath);
						bOk = bOk && AddXMLTag("FTPPATH", sFTPPath);

						bOk = bOk && AddXMLIntTag("SITEID", iSiteID);
						bOk = bOk && AddDBXMLTag("CAPTION", NULL, false, true);
						bOk = bOk && AddDBXMLTag("FILENAME", NULL, false, true);
						bOk = bOk && AddDBXMLTag("MIMETYPE", NULL, false, true);
						bOk = bOk && AddDBXMLIntTag("CONTENTTYPE");

					//Extra extendedable element stuff removed for time being
						bOk = bOk && AddDBXMLTag("EXTRAELEMENTXML", NULL, false, false);

						//Get the KeyPhrase XML to add into returned XML
						bOk = bOk && GetMediaAssetKeyPhrases(iMediaAssetID, sMediaAssetKeyPhrases);
						bOk = bOk && AddXMLTag("", sMediaAssetKeyPhrases);

						iOwnerID = SP.GetIntField("OWNERID");
						CUser oOwner(m_InputContext);
						oOwner.CreateFromID(iOwnerID);
						oOwner.GetAsString(sUserXMLBlock);

						bOk = bOk && AddXMLTag("OWNER", sUserXMLBlock);
							
						//bOk = bOk && AddDBXMLIntTag("OWNERID");
						bOk = bOk && AddDBXMLTag("Description", "MEDIAASSETDESCRIPTION", false, true);

						bOk = bOk && AddDBXMLDateTag("DATECREATED", NULL, false);
						bOk = bOk && AddDBXMLDateTag("LASTUPDATED", NULL, false);
						bOk = bOk && AddDBXMLIntTag("HIDDEN", NULL, false);
					
						CTDVString sExternalLinkURL="";
						CTDVString sExternalLinkID="";
						CTDVString sExternalLinkType="";

						CTDVString sFlickrFarmPath=""; 
						CTDVString sFlickrServer=""; 
						CTDVString sFlickrID=""; 
						CTDVString sFlickrSecret=""; 
						CTDVString sFlickrSize="";

						SP.GetField("EXTERNALLINKURL", sExternalLinkURL);
						GetIDFromLink(sExternalLinkURL, 
									sExternalLinkID, 
									sExternalLinkType, 
									sFlickrFarmPath, 
									sFlickrServer, 
									sFlickrID, 
									sFlickrSecret, 
									sFlickrSize);
						
						bOk = bOk && AddXMLTag("EXTERNALLINKTYPE", sExternalLinkType);
						bOk = bOk && AddDBXMLTag("EXTERNALLINKURL", NULL, false, true);
						bOk = bOk && AddXMLTag("EXTERNALLINKID", sExternalLinkID);

						bOk = bOk && OpenXMLTag("FLICKR", false);
						bOk = bOk && AddXMLTag("FARMPATH", sFlickrFarmPath);
						bOk = bOk && AddXMLTag("SERVER", sFlickrServer);
						bOk = bOk && AddXMLTag("ID", sFlickrID);
						bOk = bOk && AddXMLTag("SECRET", sFlickrSecret);
						bOk = bOk && AddXMLTag("SIZE", sFlickrSize);
						bOk = bOk && CloseXMLTag("FLICKR");

					bOk = bOk && CloseXMLTag("MEDIAASSET");
				bOk = bOk && CloseXMLTag("MEDIAASSETINFO");

				if (bOk)
				{
					CTDVString sMediaAssetXML;
					sMediaAssetXML = GetBuilderXML();
					CreateFromXMLText(sMediaAssetXML);
				}
			}
			else
			{
				return SetDNALastError("CMediaAsset", "ViewMediaAsset", "Invalid Media Asset ID was entered");
			}
		}
		else
		{
			return SetDNALastError("CMediaAsset", "ViewMediaAsset", "GetMediaAsset Stored procedure failed");
		}
	}
	return bOk;
}

/*********************************************************************************

	bool CMediaAsset::CreateMediaAssetXML()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		int iMediaAssetID, 
				int iSiteID, 
				const TDVCHAR* pCaption,
				const TDVCHAR* pFilename, 
				const TDVCHAR* pMimeType, 
				int iContentType,
				const TDVCHAR* pMultiElementsXML, 
				int iOwnerID,
				const TDVCHAR* pDescription,

				CTDVDateTime &dtDateCreated, 
				CTDVDateTime &dtLastUpdated
				bool bPreviewMode, 
				const TDVCHAR* pPreviewKeyPhrases, 
				int iHidden - Hidden status
				const TDVCHAR* pExternalLinkURL - external link url

	Outputs:	sReturnedXML - The formed XML
	Returns:	bool
	Purpose:	Creates a MediaAsset XML block from the given parameters
*********************************************************************************/
bool CMediaAsset::CreateMediaAssetXML(int iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, 
									const TDVCHAR* pMultiElementsXML, int iOwnerID,
									const TDVCHAR* pDescription, bool bAddToLibrary, 
									CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated, 
									CTDVString& sReturnedXML, bool bPreviewMode, 
									const TDVCHAR* pPreviewKeyPhrases, int iHidden, 
									const TDVCHAR* pExternalLinkURL)
{
	bool bOk = true;

	CDBXMLBuilder XML;
	XML.Initialise(&sReturnedXML);
	CTDVString sMediaAssetKeyPhrases;
	CTDVString sUserXMLBlock;
	CTDVString sFTPPath;

	bOk = bOk && XML.OpenTag("MEDIAASSET", true);
	bOk = bOk && XML.AddIntAttribute("MEDIAASSETID", iMediaAssetID, true);

	bOk = bOk && GenerateFTPDirectoryString(iMediaAssetID, sFTPPath);

	bOk = bOk && XML.AddTag("FTPPATH", sFTPPath);

	bOk = bOk && XML.AddIntTag("SITEID", iSiteID);
	bOk = bOk && XML.AddTag("CAPTION", pCaption);
	bOk = bOk && XML.AddTag("FILENAME", pFilename);
	bOk = bOk && XML.AddTag("MIMETYPE", pMimeType);
	bOk = bOk && XML.AddIntTag("CONTENTTYPE", iContentType);

//Extra extendedable element stuff removed for time being
	bOk = bOk && XML.AddTag("EXTRAELEMENTXML", pMultiElementsXML);

	//Get the KeyPhrase XML to add into returned XML
	if (!bPreviewMode)
	{
		bOk = bOk && GetMediaAssetKeyPhrases(iMediaAssetID, sMediaAssetKeyPhrases);
	}
	else
	{
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CMediaAssetSearchPhrase oMediaAssetSearchPhrase(m_InputContext,delimit);

		bOk = bOk && oMediaAssetSearchPhrase.CreatePreviewPhrases( pPreviewKeyPhrases );
		bOk = bOk && oMediaAssetSearchPhrase.GetAsString(sMediaAssetKeyPhrases);
	}
	bOk = bOk && XML.AddTag("", sMediaAssetKeyPhrases);
	
	CUser oOwner(m_InputContext);
	oOwner.CreateFromID(iOwnerID);
	oOwner.GetAsString(sUserXMLBlock);

	bOk = bOk && XML.AddTag("OWNER", sUserXMLBlock);

//	bOk = bOk && XML.AddIntTag("OWNERID", iOwnerID);
	bOk = bOk && XML.AddTag("MEDIAASSETDESCRIPTION", pDescription);

	if (bAddToLibrary)
	{
		bOk = bOk && XML.AddIntTag("ADDEDTOLIBRARY", 1);
	}
	else
	{
		bOk = bOk && XML.AddIntTag("ADDEDTOLIBRARY", 0);
	}

	bOk = bOk && XML.AddDateTag("DATECREATED", dtDateCreated);
	bOk = bOk && XML.AddDateTag("LASTUPDATED", dtLastUpdated);
	
	if (iHidden > 0)
	{
		//Add the hidden status if it's not 0. Default of Hidden in Moderation = 3
		bOk = bOk && XML.AddIntTag("HIDDEN" , iHidden);
	}

	if (pExternalLinkURL != NULL)
	{
		CTDVString sExternalLinkURL;
		CTDVString sExternalLinkID;
		CTDVString sExternalLinkType="";
		CTDVString sFlickrFarmPath=""; 
		CTDVString sFlickrServer=""; 
		CTDVString sFlickrID=""; 
		CTDVString sFlickrSecret=""; 
		CTDVString sFlickrSize="";

		GetIDFromLink(pExternalLinkURL, 
						sExternalLinkID, 
						sExternalLinkType, 
						sFlickrFarmPath, 
						sFlickrServer, 
						sFlickrID, 
						sFlickrSecret, 
						sFlickrSize);

		bOk = bOk && XML.AddTag("EXTERNALLINKTYPE", sExternalLinkType);
		bOk = bOk && XML.AddTag("EXTERNALLINKURL", pExternalLinkURL);
		bOk = bOk && XML.AddTag("EXTERNALLINKID", sExternalLinkID);
		
		bOk = bOk && XML.OpenTag("FLICKR", false);
		bOk = bOk && XML.AddTag("FARMPATH", sFlickrFarmPath);
		bOk = bOk && XML.AddTag("SERVER", sFlickrServer);
		bOk = bOk && XML.AddTag("ID", sFlickrID);
		bOk = bOk && XML.AddTag("SECRET", sFlickrSecret);
		bOk = bOk && XML.AddTag("SIZE", sFlickrSize);
		bOk = bOk && XML.CloseTag("FLICKR");
	}

	bOk = bOk && XML.CloseTag("MEDIAASSET");

	return bOk;
}

/*********************************************************************************

	bool CMediaAsset::GetMediaAsset()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		int iMediaAssetID, 
				int iSiteID, 
				CTDVString &sCaption,								
				CTDVString &sFilename, 
				CTDVString &sMimeType, 
				int *piContentType, 
				CTDVString &sMultiElementsXML,
				int *piOwnerID,
				CTDVString &sMediaAssetKeyPhrases,
				CTDVString &sDescription,
				int *piHidden,
				CTDVString &sExternalLinkURL
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to get the values for an Asset
*********************************************************************************/
bool CMediaAsset::GetMediaAsset(int iMediaAssetID, int iSiteID, CTDVString &sCaption,
									CTDVString &sFilename, CTDVString &sMimeType, int *piContentType,
									CTDVString &sMultiElementsXML, int *piOwnerID,
									CTDVString &sMediaAssetKeyPhrasesAsString,
									CTDVString &sDescription, int *piHidden,
									CTDVString &sExternalLinkURL)
{
	CStoredProcedure SP;

	bool bOk = true;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "GetMediaAsset", "InitialiseStoredProcedureObject Failed");
	}
	else
	{
		if (SP.GetMediaAsset(iMediaAssetID))
		{
			if(!SP.IsEOF())
			{
				bOk = bOk && SP.GetField("CAPTION", sCaption);
				bOk = bOk && SP.GetField("FILENAME", sFilename);
				bOk = bOk && SP.GetField("MIMETYPE", sMimeType);
				*piContentType = SP.GetIntField("CONTENTTYPE");

//Extra extendedable element stuff removed for time being
				bOk = bOk && SP.GetField("EXTRAELEMENTXML", sMultiElementsXML);

				bOk = bOk && GetMediaAssetKeyPhrases(iMediaAssetID, sMediaAssetKeyPhrasesAsString, true);

				*piOwnerID = SP.GetIntField("OWNERID");
				bOk = bOk && SP.GetField("DESCRIPTION", sDescription);
				*piHidden = SP.GetIntField("HIDDEN");

				bOk = bOk && SP.GetField("EXTERNALLINKURL", sExternalLinkURL);
			}
			else
			{
				return SetDNALastError("CMediaAsset", "GetMediaAsset", "Invalid Media Asset ID was entered");
			}
		}
		else
		{
			return SetDNALastError("CMediaAsset", "GetMediaAsset", "GetMediaAsset Stored procedure failed");
		}
	}
	return bOk;
}

/*********************************************************************************

	bool CMediaAsset::AddMediaAssetKeyPhrases()

	Author:		Steven Francis
	Created:	27/10/2005
	Inputs:		iMediaAssetID, pMediaAssetKeyPhrases
	Outputs:	-
	Returns:	bool
	Purpose:	Adds the entered key phrases to the media asset
*********************************************************************************/
bool CMediaAsset::AddMediaAssetKeyPhrases(int iMediaAssetID, const TDVCHAR* pMediaAssetKeyPhrases)
{
	bool bOK = true;
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CMediaAssetSearchPhrase oMediaAssetSearchPhrase(m_InputContext,delimit);
	oMediaAssetSearchPhrase.ParsePhrases(pMediaAssetKeyPhrases);
	bOK = oMediaAssetSearchPhrase.AddKeyPhrases(iMediaAssetID);
	if (!bOK)
	{
		CopyDNALastError("CMediaAsset", oMediaAssetSearchPhrase);
	}
	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::AddArticleMediaAssetKeyPhrases()

	Author:		Steven Francis
	Created:	19/06/2006
	Inputs:		iH2G2ID, pMediaAssetKeyPhrases
	Outputs:	-
	Returns:	bool
	Purpose:	Adds the entered key phrases to the article with media asset
*********************************************************************************/
bool CMediaAsset::AddArticleMediaAssetKeyPhrases(int iH2G2ID, const TDVCHAR* pMediaAssetKeyPhrases)
{
	bool bOK = true;
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CArticleSearchPhrase oArticleKeyPhrase(m_InputContext,delimit);
	oArticleKeyPhrase.ParsePhrases(*pMediaAssetKeyPhrases);
	bOK = oArticleKeyPhrase.AddKeyPhrases(iH2G2ID);
	if (!bOK)
	{
		CopyDNALastError("CMediaAsset", oArticleKeyPhrase);
	}
	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::RemoveMediaAssetKeyPhrases()

	Author:		Steven Francis
	Created:	19/06/2006
	Inputs:		iMediaAssetID
	Outputs:	-
	Returns:	bool
	Purpose:	Removes all the key phrases from the newly created asset
*********************************************************************************/
bool CMediaAsset::RemoveArticleAndMediaAssetKeyPhrases(int iMediaAssetID, int iH2G2ID)
{
	bool bOK = true;
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CMediaAssetSearchPhrase oMediaAssetSearchPhrase(m_InputContext,delimit);
	bOK = oMediaAssetSearchPhrase.RemoveAllKeyPhrasesFromAsset(iMediaAssetID);
	if (!bOK)
	{
		CopyDNALastError("CMediaAsset", oMediaAssetSearchPhrase);
		return bOK;
	}
	if (iH2G2ID > 0)
	{
		CArticleSearchPhrase oArticleSearchPhrase(m_InputContext,delimit);
		bOK = oArticleSearchPhrase.RemoveAllKeyPhrasesFromArticle(iH2G2ID);
		if (!bOK)
		{
			CopyDNALastError("CMediaAsset", oArticleSearchPhrase);
			return bOK;
		}
	}
	return bOK;

}

/*********************************************************************************

	bool CMediaAsset::GetMediaAssetKeyPhrases()

	Author:		Steven Francis
	Created:	27/10/2005
	Inputs:		iMediaAssetID, sMediaAssetKeyPhrases , bAsString
	Outputs:	-
	Returns:	bool
	Purpose:	Gets the key phrases for a media asset it can get just the native XML
				to go straight into the output XML or as a space delimited string
				to go into the update multi step
*********************************************************************************/
bool CMediaAsset::GetMediaAssetKeyPhrases(int iMediaAssetID, CTDVString &sMediaAssetKeyPhrases, bool bAsString)
{
	bool bOK = true;
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CMediaAssetSearchPhrase oMediaAssetSearchPhrase(m_InputContext,delimit);
	bOK = oMediaAssetSearchPhrase.GetKeyPhrasesFromAsset(iMediaAssetID);
	if (bOK)
	{
		if (bAsString)
		{
			//Build a space delimited string of the xml representation of the phrases
  			CTDVString sMediaAssetKeyPhrasesAsString = "";
			bool bFoundPhrase = false;

			bFoundPhrase = oMediaAssetSearchPhrase.FindFirstNode("PHRASE", NULL, false);
			while (bFoundPhrase)
			{
				if (oMediaAssetSearchPhrase.DoesChildTagExist("NAME"))
				{
  					CTDVString sKeyPhrase = "";

					oMediaAssetSearchPhrase.GetTextContentsOfChild("NAME", &sKeyPhrase);
					sMediaAssetKeyPhrasesAsString << sKeyPhrase;
					sMediaAssetKeyPhrasesAsString << " ";
				}
				bFoundPhrase = oMediaAssetSearchPhrase.NextNode();
			}
			
			sMediaAssetKeyPhrases = sMediaAssetKeyPhrasesAsString;
		}
		else
		{
            bOK = oMediaAssetSearchPhrase.GetAsString(sMediaAssetKeyPhrases);
		}
	}
	else
	{
		CopyDNALastError("CMediaAsset", oMediaAssetSearchPhrase);
	}
	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::GetFileDetails(int iContentType, int &iLength, CTDVString &sMimeType)

	Author:		Steven Francis
	Created:	10/11/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Gets the details of the file from the input context if there is one.
*********************************************************************************/
bool CMediaAsset::GetFileDetails(int &iContentType, CTDVString &sMimeType, int &iLength)
{
	bool bOK = true;

	// Get mime type and length
	if (!m_InputContext.GetNamedSectionMetadata("file", iLength, sMimeType))
	{
		return SetDNALastError("CMediaAsset", "GetFileDetails", "File Named section could not be found.");
	}

	// Make sure we actually have a file.
	if(iLength <= 0)
	{
		return SetDNALastError("CMediaAsset", "GetFileDetails", "Zero Length File input.");
	}
	// Make sure file is not too big.
	else if(iLength > GetMAXFileSize())
	{
		return SetDNALastError("CMediaAsset", "GetFileDetails", "File length greater than the maximum allowed.");
	}

	// Check if mime type is supported
	if (!IsMimeTypeSupported(sMimeType, iContentType))
	{
		//We don't support this type wwaaaarrggghh
		return SetDNALastError("CMediaAsset", "GetFileDetails", "Media Asset format not supported. " + sMimeType);
	}
	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::UploadMediaAsset(int iMediaAssetID, char *pFileBuffer, int iLength, bAddToLibrary)

	Author:		Steven Francis
	Created:	08/11/2005
	Inputs:		iMediaAssetID
				iLength = the length of the file
				pBuffer = the filebuffer itself
				bAddToLibrary = if the file is to go into the library or not
	Outputs:	-
	Returns:	bool
	Purpose:	Takes the input from the form and uploads the data to the media upload
				queue folder
*********************************************************************************/
bool CMediaAsset::UploadMediaAsset(int iMediaAssetID, const char *pFileBuffer, int iLength, bool bAddToLibrary, bool bSkipModeration)
{
	// Copy file to folder //
	// Make sure folder exists (c:\\mediaassetuploadqueue for time being) 
	//const char * sQueueFolder = "c:\\mediaassetuploadqueue";
	const char * sQueueFolder = m_InputContext.GetMediaAssetUploadQueueLocalDir();

	DWORD dwLastError;
	if(!CreateDirectory(sQueueFolder, NULL) && (dwLastError = GetLastError()) != ERROR_ALREADY_EXISTS)
	{
		CTDVString strError = "Error creating directory. " + (long)dwLastError;
		return SetDNALastError("CMediaAsset", "UploadMediaAsset", strError);
	}

	// Dump to disk
	//Needs to be addressed at a later date to allow to be made configurable
	CTDVString sFilename;
	sFilename << sQueueFolder << "\\" << iMediaAssetID;
	HANDLE hFile = CreateFile(sFilename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if(hFile == INVALID_HANDLE_VALUE)
	{
		return SetDNALastError("CMediaAsset", "UploadMediaAsset", "Unable to create Media asset File");
	}
    
	DWORD dwNumberOfBytesWritten;

	if(!WriteFile(hFile, pFileBuffer, iLength, &dwNumberOfBytesWritten, NULL))
	{
		DWORD dwError = GetLastError();
		CloseHandle(hFile);
	
		CTDVString strError = "Error writing to file." + (long)dwError;
		return SetDNALastError("CMediaAsset", "UploadMediaAsset", strError);
	}

	CloseHandle(hFile);

	// Add the asset to the queue
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "UploadMediaAsset", "m_InputContext.InitialiseStoredProcedureObject failed.");
	}

	CTDVString sServer;
	m_InputContext.GetServerName(&sServer);

	if(!SP.MediaAssetUploadQueueAdd(iMediaAssetID, sServer, bAddToLibrary, bSkipModeration))
	{
		return SetDNALastError("CMediaAsset", "UploadMediaAsset", "MediaAssetUploadQueueAdd failed");
	}
	
	return true;
}

/*********************************************************************************

	bool CMediaAsset::IsMimeTypeSupported()

	Author:		Steven Francis
	Created:	15/11/2005
	Inputs:		-
	Outputs:	iContentType - the type of the file (image audio video)
	Returns:	bool if the mimetype is supported
	Purpose:	Returns whether we support the mimetype, and the basic asset type
*********************************************************************************/
bool CMediaAsset::IsMimeTypeSupported(CTDVString sMimeType, int &iContentType)
{
	bool bOK = true;
	// Check if mime type is supported
	// This part should be extented as we add support
	// for more file formats
	if(sMimeType.CompareText("image/jpeg") 
		|| sMimeType.CompareText("image/pjpeg")
		|| sMimeType.CompareText("image/gif")
		|| sMimeType.CompareText("image/png"))
//		|| sMimeType.CompareText("image/bmp"))
	{
		iContentType = 1;
	}
	else if (sMimeType.CompareText("audio/mp3")
		|| sMimeType.CompareText("audio/mp2") 
		|| sMimeType.CompareText("audio/mpeg") 
		|| sMimeType.CompareText("audio/x-ms-wma")) 
	{
		iContentType = 2;
	}
	else if (sMimeType.CompareText("audio/x-pn-realaudio") 
		|| sMimeType.CompareText("video/quicktime")
		|| sMimeType.CompareText("video/x-ms-wmv")
		|| sMimeType.CompareText("video/rm")
		|| sMimeType.CompareText("application/vnd.rn-realmedia")
		|| sMimeType.CompareText("application/octet-stream")
		|| sMimeType.CompareText("application/x-shockwave-flash"))
	{
		iContentType = 3;
	}
	else
	{
		bOK = false;
	}
	return bOK;
}
/*********************************************************************************

	bool CMediaAsset::GetMAXFileSize()

	Author:		Steven Francis
	Created:	08/11/2005
	Inputs:		-
	Outputs:	-
	Returns:	int The maximum file size allowed
	Purpose:	Returns the MAX FileSize allowed - to allow to be made configurable
*********************************************************************************/
int CMediaAsset::GetMAXFileSize()
{
	// 5megs = 5242880 bytes (http://www.google.co.uk/search?hl=en&q=bytes+in+5+megabytes)
	// 1.5megs = 1572864  bytes (http://www.google.co.uk/search?hl=en&q=bytes+in+1.5+megabytes)
	int iMaxSize = 1572864;

	return iMaxSize;
}

/*********************************************************************************

	bool CMediaAsset::ExternalCreateMediaAsset()

	Author:		Steven Francis
	Created:	18/10/2005
	Inputs:		int& iMediaAssetID,
				int iSiteID, 
				const TDVCHAR* pCaption,
				const TDVCHAR* pFilename, 
				const TDVCHAR* pMimeType, 
				int iContentType,
				const TDVCHAR* pMultiElementsXML 
				int iOwnerID,
				const TDVCHAR* pMediaAssetKeyPhrases,
				const TDVCHAR* pDescription
				iLength = the length of the file
				sMimeType = the mimetype of the file
				pBuffer = the filebuffer itself
	Outputs:	sReturnedXML - The formed XML contained the created asset
							and the newly generated Media Asset
	Returns:	bool
	Purpose:	Public method to allow the caller to Create or Update a Media Asset, 
				calls the correct stored procedure based on if we have an Media Asset ID or not
*********************************************************************************/
bool CMediaAsset::ExternalCreateMediaAsset(int& iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType,
									const TDVCHAR* pMultiElementsXML, int iOwnerID, 
									const TDVCHAR* pMediaAssetKeyPhrases, const TDVCHAR* pDescription, bool bAddToLibrary,
									bool bManualUpload, const char *pFileBuffer, int iFileLength, bool bSkipModeration,
									const TDVCHAR* pExternalLinkURL, CTDVString& sReturnedXML)
{
	bool bOK = true;

	int iTotalUploadSize = 0; 
	int iHidden = 3; 
	bool bWithinLimit = true; 
	CTDVDateTime dtNextLimitStartDate;

	if (!bManualUpload)
	{
		//Check that the user is not over the weekly limit for uploads
		bOK = CheckUsersFileUploadLimit(iFileLength, iOwnerID, iTotalUploadSize, bWithinLimit, dtNextLimitStartDate);
	}

	if (bOK)
	{
		if (!bWithinLimit)
		{
			ExceedsUploadLimitErrorInfo(iFileLength, iTotalUploadSize, dtNextLimitStartDate);
			return SetDNALastError("CMediaAsset", "ExternalCreateMediaAsset - CheckUsersFileLimit", "User has exceeded weekly upload limit. ");
		}

		CTDVString strIPAddress = m_InputContext.GetIPAddress();
		//Try and create the media asset from the data given
		bOK = CreateUpdateMediaAsset(iMediaAssetID, iSiteID, pCaption, pFilename, pMimeType, iContentType, pMultiElementsXML, iOwnerID, pMediaAssetKeyPhrases, pDescription, bAddToLibrary, iFileLength, strIPAddress, bSkipModeration, iHidden, 0, pExternalLinkURL, sReturnedXML);

		if (bOK)
		{
			if(!bManualUpload)
			{
				//If it's an automatic upload then add the file to the Upload queue
				bOK = UploadMediaAsset(iMediaAssetID, pFileBuffer, iFileLength, bAddToLibrary, bSkipModeration);
			}
			else //Need to create an entry in the moderation queue for a manually entered media asset
			{
				//bOK = QueueMediaAssetForModeration(iMediaAssetID, iSiteID);
			}
		}
	}
	else
	{
		//Error in the actual stored procedure just return that
		return false;
	}

	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::GetArticlesAssets()

	Author:		Steven Francis
	Created:	30/11/2005
	Inputs:		int iH2G2ID
	Outputs:	int &iMediaAssetID
	Returns:	bool
	Purpose:	Public method to allow the caller to get the media asset xml linked
				to an article's h2g2id, stores the XML within the media asset object
				it is not a failure if no media asset id is retrieved ie no record exists
*********************************************************************************/
bool CMediaAsset::GetArticlesAssets(int iH2G2ID, int &iMediaAssetID, CTDVString& sMimeType, int& iHidden )
{
	iMediaAssetID = 0;
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "GetArticlesAssets", "m_InputContext.InitialiseStoredProcedureObject failed.");
	}

	if(!SP.GetArticlesAssets(iH2G2ID))
	{
		return SetDNALastError("CMediaAsset", "GetArticlesAssets", "GetArticlesAssets failed");
	}
	if(!SP.IsEOF())
	{
		iMediaAssetID = SP.GetIntField("MediaAssetID");
		SP.GetField("MimeType",sMimeType);
		iHidden = SP.GetIntField("Hidden");
	}

	return true;
}

/*********************************************************************************

	bool CMediaAsset::ExternalGetLinkedArticleAsset()

	Author:		Steven Francis
	Created:	30/11/2005
	Inputs:		int iH2G2ID,
				int iSiteID
	Outputs:	
	Returns:	bool
	Purpose:	Public method to allow the caller to get the media asset xml linked
				to an article's h2g2id, stores the XML within the media asset object
*********************************************************************************/
bool CMediaAsset::ExternalGetLinkedArticleAsset(int iH2G2ID, int iSiteID)
{
	bool bOk = false;
	int iMediaAssetID = 0;
	CTDVString sMimeType;
	int iHidden = 0;

	bOk = GetArticlesAssets(iH2G2ID, iMediaAssetID, sMimeType, iHidden);

	if (bOk)
	{
		if (iMediaAssetID > 0)
		{
			bOk = ViewMediaAsset(iMediaAssetID, iSiteID);
		}
		else
		{
			//No Assets linked to that article
			CTDVString sXML;

			InitialiseXMLBuilder(&sXML);
			bOk = bOk && OpenXMLTag("MEDIAASSETINFO");
			bOk = bOk && AddXMLIntTag("SUCCESS", 0);
			bOk = bOk && CloseXMLTag("MEDIAASSETINFO");
			if (bOk)
			{
				CreateFromXMLText(sXML);
			}
		}
	}

	return bOk;
}

/*********************************************************************************

	bool CMediaAsset::RemoveLinkedArticlesAssets()

	Author:		Steven Francis
	Created:	30/11/2005
	Inputs:		int iH2G2ID
	Outputs:	
	Returns:	bool
	Purpose:	Public method to allow the caller to get the media asset xml linked
				to an article's h2g2id, stores the XML within the media asset object
				it is not a failure if no media asset id is retrieved ie no record exists
*********************************************************************************/
bool CMediaAsset::RemoveLinkedArticlesAssets(int iH2G2ID)
{
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "RemoveLinkedArticlesAssets", "m_InputContext.InitialiseStoredProcedureObject failed.");
	}

	if(!SP.RemoveLinkedArticlesAssets(iH2G2ID))
	{
		return SetDNALastError("CMediaAsset", "RemoveLinkedArticlesAssets", "RemoveLinkedArticlesAssets failed");
	}

	return true;
}

/*********************************************************************************

	bool CMediaAsset::ExternalRemoveLinkedArticleAsset()

	Author:		Steven Francis
	Created:	30/11/2005
	Inputs:		int iH2G2ID,
	Outputs:	
	Returns:	bool
	Purpose:	Public method to allow the caller to remove the media asset xml linked
				to an article's h2g2id
*********************************************************************************/
bool CMediaAsset::ExternalRemoveLinkedArticleAsset(int iH2G2ID)
{
	bool bOk = false;

	bOk = RemoveLinkedArticlesAssets(iH2G2ID);

	if (bOk)
	{
		CTDVString sXML;

		InitialiseXMLBuilder(&sXML);
		bOk = bOk && OpenXMLTag("MEDIAASSETINFO");
		bOk = bOk && AddXMLIntTag("REMOVED", 1);
		bOk = bOk && CloseXMLTag("MEDIAASSETINFO");
		if (bOk)
		{
			CreateFromXMLText(sXML);
		}
	}

	return bOk;
}

/*********************************************************************************

	bool CMediaAsset::ViewUsersMediaAssets()

	Author:		Steven Francis
	Created:	05/12/2005
	Inputs:		- int iUserID, int iContentType, bool bOwner, CDTVString sSortBy
	Outputs:	-
	Returns:	bool
	Purpose:	Generate the XML page to show the a	particular users Media Assets
*********************************************************************************/
bool CMediaAsset::ViewUsersMediaAssets(int iUserID, int iContentType, bool bOwner, CTDVString sSortBy)
{
	CStoredProcedure SP;

	bool bOk = true;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "ViewUsersMediaAssets", "InitialiseStoredProcedureObject Failed");
	}
	else
	{
		InitialiseXMLBuilder(NULL,&SP);

		// Get the media assets associated with the given user
		int iNumResults = 0;
		int iSkip = 0;	
		if (m_InputContext.ParamExists("skip"))
		{
			iSkip = m_InputContext.GetParamInt("skip");
		}

		int iShow = 0;	
		if (m_InputContext.ParamExists("show"))
		{
			iShow = m_InputContext.GetParamInt("show");
		}

		if (iShow==0)
		{
			iShow=20;
		}

		if (SP.GetUsersMediaAssets(iUserID, iContentType, iSkip, iShow, bOwner, sSortBy ))
		{
			bOk = bOk && OpenXMLTag("MEDIAASSETINFO", true);
				bOk = bOk && AddXMLIntAttribute("ContentType", iContentType);
				bOk = bOk && AddXMLAttribute("SORTBY", sSortBy, false);
				bOk = bOk && AddXMLIntAttribute("SKIPTO", iSkip);
				bOk = bOk && AddXMLIntAttribute("SHOW", iShow);
				bOk = bOk && AddXMLIntAttribute("COUNT", SP.IsEOF() ? 0 : SP.GetIntField("COUNT"));
				bOk = bOk && AddXMLIntAttribute("TOTAL", SP.IsEOF() ? 0 : SP.GetIntField("TOTAL"));
				bOk = bOk && AddXMLIntAttribute("MORE", SP.GetIntField("TOTAL") > iSkip + iShow, true);
				bOk = bOk && AddXMLTag("ACTION", "showusersassets");
						
				CTDVString sUserXMLBlock;
				CUser oUser(m_InputContext);
				oUser.CreateFromID(iUserID);
				oUser.GetAsString(sUserXMLBlock);
				bOk = bOk && AddXMLTag("", sUserXMLBlock);
				//bOk = bOk && AddXMLIntTag("USERSID", iUserID);

				if(!SP.IsEOF())
				{
					while(!SP.IsEOF())
					{
						CTDVString sMediaAssetKeyPhrases;
						CTDVString sUserXMLBlock;
						CTDVString sFTPPath;
						int iOwnerID = 0;

						bOk = bOk && OpenXMLTag("MEDIAASSET", true);
							int iMediaAssetID = SP.GetIntField("ID");
							bOk = bOk && AddXMLIntAttribute("MEDIAASSETID", iMediaAssetID, true);

							bOk = bOk && GenerateFTPDirectoryString(iMediaAssetID, sFTPPath);

							bOk = bOk && AddXMLTag("FTPPATH", sFTPPath);

							bOk = bOk && AddDBXMLIntTag("SITEID");
							bOk = bOk && AddDBXMLTag("CAPTION", NULL, false, true);
							bOk = bOk && AddDBXMLTag("FILENAME", NULL, false, true);
							bOk = bOk && AddDBXMLTag("MIMETYPE", NULL, false, true);
							bOk = bOk && AddDBXMLIntTag("CONTENTTYPE");

						//Extra extendedable element stuff removed for time being
							bOk = bOk && AddDBXMLTag("EXTRAELEMENTXML", NULL, false, false);

							//Get the KeyPhrase XML to add into returned XML
							bOk = bOk && GetMediaAssetKeyPhrases(iMediaAssetID, sMediaAssetKeyPhrases);
							bOk = bOk && AddXMLTag("", sMediaAssetKeyPhrases);

							iOwnerID = SP.GetIntField("OWNERID");
							oUser.CreateFromID(iOwnerID);
							oUser.GetAsString(sUserXMLBlock);

							bOk = bOk && AddXMLTag("OWNER", sUserXMLBlock);
								
							//bOk = bOk && AddDBXMLIntTag("OWNERID");
							bOk = bOk && AddDBXMLTag("Description", "MEDIAASSETDESCRIPTION", false, true);

							bOk = bOk && AddDBXMLDateTag("DATECREATED", NULL, false);
							bOk = bOk && AddDBXMLDateTag("LASTUPDATED", NULL, false);
							bOk = bOk && AddDBXMLIntTag("HIDDEN", NULL, false);
									
							CTDVString sExternalLinkURL="";
							CTDVString sExternalLinkID="";
							CTDVString sExternalLinkType="";

							CTDVString sFlickrFarmPath=""; 
							CTDVString sFlickrServer=""; 
							CTDVString sFlickrID=""; 
							CTDVString sFlickrSecret=""; 
							CTDVString sFlickrSize="";

							SP.GetField("EXTERNALLINKURL", sExternalLinkURL);
							GetIDFromLink(sExternalLinkURL, 
											sExternalLinkID, 
											sExternalLinkType, 
											sFlickrFarmPath, 
											sFlickrServer, 
											sFlickrID, 
											sFlickrSecret, 
											sFlickrSize);

							bOk = bOk && AddXMLTag("EXTERNALLINKTYPE", sExternalLinkType);
							bOk = bOk && AddDBXMLTag("EXTERNALLINKURL", NULL, false, true);
							bOk = bOk && AddXMLTag("EXTERNALLINKID", sExternalLinkID);

							bOk = bOk && OpenXMLTag("FLICKR", false);
							bOk = bOk && AddXMLTag("FARMPATH", sFlickrFarmPath);
							bOk = bOk && AddXMLTag("SERVER", sFlickrServer);
							bOk = bOk && AddXMLTag("ID", sFlickrID);
							bOk = bOk && AddXMLTag("SECRET", sFlickrSecret);
							bOk = bOk && AddXMLTag("SIZE", sFlickrSize);
							bOk = bOk && CloseXMLTag("FLICKR");

						bOk = bOk && CloseXMLTag("MEDIAASSET");

						SP.MoveNext();

					}
				}

			bOk = bOk && CloseXMLTag("MEDIAASSETINFO");

			if (bOk)
			{
				CTDVString sMediaAssetXML;
				sMediaAssetXML = GetBuilderXML();
				CreateFromXMLText(sMediaAssetXML);
			}
		}
		else
		{
			return SetDNALastError("CMediaAsset", "ViewUsersMediaAssets", "ViewUsersMediaAssets Stored procedure failed");
		}
	}
	return bOk;
}

/*********************************************************************************

	bool CMediaAsset::ViewUsersArticlesMediaAssets()

	Author:		Steven Francis
	Created:	05/12/2005
	Inputs:		- int iUserID, int iContentType, bool bOwner, CDTVString sSortBy
	Outputs:	-
	Returns:	bool
	Purpose:	Generate the XML page to show the as particular users Media Assets
*********************************************************************************/
bool CMediaAsset::ViewUsersArticlesWithMediaAssets(int iUserID, int iContentType, bool bOwner, CTDVString sSortBy)
{
	CStoredProcedure SP;

	bool bOk = true;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "ViewUsersArticlesMediaAssets", "InitialiseStoredProcedureObject Failed");
	}
	else
	{
		InitialiseXMLBuilder(NULL,&SP);

		// Get the media assets associated with the given user
		int iNumResults = 0;
		int iSkip = 0;	
		if (m_InputContext.ParamExists("skip"))
		{
			iSkip = m_InputContext.GetParamInt("skip");
		}

		int iShow = 0;	
		if (m_InputContext.ParamExists("show"))
		{
			iShow = m_InputContext.GetParamInt("show");
		}

		if (iShow==0)
		{
			iShow=20;
		}

		if (SP.GetUsersArticlesWithMediaAssets(iUserID, iContentType, iSkip, iShow, bOwner, sSortBy))
		{
			bOk = bOk && OpenXMLTag("ARTICLEMEDIAASSETINFO", true);
				bOk = bOk && AddXMLIntAttribute("ContentType", iContentType);
				bOk = bOk && AddXMLAttribute("SORTBY", sSortBy, false);
				bOk = bOk && AddXMLIntAttribute("SKIPTO", iSkip);
				bOk = bOk && AddXMLIntAttribute("SHOW", iShow);
				bOk = bOk && AddXMLIntAttribute("COUNT", SP.IsEOF() ? 0 : SP.GetIntField("COUNT"));
				bOk = bOk && AddXMLIntAttribute("TOTAL", SP.IsEOF() ? 0 : SP.GetIntField("TOTAL"));
				bOk = bOk && AddXMLIntAttribute("MORE", SP.GetIntField("TOTAL") > iSkip + iShow, true);
				bOk = bOk && AddXMLTag("ACTION", "showusersarticleswithassets");
						
				CTDVString sUserXMLBlock;
				CUser oUser(m_InputContext);
				oUser.CreateFromID(iUserID);
				oUser.GetAsString(sUserXMLBlock);
				bOk = bOk && AddXMLTag("", sUserXMLBlock);
				//bOk = bOk && AddXMLIntTag("USERSID", iUserID);

				if(!SP.IsEOF())
				{
					while(!SP.IsEOF())
					{
						CTDVString sMediaAssetKeyPhrases;
						CTDVString sEditorXMLBlock;
						CTDVString sUserXMLBlock;
						CTDVString sFTPPath;
						int iEditor = 0;
						int iOwnerID = 0;

						OpenXMLTag("ARTICLE",true);
						int iH2G2ID = SP.GetIntField("H2G2ID");
						bOk = bOk && AddXMLIntAttribute("H2G2ID", iH2G2ID, true);

						bOk = bOk && AddDBXMLTag("SUBJECT", 0, false);

						iEditor = SP.GetIntField("editor");
						oUser.CreateFromID(iEditor);
						oUser.GetAsString(sEditorXMLBlock);

						bOk = bOk && AddDBXMLTag("EXTRAINFO","",false,false);

						bOk = bOk && AddXMLTag("EDITOR", sEditorXMLBlock);
						bOk = bOk && AddDBXMLDateTag("DATECREATED", 0, false);
						bOk = bOk && AddDBXMLDateTag("LASTUPDATED", 0, false);

							bOk = bOk && OpenXMLTag("MEDIAASSET", true);
								int iMediaAssetID = SP.GetIntField("ID");
								bOk = bOk && AddXMLIntAttribute("MEDIAASSETID", iMediaAssetID, true);

								bOk = bOk && GenerateFTPDirectoryString(iMediaAssetID, sFTPPath);

								bOk = bOk && AddXMLTag("FTPPATH", sFTPPath);

								bOk = bOk && AddDBXMLIntTag("SITEID");
								bOk = bOk && AddDBXMLTag("CAPTION", NULL, false, true);
								bOk = bOk && AddDBXMLTag("FILENAME", NULL, false, true);
								bOk = bOk && AddDBXMLTag("MIMETYPE", NULL, false, true);
								bOk = bOk && AddDBXMLIntTag("CONTENTTYPE");

							//Extra extendedable element stuff removed for time being
								bOk = bOk && AddDBXMLTag("EXTRAELEMENTXML", NULL, false, false);

								//Get the KeyPhrase XML to add into returned XML
								bOk = bOk && GetMediaAssetKeyPhrases(iMediaAssetID, sMediaAssetKeyPhrases);
								bOk = bOk && AddXMLTag("", sMediaAssetKeyPhrases);

								iOwnerID = SP.GetIntField("OWNERID");
								oUser.CreateFromID(iOwnerID);
								oUser.GetAsString(sUserXMLBlock);

								bOk = bOk && AddXMLTag("OWNER", sUserXMLBlock);
									
								//bOk = bOk && AddDBXMLIntTag("OWNERID");
								bOk = bOk && AddDBXMLTag("Description", "MEDIAASSETDESCRIPTION", false, true);

								bOk = bOk && AddDBXMLDateTag("DATECREATED", NULL, false);
								bOk = bOk && AddDBXMLDateTag("LASTUPDATED", NULL, false);
								bOk = bOk && AddDBXMLIntTag("HIDDEN", NULL, false);
						
								CTDVString sExternalLinkURL="";
								CTDVString sExternalLinkID="";
								CTDVString sExternalLinkType="";
								CTDVString sFlickrFarmPath=""; 
								CTDVString sFlickrServer=""; 
								CTDVString sFlickrID=""; 
								CTDVString sFlickrSecret=""; 
								CTDVString sFlickrSize="";

								SP.GetField("EXTERNALLINKURL", sExternalLinkURL);
								GetIDFromLink(sExternalLinkURL, 
												sExternalLinkID, 
												sExternalLinkType, 
												sFlickrFarmPath, 
												sFlickrServer, 
												sFlickrID, 
												sFlickrSecret, 
												sFlickrSize);
								
								bOk = bOk && AddXMLTag("EXTERNALLINKTYPE", sExternalLinkType);
								bOk = bOk && AddDBXMLTag("EXTERNALLINKURL", NULL, false, true);
								bOk = bOk && AddXMLTag("EXTERNALLINKID", sExternalLinkID);
							
								bOk = bOk && OpenXMLTag("FLICKR", false);
								bOk = bOk && AddXMLTag("FARMPATH", sFlickrFarmPath);
								bOk = bOk && AddXMLTag("SERVER", sFlickrServer);
								bOk = bOk && AddXMLTag("ID", sFlickrID);
								bOk = bOk && AddXMLTag("SECRET", sFlickrSecret);
								bOk = bOk && AddXMLTag("SIZE", sFlickrSize);
								bOk = bOk && CloseXMLTag("FLICKR");

								// Get Content rating data
								int nCRPollID = SP.GetIntField("CRPollID");

								// Add Content rating
								if(nCRPollID)
								{
									CPollContentRating Poll(m_InputContext, nCRPollID);

									Poll.SetContentRatingStatistics(SP.GetIntField("CRVoteCount"), 
										SP.GetDoubleField("CRAverageRating"));
									
									// Generate XML without poll results, just stats
									if(!Poll.MakePollXML(CPoll::PollLink(nCRPollID, false), false))
									{
										TDVASSERT(false, "CMediaAsset::ViewUsersArticlesMediaAssets pPoll->MakePollXML failed");
									}
									else 
									{
										CTDVString sPollXML;
										if(!Poll.GetAsString(sPollXML))
										{
											TDVASSERT(false, "CMediaAsset::ViewUsersArticlesMediaAssets Poll.GetAsString failed");
										}
										else
										{
											bOk = bOk && AddXMLTag("", sPollXML);
										}
									}
								}
							bOk = bOk && CloseXMLTag("MEDIAASSET");

						bOk = bOk && CloseXMLTag("ARTICLE");

						SP.MoveNext();
					}
				}

			bOk = bOk && CloseXMLTag("ARTICLEMEDIAASSETINFO");

			if (bOk)
			{
				CTDVString sArticlesMediaAssetXML;
				sArticlesMediaAssetXML = GetBuilderXML();
				CreateFromXMLText(sArticlesMediaAssetXML);
			}
		}
		else
		{
			return SetDNALastError("CMediaAsset", "ViewUsersArticlesMediaAssets", "ViewUsersArticlesMediaAssets Stored procedure failed");
		}
	}
	return bOk;
}

/*********************************************************************************

	bool CMediaAsset::GenerateFTPDirectoryString()

	Author:		Steven Francis
	Created:	08/12/2005
	Inputs:		int iMediaAssetID
	Outputs:	
	Returns:	bool
	Purpose:	Method that will produce the FTP directory path from the Media Asset ID
				This is for the limit of files within a unix folder to function well
				we basically take the ID and divide it a number of times to get
				sub directories
*********************************************************************************/
bool CMediaAsset::GenerateFTPDirectoryString(int iMediaAssetID, CTDVString& sFTPDirectory)
{
	CTDVString FirstCut  = (iMediaAssetID / FIRSTCUT);
	CTDVString SecondCut = (iMediaAssetID / SECONDCUT);
	CTDVString ThirdCut  = (iMediaAssetID / THIRDCUT);

	sFTPDirectory = FirstCut + "/" + SecondCut + "/" + ThirdCut + "/";


	return true;
}


/*********************************************************************************

	bool CMediaAsset::ExternalPreviewMediaAsset()

	Author:		Steven Francis
	Created:	20/12/2005
	Inputs:		int iSiteID, 
				const TDVCHAR* pCaption,
				const TDVCHAR* pFilename, 
				const TDVCHAR* pMimeType, 
				int iContentType,
				const TDVCHAR* pMultiElementsXML 
				int iOwnerID,
				const TDVCHAR* pMediaAssetKeyPhrases,
				const TDVCHAR* pDescription

	Outputs:	sReturnedXML - The formed XML contained the created asset
	Returns:	bool
	Purpose:	Creates or Updates a Media Asset, calls the correct stored procedure based 
				on if we have an Media Asset ID or not
*********************************************************************************/
bool CMediaAsset::ExternalPreviewMediaAsset(int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType,
									const TDVCHAR* pMultiElementsXML, int iOwnerID, 
									const TDVCHAR* pMediaAssetKeyPhrases, const TDVCHAR* pDescription,
									bool bAddToLibrary, CTDVString& sReturnedXML)
{
	bool bOk = true;
	CTDVDateTime dtNow = CTDVDateTime::GetCurrentTime();	

	bOk = CreateMediaAssetXML(0, iSiteID, pCaption,
									pFilename, pMimeType, iContentType, 
									pMultiElementsXML, iOwnerID, pDescription, 
									false, dtNow, dtNow, sReturnedXML, true, pMediaAssetKeyPhrases);
	return bOk;

}

/*********************************************************************************

	bool CMediaAsset::GetImageFormat()

	Author:		Steven Francis
	Created:	03/01/2006
	Inputs:		CTDVString sMimeType, 
				CTDVString& sFileSuffix
	Outputs:	-
	Returns:	bool
	Purpose:	Function to get the Image Format for the given Image.
*********************************************************************************/
bool CMediaAsset::GetImageFormat(CTDVString sMimeType, CTDVString& sFileSuffix)
{
	sFileSuffix = "unidentified format";

	if (sMimeType.CompareText("image/jpeg") || sMimeType.CompareText("image/pjpeg"))
	{
		sFileSuffix = ".jpg";
	}
	else if (sMimeType.CompareText("image/gif"))
	{
		sFileSuffix = ".gif";
	}
	else if (sMimeType.CompareText("image/bmp"))
	{
		sFileSuffix = ".bmp";
	}
	else if (sMimeType.CompareText("image/png"))
	{
		sFileSuffix = ".png";
	}
	else
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CMediaAsset::GetAudioSuffix()

	Author:		Steven Francis
	Created:	03/01/2006
	Inputs:		CTDVString sMimeType, 
				CTDVString& sFileSuffix
	Outputs:	-
	Returns:	bool
	Purpose:	Function to get the Audio file suffix for the given Audio asset.
*********************************************************************************/
bool CMediaAsset::GetAudioSuffix(CTDVString sMimeType, CTDVString& sFileSuffix)
{
	sFileSuffix = "unidentified format";

	if (sMimeType.CompareText("audio/mpeg") || sMimeType.CompareText("audio/mp3"))
	{
		sFileSuffix = ".mp3";
	}
	if (sMimeType.CompareText("audio/mp2"))
	{
		sFileSuffix = ".mp2";
	}
	else if (sMimeType.CompareText("audio/wav"))
	{
		sFileSuffix = ".wav";
	}
	else if (sMimeType.CompareText("audio/aud"))
	{
		sFileSuffix = ".aud";
	}
	else if (sMimeType.CompareText("audio/x-ms-wma"))
	{
		sFileSuffix = ".wma";
	}
	else
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CMediaAsset::GetVideoSuffix()

	Author:		Steven Francis
	Created:	24/01/2006
	Inputs:		CTDVString sMimeType, 
				CTDVString& sFileSuffix
	Outputs:	-
	Returns:	bool
	Purpose:	Function to get the Video file suffix for the given Video asset.
*********************************************************************************/
bool CMediaAsset::GetVideoSuffix(CTDVString sMimeType, CTDVString& sFileSuffix)
{
	sFileSuffix = "unidentified format";

	if (sMimeType.CompareText("application/vnd.rn-realmedia"))
	{
		sFileSuffix = ".rm";
	}
	else if (sMimeType.CompareText("video/avi") || sMimeType.CompareText("video/mpeg") || sMimeType.CompareText("video/x-msvideo") )
	{
		sFileSuffix = ".avi";
	}
	else if (sMimeType.CompareText("application/octet-stream") || sMimeType.CompareText("video/quicktime"))
	{
		sFileSuffix = ".mov";
	}
	else if (sMimeType.CompareText("video/x-ms-wmv"))
	{
		sFileSuffix = ".wmv";
	}
	else if (sMimeType.CompareText("application/x-shockwave-flash"))
	{
		sFileSuffix = ".swf";
	}
	else
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CMediaAsset::QueueMediaAssetForModeration()

	Author:		Steven Francis
	Created:	03/01/2006
	Inputs:		int iMediaAssetID, 
				int iSiteID
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to add the specified Asset onto the
				Moderation Queue
				NB - Deciding to now do this in the C# service after the asset has been
				processed and actually is available to be moderated/looked at.
				This may be needed at a later date to re-queue the media asset.
*********************************************************************************/
bool CMediaAsset::QueueMediaAssetForModeration(int iMediaAssetID, int iSiteID)
{
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "QueueMediaAssetForModeration", "m_InputContext.InitialiseStoredProcedureObject failed.");
	}

	if(!SP.QueueMediaAssetForModeration(iMediaAssetID, iSiteID))
	{
		return SetDNALastError("CMediaAsset", "QueueMediaAssetForModeration", "QueueMediaAssetForModeration failed");
	}

	return true;
}

/*********************************************************************************

	bool CMediaAsset::CheckUsersFileUploadLimit()

	Author:		Steven Francis
	Created:	17/01/2006
	Inputs:		int iFileLength, 
				int iCurrentUserID
				
	Outputs:	int iTotalUploaded
				bool bWithinLimit
				CTDVDateTime dtNextLimitStartDate

	Returns:	bool
	Purpose:	Calls the stored procedure to check the users upload limit 
	            against the new file size (in essence to allow the upload or not)
********************************************************************************/
bool CMediaAsset::CheckUsersFileUploadLimit(int iFileLength, int iCurrentUserID, int &iTotalUploadSize, bool &bWithinLimit, CTDVDateTime &dtNextLimitStartDate)
{
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAsset", "CheckUsersFileUploadLimit", "m_InputContext.InitialiseStoredProcedureObject failed.");
	}

	if(!SP.CheckUsersFileUploadLimit(iFileLength, iCurrentUserID))
	{
		return SetDNALastError("CMediaAsset", "CheckUsersFileUploadLimit", "CheckUsersFileUploadLimit failed");
	}							
	
	iTotalUploadSize = SP.GetIntField("TotalUploadSize");

	bWithinLimit = SP.GetBoolField("WithinLimit");

	dtNextLimitStartDate = SP.GetDateField("NextLimitStartDate");
		
	return true;
}

/*********************************************************************************

	bool CMediaAsset::ExceedsUploadLimitErrorInfo()

	Author:		Steven Francis
	Created:	17/01/2006
	Inputs:		int iTotalUploaded
				bool bWithinLimit
				CTDVDateTime dtNextLimitStartDate
	Outputs:	-
	Returns:	bool
	Purpose:	Generates the XML for the Media Asset object in the case
				of the user exceeding the upload limit
*********************************************************************************/
bool CMediaAsset::ExceedsUploadLimitErrorInfo(int iFileLength, int &iTotalUploadSize, CTDVDateTime &dtNextLimitStartDate)
{
	CTDVString sMediaAssetXML;

	CTDVString strDateXML;
	dtNextLimitStartDate.GetAsXML(strDateXML);

	sMediaAssetXML << "<EXCEEDEDUPLOADLIMITERRORINFO>";
	sMediaAssetXML << "<TOTALUPLOADSIZE>";
	sMediaAssetXML << iTotalUploadSize;
	sMediaAssetXML << "</TOTALUPLOADSIZE>";
	sMediaAssetXML << "<FILELENGTH>";
	sMediaAssetXML << iFileLength;
	sMediaAssetXML << "</FILELENGTH>";
	sMediaAssetXML << "<NEXTLIMITSTARTDATE>";
	sMediaAssetXML << strDateXML;
	sMediaAssetXML << "</NEXTLIMITSTARTDATE>";
	sMediaAssetXML << "</EXCEEDEDUPLOADLIMITERRORINFO>";

	CreateFromXMLText(sMediaAssetXML);

	return true;
}

/*********************************************************************************

	bool CMediaAsset::FixMimeType()

	Author:		Steven Francis
	Created:	08/03/2006
	Inputs:		CTDVString sInMimeType, 
	Outputs:	CTDVString sFixedMimeType
	Returns:	bool
	Purpose:	Function to transpose dodgy mimetypes from the skin into the correct one.
		        Only correct mimetypes to be stored in the database
*********************************************************************************/
bool CMediaAsset::FixMimeType(CTDVString sInMimeType, CTDVString& sFixedMimeType)
{
	CTDVString sMimeType(sInMimeType);
	
	sMimeType.MakeUpper();
	if (sMimeType.CompareText("MP3"))
	{
		sFixedMimeType = "audio/mp3";
	}
	else if (sMimeType.CompareText("MP2"))
	{
		sFixedMimeType = "audio/mp2";
	}
	else if (sMimeType.CompareText("MP1"))
	{
		sFixedMimeType = "audio/mp1";
	}
	else if (sMimeType.CompareText("IMAGE/JPG"))
	{
		sFixedMimeType = "image/jpeg";
	}
	else if (sMimeType.CompareText("AVI")) 
	{
		sFixedMimeType = "video/avi";		 
	}
	else if (sMimeType.CompareText("WAV")) 
	{
		sFixedMimeType = "audio/wav";		 
	}
	else if (sMimeType.CompareText("MOV")) 
	{
		sFixedMimeType = "video/quicktime";		 
	}
	else if (sMimeType.CompareText("RM")) 
	{
		sFixedMimeType = "application/vnd.rn-realmedia";		 
	}
	else if (sMimeType.CompareText("WMV")) 
	{
		sFixedMimeType = "video/x-ms-wmv";		 
	}
	else
	{
		sFixedMimeType = sInMimeType;
	}
	return true;
}

/*********************************************************************************

	bool CMediaAsset::GetExternalIDFromLink()

	Author:		Steven Francis
	Created:	06/07/2006
	Inputs:		CTDVString sInLink,
				CTDVString sInPreFix
	Outputs:	CTDVString sOutExternalID
	Returns:	bool
	Purpose:	Function to generate the External site ID from the URL Link and the external site prefix
*********************************************************************************/
bool CMediaAsset::GetExternalIDFromLink(CTDVString sInLink, CTDVString sInPreFix, CTDVString& sOutExternalID)
{
	bool bOK = false;
	CTDVString sExternalID="";
	CTDVString sLink(sInLink);

	int iStartTypePos = sLink.Find(sInPreFix);
	if (iStartTypePos > -1)
	{
		iStartTypePos = iStartTypePos + sInPreFix.GetLength();

		sExternalID = sLink.Mid(iStartTypePos);

		if (sExternalID != "")
		{
			sOutExternalID = sExternalID;
			bOK = true;
		}
	}
	return bOK;
}

/*********************************************************************************

	bool CMediaAsset::GetIDFromLink()

	Author:		Steven Francis
	Created:	06/07/2006
	Inputs:		CTDVString sInLink, 
	Outputs:	CTDVString sOutID,
				CTDVString& sOutType
	Returns:	bool
	Purpose:	Function to generate the ID from the URL Link checks against a YouTube or a Google Video Link
*********************************************************************************/
bool CMediaAsset::GetIDFromLink(CTDVString sInLink, 
								CTDVString& sOutID, 
								CTDVString& sOutType, 
								CTDVString& sOutFlickrFarmPath, 
								CTDVString& sOutFlickrServer, 
								CTDVString& sOutFlickrID, 
								CTDVString& sOutFlickrSecret, 
								CTDVString& sOutFlickrSize)
{
	CTDVString sYouTubePreFix="http://www.youtube.com/watch?v=";
	CTDVString sYouTubeUKPreFix="http://uk.youtube.com/watch?v=";
	CTDVString sMySpaceVideoPreFix="http://vids.myspace.com/index.cfm?fuseaction=vids.individual&amp;videoid=";
	CTDVString sGoogleVideoPreFix="http://video.google.com/videoplay?docid=";
	CTDVString sGoogleVideoUKPreFix="http://video.google.co.uk/videoplay?docid=";

	GetExternalIDFromLink(sInLink, sGoogleVideoPreFix, sOutID);
	if (sOutID != "")
	{
		sOutType = "Google";
		return true;
	}

	GetExternalIDFromLink(sInLink, sGoogleVideoUKPreFix, sOutID);
	if (sOutID != "")
	{
		sOutType = "Google";
		return true;
	}

	GetExternalIDFromLink(sInLink, sYouTubePreFix, sOutID);
	if (sOutID != "")
	{
		sOutType = "YouTube";
		return true;
	}

	GetExternalIDFromLink(sInLink, sYouTubeUKPreFix, sOutID);
	if (sOutID != "")
	{
		sOutType = "YouTube";
		return true;
	}

	GetExternalIDFromLink(sInLink, sMySpaceVideoPreFix, sOutID);
	if (sOutID != "")
	{
		sOutType = "MySpace";
		return true;
	}

    if (TryGetExternalFlickrIDFromLink(sInLink, 
        sOutFlickrFarmPath, 
        sOutFlickrServer, 
        sOutFlickrID, 
        sOutFlickrSecret, 
        sOutFlickrSize))
    {
        sOutType = "Flickr";
        sOutID = sOutFlickrID;
        return true;
    }

	sOutType = "Unknown";
	return false;

}

/*********************************************************************************

	bool CMediaAsset::TryGetExternalFlickrIDFromLink()

	Author:		Steven Francis
	Created:	04/10/2007
	Inputs:		CTDVString sInLink, 
	Outputs:	CTDVString& sOutFlickrFarmPath, 
				CTDVString& sOutFlickrServer, 
				CTDVString& sOutFlickrID, 
				CTDVString& sOutFlickrSecret, 
				CTDVString& sOutFlickrSize
	Returns:	bool
	Purpose:	Function to extract the Flickr info from the Flickr URL Link

<remarks> http://farm2.static.flickr.com/1097/1476511645_99659656ec_t.jpg</remarks>
<remarks> [Server farm path]/[server]/[ID]_[Secret]_[size].jpg</remarks>
*********************************************************************************/
bool CMediaAsset::TryGetExternalFlickrIDFromLink(CTDVString sInLink, 
												 CTDVString& sOutFlickrFarmPath, 
												 CTDVString& sOutFlickrServer, 
												 CTDVString& sOutFlickrID, 
												 CTDVString& sOutFlickrSecret, 
												 CTDVString& sOutFlickrSize)
{
    CTDVString sFlickrImagePreFix = ".static.flickr.com/";

    bool OK = false;

    bool bMediumSizedPhoto = false;

    try
    {
        int iStartFlickrTypePos = sInLink.Find(sFlickrImagePreFix);
        if (iStartFlickrTypePos > -1)
        {
            int iStartServerPos = (iStartFlickrTypePos + sFlickrImagePreFix.GetLength());

            int iStartFlickrIDPos = sInLink.Find("/", iStartServerPos + 1) + 1;
            int iStartFlickrSecretPos = sInLink.Find("_", iStartFlickrIDPos + 1) + 1;
            int iStartFlickrSizePos = sInLink.Find("_", iStartFlickrSecretPos + 1) + 1;
			//If we do not have another '_' then it is a medium size photo url they have dropped in
			if (iStartFlickrSizePos == 0)
			{
				bMediumSizedPhoto = true;
				iStartFlickrSizePos = sInLink.Find(".", iStartFlickrSecretPos + 1) + 1;
			}

            sOutFlickrFarmPath = sInLink.Mid(0, iStartServerPos);

            sOutFlickrServer = sInLink.Mid(iStartServerPos, iStartFlickrIDPos - iStartServerPos - 1);
            sOutFlickrID = sInLink.Mid(iStartFlickrIDPos, iStartFlickrSecretPos - iStartFlickrIDPos - 1);
            sOutFlickrSecret = sInLink.Mid(iStartFlickrSecretPos, iStartFlickrSizePos - iStartFlickrSecretPos - 1);
			if (bMediumSizedPhoto)
			{
				sOutFlickrSize = "";
			}
			else
			{
				sOutFlickrSize = sInLink.Mid(iStartFlickrSizePos, 1);
			}

            if (sOutFlickrFarmPath != "" && 
				sOutFlickrServer != "" && 
				sOutFlickrID != "" && 
				sOutFlickrSecret != "")
            {
                OK = true;
            }
        }
    }
    catch (char * str )
    {
        //One of the index or subsstring arguments is outside the constraints of the original string so 
        //mal formed flickr link
        CTDVString exceptionMessage(str);
        OK = false;
    }
    return OK;
}
        