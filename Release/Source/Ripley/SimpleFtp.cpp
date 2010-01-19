#include "stdafx.h"
#include <windows.h>
#include <wininet.h>
#include ".\simpleftp.h"
#include "TDVString.h"
#include <io.h>

const char* const CSimpleFtp::DEFAULT_SERVER = "";
const char* const CSimpleFtp::DEFAULT_USER = "anonymous";
const char* const CSimpleFtp::DEFAULT_PASSWORD = "";

CSimpleFtp::CSimpleFtp()
:
m_hInternet(NULL),
m_hConnection(NULL)
{
	m_ErrorMessage[0] = 0;
}


CSimpleFtp::~CSimpleFtp()
{
	Disconnect();
}

void CSimpleFtp::Disconnect()
{
	CloseHandle(m_hInternet);
	CloseHandle(m_hConnection);
}

const char* CSimpleFtp::GetErrorMessage()
{
	FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), 
		0, m_ErrorMessage, MAX_ERROR_BUFFER, NULL);
	return m_ErrorMessage;
}

bool CSimpleFtp::Delete(const char* pFileName)
{
	if (!pFileName)
	{
		pFileName = "";
	}

	return FtpDeleteFile(m_hConnection, pFileName) != NULL;
}

bool CSimpleFtp::Connect(const char* pServer, const char* pUser,  const char* pPassword)
{
	if (IsConnected())
	{
		Disconnect();
	}

	if (!pServer)
	{
		pServer = DEFAULT_SERVER;
	}

	if (!pUser)
	{
		pUser = DEFAULT_USER;
	}

	if (!pPassword)
	{
		pPassword = DEFAULT_PASSWORD;
	}

	m_hInternet = InternetOpen("", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0);
	if (!m_hInternet)
	{
		return false;
	}

	m_hConnection = InternetConnect(m_hInternet, pServer,
		INTERNET_DEFAULT_FTP_PORT, pUser, pPassword, 
		INTERNET_SERVICE_FTP, 0, 0);
	if (!m_hConnection)
	{
		CloseHandle(m_hInternet);
		return false;
	}

	return IsConnected();
}

bool CSimpleFtp::Put(const char* pLocalFile, const char* pRemoteFile, bool bBinary)
{
	if (!pLocalFile)
	{
		pLocalFile = "";
	}

	if (!pRemoteFile)
	{
		pRemoteFile = "";
	}

	return FtpPutFile(m_hConnection, pLocalFile, pRemoteFile,  
		bBinary ? FTP_TRANSFER_TYPE_BINARY : FTP_TRANSFER_TYPE_ASCII
		| INTERNET_FLAG_RELOAD, 0);
}

bool CSimpleFtp::Move(const char* pRemoteFileSrc, const char* pRemoteFileDst, bool bBinary)
{
	//generate temporary name

	time_t now;
	char tmpLocalNameBuf[40];
	sprintf(tmpLocalNameBuf, "sftp%iXXXXXX", time(&now));
	char* pTmpLocalName = _mktemp(tmpLocalNameBuf);
	if (!pTmpLocalName)
	{
		return false;
	}

	//TODO:need local location for tmp files
	bool bRet = Get(pRemoteFileSrc, pTmpLocalName, DONTFAILIFEXISTS, 
		FILE_ATTRIBUTE_TEMPORARY, bBinary);
	if (!bRet)
	{
		return bRet;
	}

	bRet = Put(pTmpLocalName, pRemoteFileDst, bBinary);
	if (!bRet)
	{
		return bRet;
	}

	bRet = Delete(pRemoteFileSrc);
	if (!bRet)
	{
		return bRet;
	}

	remove(pTmpLocalName);

	return bRet;
}

bool CSimpleFtp::Get(const char* pRemoteFile, const char* pLocalFile, bool bFailIfExists,
	DWORD dwFileAttributes,	bool bBinary)
{
	if (!pLocalFile)
	{
		pLocalFile = "";
	}

	if (!pRemoteFile)
	{
		pRemoteFile = "";
	}

	return FtpGetFile(m_hConnection, pRemoteFile, pLocalFile, bFailIfExists,
		dwFileAttributes,
		bBinary ? FTP_TRANSFER_TYPE_BINARY : FTP_TRANSFER_TYPE_ASCII | INTERNET_FLAG_RELOAD,
		0);
}

bool CSimpleFtp::Rename(const char* pExistingFile, const char* pNewFile)
{
	if (!pExistingFile)
	{
		return false;
	}

	if (!pNewFile)
	{
		return false;
	}

	return FtpRenameFile(m_hConnection, pExistingFile, pNewFile);
}
