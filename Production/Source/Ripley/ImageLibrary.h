// Category.cpp: implementation of the CCategory class.
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


#pragma once

#include "SimpleFtp.h"
#include "StoredProcedureBase.h"

class CInputContext;
class CTDVString;
class CUploadedImage;

class CImageLibrary
{
	public:
		static const int ERR_OK;
		static const int ERR_BAD_ARG;
		static const int ERR_TOO_BIG;
		static const int ERR_OPEN_FILE;
		static const int ERR_WRITE;
		static const int ERR_NO_SRC;
		static const int ERR_NO_USER;
		static const int ERR_DB;
		static const int ERR_FTP;

	protected:
		static const char* const IMAGE_DESCRIPTION_FIELD;

		CSimpleFtp m_Ftp;
		CInputContext& m_InputContext;
		CStoredProcedureBase m_Sp;

	public:
		CImageLibrary(CInputContext& inputContext);
		virtual ~CImageLibrary(void);

		int Upload(const char* pFileFieldName, CUploadedImage& image);
		int Approve(const CUploadedImage& image);
		int Reject(const CUploadedImage& image);

	protected:
		bool AddUserImageRecord(int iUserId,
			const char* pDescription, const char* pMime, int& iImageId);
		int WriteLocalFile(const char* pName, int iImageId, CTDVString& sLocalFile, 
			CTDVString& sLocalFileFullPath);
		bool ConnectToFtp();
};
