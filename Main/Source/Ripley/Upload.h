// Upload.h: interface for the CUpload class.
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


#if !defined(AFX_UPLOAD_H__72E65451_0B0E_11D4_8A52_00104BF83D2F__INCLUDED_)
#define AFX_UPLOAD_H__72E65451_0B0E_11D4_8A52_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CUpload : public CXMLObject  
{
public:
	CUpload(CInputContext& inputContext);
	virtual ~CUpload();

	bool Add(int iTeamID,int iUserID,CTDVString& sFileName,int iFileType,int& iUploadID); 
	bool UpdateStatus(int iUploadID,int iNewStatus); 
	bool GetUploadsForTeam(int iTeamID,CTDVString& sTeamUploadsXML); 
	bool GetUploadsForUser(int iUserID,CTDVString& sUserUploadsXML); 
	bool VerifyUserCanUpload(int iUserID); 
 
	enum Status 
	{ 
		MODERATION_INQUEUE  = 0, 
		MODERATION_LOCKED   = 1, 
		MODERATION_REFERRED = 2, 
		MODERATION_PASSED   = 3, 
		MODERATION_FAILED   = 4 
	}; 

	enum ErrorCodes
	{
		ERRORCODE_UNKOWNCOMMAND = 0,
		ERRORCODE_NEWFAILED		= 101,
		ERRORCODE_UNKNOWNUSER	= 102
	};

private:
	void GetUploadsAsXML(CStoredProcedure& SP,CTDVString& sXML);
};

#endif // !defined(AFX_UPLOAD_H__72E65451_0B0E_11D4_8A52_00104BF83D2F__INCLUDED_)
