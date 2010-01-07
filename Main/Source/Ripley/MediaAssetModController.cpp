// MediaAssetModController.cpp: implementation of the CMediaAssetModController class.
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
#include "User.h"
#include "MediaAsset.h"
#include "MediaAssetModController.h"
#include "Config.h"


const char* const MEDIAASSETFTPSERVER = "ftp-gw.reith.bbc.co.uk";
const char* const MEDIAASSETFTPUSER = "dna_ftp@ftp.bbc.co.uk";
const char* const MEDIAASSETFTPPASS = "mylpax37";

const char* const MEDIAASSETFTPDIR = "rmhttp/dnauploads/";

const char* const MODERATIONSUFFIX = ".mod";
const char* const FAILEDSUFFIX = ".fail";

const char* const RAWEXTENSION		=	"_raw";
const char* const THUMBEXTENSION	=	"_thumb";
const char* const PREVIEWEXTENSION	=	"_preview";
const char* const ARTICLEEXTENSION	=	"_article";


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMediaAssetModController::CMediaAssetModController(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CMediaAssetModController::~CMediaAssetModController(void)
{
}

/*********************************************************************************

	bool CMediaAssetModController::Approve(int iMediaAssetID, CTDVString strMimeType)

	Author:		Steven Francis
	Created:	23/12/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Function to modify the file on the ftp server from moderator to ok for the public to view
				we achieve this by renaming the file to lose the .mod suffix
				We need to build the ftp file path up from the ID and the mimetype and we need to rename a number of files
				if it is an image type of file.

*********************************************************************************/
bool CMediaAssetModController::Approve(int iMediaAssetID, CTDVString strMimeType, bool bComplaint)
{
	return ModerateFTPFiles(iMediaAssetID, strMimeType, TRUE, FALSE, bComplaint);
}

/*********************************************************************************

	bool CMediaAssetModController::Reject(int iMediaAssetID, CTDVString strMimeType)

	Author:		Steven Francis
	Created:	23/12/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Function to modify the file on the ftp server from moderator to fail the image
				we achieve this by renaming the file to change the .mod suffix to .fail
				We need to build the ftp file path up from the ID and the mimetype and we need to rename a number of files
				if it is an image type of file.

*********************************************************************************/
bool CMediaAssetModController::Reject(int iMediaAssetID, CTDVString strMimeType, bool bComplaint)
{
	return ModerateFTPFiles(iMediaAssetID, strMimeType, FALSE, FALSE, bComplaint);
}

/*********************************************************************************

	bool CMediaAssetModController::Requeue(int iMediaAssetID, CTDVString strMimeType)

	Author:		Steven Francis
	Created:	23/12/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Function to modify the file on the ftp server to requeue a file for moderation
				we achieve this by renaming the file to add the .mod suffix
				We need to build the ftp file path up from the ID and the mimetype 
				and we need to rename a number of files	if it is an image type of file.

*********************************************************************************/
bool CMediaAssetModController::Requeue(int iMediaAssetID, CTDVString strMimeType, bool bComplaint)
{
	return ModerateFTPFiles(iMediaAssetID, strMimeType, TRUE, TRUE, bComplaint);
}

/*********************************************************************************

	bool CMediaAssetModController::ModerateFTPFiles(int iMediaAssetID, CTDVString strMimeType, bool bApproved, bool bReQueue=false, bool bComplaint=false)

	Author:		Steven Francis
	Created:	23/12/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Internal function that actually modifies the file on the ftp server from moderator to ok for the public to view
				 (we achieve this by renaming the file to lose the .mod suffix)
				or to fail the image 
				 (we achieve this by renaming the file to change the .mod suffix to .fail) or 
				for a complaint (we achieve this by renaming the file to change the non .mod suffix to .fail).
				We need to build the ftp file path up from the ID and the mimetype and we need to rename a number of files
				if it is an image type of file.

*********************************************************************************/
bool CMediaAssetModController::ModerateFTPFiles(int iMediaAssetID, CTDVString strMimeType, bool bApproved, bool bReQueue, bool bComplaint)
{
	bool bOK = true;

	if (!ConnectToFtp())
	{
		return SetDNALastError("CMediaAssetModController", "ModerateFiles", "Connection to FTP Server Failed.");
	}

	CTDVString strPreModFTPFilename;

	CTDVString strFTPPreFixDirectory;
	CTDVString strMediaAssetID(iMediaAssetID);
	CTDVString sFileSuffix;
	CTDVString strPassFailSuffix;

	CTDVString strErrorMsg;

	int iContentType = 0;

	if (bApproved)
	{
		strPassFailSuffix = "";
	}
	else
	{
		strPassFailSuffix = FAILEDSUFFIX;
	}

	//Get the ftp sub path generated from the ID
	bOK = bOK && CMediaAsset::GenerateFTPDirectoryString(iMediaAssetID, strFTPPreFixDirectory);

	//Check that it is supported and get the type of file (content type)
	bOK = bOK && CMediaAsset::IsMimeTypeSupported(strMimeType, iContentType);
	
	if (bOK)
	{
		if (iContentType == 1)
		{
			//Get the file extension/suffix from the mimetype
			bOK = bOK && CMediaAsset::GetImageFormat(strMimeType, sFileSuffix);
		}
		else if (iContentType == 2)
		{
			//Get the file extension/suffix from the mimetype
			bOK = bOK && CMediaAsset::GetAudioSuffix(strMimeType, sFileSuffix);
		}
		else if (iContentType == 3)
		{
			//Get the file extension/suffix from the mimetype
			bOK = bOK && CMediaAsset::GetVideoSuffix(strMimeType, sFileSuffix);
		}

		//Build the FTP path
		strPreModFTPFilename = m_InputContext.GetMediaAssetFtpHomeDirectory() + strFTPPreFixDirectory + strMediaAssetID;
	}
	else
	{
		strErrorMsg = "MimeType not support :" + strMimeType;
		return SetDNALastError("CMediaAssetModController", "ModerateFiles", strErrorMsg);
	}

	if (bOK)
	{
		if (!bReQueue)
		{
			if (iContentType == 1)
			{
				//It's not a complaint so just a straight .mod to removed for passed or .fail for Failed
				if (!bComplaint)
				{
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + RAWEXTENSION + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + RAWEXTENSION + sFileSuffix + strPassFailSuffix);
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + THUMBEXTENSION + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + THUMBEXTENSION + sFileSuffix + strPassFailSuffix);
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix + strPassFailSuffix);
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix + strPassFailSuffix);

					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + sFileSuffix + MODERATIONSUFFIX , strPreModFTPFilename + sFileSuffix + strPassFailSuffix);
				}
				//We could have the case where we are trying to fail after a complaint on an already 
				//passed media asset so we need to rename the file to .fail from a non .mod source
				else
				{
					if (!bApproved)
					{
						bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + RAWEXTENSION + sFileSuffix,     strPreModFTPFilename + RAWEXTENSION + sFileSuffix + strPassFailSuffix);
						bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + THUMBEXTENSION + sFileSuffix,   strPreModFTPFilename + THUMBEXTENSION + sFileSuffix + strPassFailSuffix);
						bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix, strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix + strPassFailSuffix);
						bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix, strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix + strPassFailSuffix);

						bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + sFileSuffix, strPreModFTPFilename + sFileSuffix + strPassFailSuffix);
					}
					else
					{
						m_Ftp.Rename(strPreModFTPFilename + RAWEXTENSION + sFileSuffix + MODERATIONSUFFIX,     strPreModFTPFilename + RAWEXTENSION + sFileSuffix + strPassFailSuffix);
						m_Ftp.Rename(strPreModFTPFilename + THUMBEXTENSION + sFileSuffix + MODERATIONSUFFIX,   strPreModFTPFilename + THUMBEXTENSION + sFileSuffix + strPassFailSuffix);
						m_Ftp.Rename(strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix + strPassFailSuffix);
						m_Ftp.Rename(strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix + strPassFailSuffix);

						m_Ftp.Rename(strPreModFTPFilename + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + sFileSuffix + strPassFailSuffix);
					}				
				}
			}
			else
			{
				//Removing video's and audio media assets from needing to have the file changed by moderation 
				//Actually try to do it (if it's a streaming one then it's not going to be there - so what)
				if (!bComplaint)
				{
					m_Ftp.Rename(strPreModFTPFilename + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + sFileSuffix + strPassFailSuffix);
				}
				//We could have the case where we are trying to fail after a complaint on an already 
				//passed media asset so we need to rename the file to .fail from a non .mod source
				//or reputting the file back to passed from a refer and hide operation
				else
				{
					if (!bApproved)
					{
						m_Ftp.Rename(strPreModFTPFilename + sFileSuffix, strPreModFTPFilename + sFileSuffix + strPassFailSuffix);
					}
					else
					{
						m_Ftp.Rename(strPreModFTPFilename + sFileSuffix + MODERATIONSUFFIX, strPreModFTPFilename + sFileSuffix + strPassFailSuffix);
					}
				}
			}
		}
		else
		{
			if (bComplaint)
			{
				//We're requeing the file for moderation in the event of a complaint so go back to .mod
				if (iContentType == 1)
				{
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + RAWEXTENSION + sFileSuffix,     strPreModFTPFilename + RAWEXTENSION + sFileSuffix + MODERATIONSUFFIX);
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + THUMBEXTENSION + sFileSuffix,   strPreModFTPFilename + THUMBEXTENSION + sFileSuffix + MODERATIONSUFFIX);
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix, strPreModFTPFilename + PREVIEWEXTENSION + sFileSuffix + MODERATIONSUFFIX);
					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix, strPreModFTPFilename + ARTICLEEXTENSION + sFileSuffix + MODERATIONSUFFIX);

					bOK = bOK && m_Ftp.Rename(strPreModFTPFilename + sFileSuffix, strPreModFTPFilename + sFileSuffix + MODERATIONSUFFIX);
				}
				else
				{
					//Removing video's and audio media assets from needing to have the file changed by moderation 
					//Actually try to do it (if it's a streaming one then it's not going to be there - so what)
					m_Ftp.Rename(strPreModFTPFilename + sFileSuffix, strPreModFTPFilename + sFileSuffix + MODERATIONSUFFIX);
				}
			}
		}
	}
	else
	{
		strErrorMsg = "Failed to Generate FTP Moderation file path for ID :" + strMediaAssetID;
		return SetDNALastError("CMediaAssetModController", "ModerateFiles", strErrorMsg);
	}

	if(!bOK)
	{
		strErrorMsg = "Failed to Rename FTP Moderation files for ID :" + strMediaAssetID;
		return SetDNALastError("CMediaAssetModController", "ModerateFiles", strErrorMsg);
	}

	return bOK;
}

/*********************************************************************************

	bool CMediaAssetModController::ConnectToFtp()

	Author:		Steven Francis
	Created:	23/12/2005
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Function to connect to the FTP Server.

*********************************************************************************/
bool CMediaAssetModController::ConnectToFtp()
{
	if (m_Ftp.IsConnected())
	{
		return true;
	}

	if (!m_Ftp.Connect(m_InputContext.GetMediaAssetFtpServer(), m_InputContext.GetMediaAssetFtpUser(), m_InputContext.GetMediaAssetFtpPassword()))
	{
		return false;
	}

	return true;
}
