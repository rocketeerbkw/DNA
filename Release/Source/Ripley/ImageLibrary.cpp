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
#include ".\imagelibrary.h"
#include "InputContext.h"
#include "tdvassert.h"
#include "UploadedImage.h"
#include "User.h"
#include "Config.h"

const int CImageLibrary::ERR_OK = 0;
const int CImageLibrary::ERR_BAD_ARG = -1;
const int CImageLibrary::ERR_TOO_BIG = -2;
const int CImageLibrary::ERR_OPEN_FILE = -3;
const int CImageLibrary::ERR_WRITE = -4;
const int CImageLibrary::ERR_NO_SRC = -5;
const int CImageLibrary::ERR_NO_USER = -6;
const int CImageLibrary::ERR_DB = -7;
const int CImageLibrary::ERR_FTP = -8;

const char* const CImageLibrary::IMAGE_DESCRIPTION_FIELD = "ImageDescription";

template <class T> class CDynamicArray
{
	protected:
		T* m_Array;

	public:
		CDynamicArray(unsigned uSize) { m_Array = new T[uSize]; }
		~CDynamicArray() { delete m_Array; }

		operator T*() { return m_Array; }
		operator void*() { return m_Array; }
		T& operator[](unsigned uIndex) { return m_Array[uIndex]; }

		operator const T*() const { return m_Array; }
		operator const void*() const { return m_Array; }
		const T& operator[](unsigned uIndex) const { return m_Array[uIndex]; }
};

CImageLibrary::CImageLibrary(CInputContext& inputContext)
	:
	m_InputContext(inputContext)
{
	m_InputContext.InitialiseStoredProcedureObject(m_Sp);
}

CImageLibrary::~CImageLibrary(void)
{
}

bool CImageLibrary::ConnectToFtp()
{
	if (m_Ftp.IsConnected())
	{
		return true;
	}

	if (!m_Ftp.Connect(m_InputContext.GetImageLibraryFtpServer(), 
		m_InputContext.GetImageLibraryFtpUser(),
		m_InputContext.GetImageLibraryFtpPassword()))
	{
		return false;
	}

	return true;
}

int CImageLibrary::Upload(const char* pFileFieldName, CUploadedImage& image)
{
	if (!pFileFieldName)
	{
		return ERR_BAD_ARG;
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (!pViewingUser)
	{
		return ERR_NO_USER;
	}

	CTDVString sImageDescription;
	//ignore return code - if description can not be found - empty description is used
	m_InputContext.GetParamString(IMAGE_DESCRIPTION_FIELD, sImageDescription);

	int iLength;
	CTDVString sMime;
	if (!m_InputContext.GetNamedSectionMetadata(pFileFieldName, iLength, sMime))
	{
		return ERR_NO_SRC;
	}

	int iImageId;
	if (!AddUserImageRecord(pViewingUser->GetUserID(), sImageDescription, sMime, iImageId))
	{
		return ERR_DB;
	}

	CTDVString sLocalFile;
	CTDVString sLocalFileFullPath;
	int iRet = WriteLocalFile(pFileFieldName, iImageId, sLocalFile, sLocalFileFullPath);
	if (iRet != ERR_OK)
	{
		return iRet;
	}

	if (!ConnectToFtp())
	{
		return ERR_FTP;
	}

	CTDVString rawLocation = m_InputContext.GetImageLibraryFtpRaw();
	rawLocation << sLocalFile;

	if (!m_Ftp.Put(sLocalFileFullPath, rawLocation, CSimpleFtp::BINARY))
	{
		return ERR_FTP;
	}

	CTDVString publicLocation = m_InputContext.GetImageLibraryFtpPublic();
	publicLocation << sLocalFile;

	CTDVString awaitingModeration = m_InputContext.GetImageLibraryAwaitingModeration();
	awaitingModeration << "." << m_InputContext.GetMimeExtension(sMime);
	if (!m_Ftp.Put(awaitingModeration, publicLocation, CSimpleFtp::BINARY))
	{
		//putting placeholder image is not critical for upload
	//	return ERR_FTP;
	}

	if (image.Fetch(iImageId))
	{
		return ERR_OK;
	}
	else
	{
		return ERR_DB;
	}
}

int CImageLibrary::Approve(const CUploadedImage& image)
{
	if (!ConnectToFtp())
	{
		return ERR_FTP;
	}

	CTDVString src = m_InputContext.GetImageLibraryFtpRaw();
	src << image.GetFileName();

	CTDVString dst = m_InputContext.GetImageLibraryFtpPublic();
	dst << image.GetFileName();

	if (!m_Ftp.Move(src, dst, CSimpleFtp::BINARY))
	{
		return ERR_FTP;
	}

	return ERR_OK;
}

int CImageLibrary::Reject(const CUploadedImage& image)
{
	if (!ConnectToFtp())
	{
		return ERR_FTP;
	}

	CTDVString sPublicLocation = m_InputContext.GetImageLibraryFtpPublic();
	sPublicLocation << image.GetFileName();
	
	CTDVString failedModeration = m_InputContext.GetImageLibraryFailedModeration();
	failedModeration << "." << m_InputContext.GetMimeExtension(image.GetMime());	
	//dont' check for error code - not critical
	m_Ftp.Put(failedModeration, sPublicLocation, CSimpleFtp::BINARY);

	CTDVString sRawLocation = m_InputContext.GetImageLibraryFtpRaw();
	sRawLocation << image.GetFileName();
	m_Ftp.Delete(sRawLocation);	//don't check for error code - not critical

	return ERR_OK;
}

int CImageLibrary::WriteLocalFile(const char* pName, int iImageId, 
	CTDVString& sLocalFile, CTDVString& sLocalFileFullPath)
{
	const int iMaxBytes = m_InputContext.GetImageLibraryMaxUploadBytes();
	CDynamicArray<char> buf(iMaxBytes);
	int iLength;
	CTDVString sMime;
	if (m_InputContext.GetParamFile(pName, iMaxBytes, buf, iLength, sMime))
	{
		if (iLength > iMaxBytes)
		{
			return ERR_TOO_BIG;
		}

		CUploadedImage::MakeFileName(sLocalFile, iImageId, sMime, m_InputContext);
		sLocalFileFullPath = m_InputContext.GetImageLibraryTmpLocalDir();
		sLocalFileFullPath << sLocalFile;
		FILE* tempfile = fopen(sLocalFileFullPath, "wb");
		if (tempfile == NULL)
		{
			return ERR_OPEN_FILE;
		}

		if (fwrite(buf, 1, iLength, tempfile) < size_t(iLength))
		{
			fclose(tempfile);
			return ERR_WRITE;
		}

		fclose(tempfile);
	}
	else
	{
		return ERR_NO_SRC;
	}

	return ERR_OK;
}


bool CImageLibrary::AddUserImageRecord(int iUserId, const char* pDescription, 
	const char* pMime, int& iImageId)
{
	m_Sp.StartStoredProcedure("uploadimage");

	m_Sp.AddParam("SiteID", m_InputContext.GetSiteID());
	m_Sp.AddParam("UserID", iUserId);
	m_Sp.AddParam("Description", pDescription);
	m_Sp.AddParam("Mime", pMime);

	m_Sp.ExecuteStoredProcedure();

	if (m_Sp.HandleError("UploadImage"))
	{
		return false;
	}

	iImageId = m_Sp.GetIntField("ImageID");

	return true;
}
