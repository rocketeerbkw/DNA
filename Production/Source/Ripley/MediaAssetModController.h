//////////////////////////////////////////////////////////////////////
// MediaAssetModController.h: interface for the CMediaAssetModController class.
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

#if !defined(AFX_MEDIAASSETMODCONTROLLER_H__A9FF458F_11CE_400d_8EBB_92792D81551B__INCLUDED_)
#define AFX_MEDIAASSETMODCONTROLLER_H__A9FF458F_11CE_400d_8EBB_92792D81551B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "xmlobject.h"
#include "SimpleFtp.h"

/*********************************************************************************
class:	CMediaAssetModController

This class handles the functions to change the media asset moderation status on the ftp site
if an asset is accepted through moderation the filename is changed on the ftp site

		Author:		Steve Francis
        Created:	22/12/2005
        Inputs:		Input Context
        Purpose:	Class to perform Media Asset file moderation control. 
*********************************************************************************/
class CMediaAssetModController : public CXMLObject
{
public:
	CMediaAssetModController(CInputContext& inputContext);
	virtual ~CMediaAssetModController(void);

	bool Approve(int iMediaAssetID, CTDVString strMimeType, bool bComplaint);
	bool Reject(int iMediaAssetID, CTDVString strMimeType, bool bComplaint);
	bool Requeue(int iMediaAssetID, CTDVString strMimeType, bool bComplaint);
	
protected:
	CSimpleFtp m_Ftp;
	bool ConnectToFtp();
	bool ModerateFTPFiles(int iMediaAssetID, CTDVString strMimeType, bool bApproved, bool bReQueue = false, bool bComplaint = false);

};
#endif // !defined(AFX_MEDIAASSETMODCONTROLLER_H__A9FF458F_11CE_400d_8EBB_92792D81551B__INCLUDED_)
