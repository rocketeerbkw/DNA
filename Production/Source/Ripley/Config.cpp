#include "stdafx.h"
#include "config.h"
#include "StoredProcedureBase.h"
#include "InputContext.h"
#include "XMLTree.h"
#include "TDVAssert.h"
#include "cgi.h"

CConfig theConfig;

bool CConfig::GetElement(CXMLTree* pStartNode, const char* pElementName, 
	CXMLTree*& pElement)
{
	if (!pStartNode || !pElementName)
	{
		TDVASSERT(false, "CConfig::GetElement failed - missing parameter(s).");
		return false;
	}

 	pElement = pStartNode->FindFirstTagName(pElementName,NULL,false);
	if (!pElement)
	{
		char buf[512];
		_snprintf(buf, 512, "Failed to read %s from config file.", pElementName);
		TDVASSERT(false, buf);
		return false;
	}

	return true;
}


bool CConfig::GetString(CXMLTree* pStartNode, const char* pElementName, CTDVString& sValue/*, const char* pDefault*/)
{
	CXMLTree* pNode = NULL;
	if (!GetElement(pStartNode, pElementName, pNode))
	{
		return false;
	}

	pNode->GetTextContents(sValue);
	return true;
}

bool CConfig::GetInt(CXMLTree* pStartNode, const char* pElementName, int& iValue)
{
	CTDVString sValue; 
	if (!GetString(pStartNode, pElementName, sValue))
	{
		return false;
	}

	iValue = atoi(sValue);
	return true;
}

CConfig::CConfig(void)
	:
	m_iMaxUploadBytes(0),
	m_bIsInitialised(false)
{
}

CConfig::~CConfig(void)
{
}

bool CConfig::Init(const char* pConfigFileName,  CTDVString& sConfigFileError )
{
	const unsigned uBufferSize = 20480;
	char buffer[uBufferSize];
	if (!ReadConfigFile(pConfigFileName, buffer, uBufferSize))
	{
		return false;
	}

	CXMLTree* pConfigTree = GetConfigTree(buffer);

	bool bRet = Init(*pConfigTree,  pConfigFileName, sConfigFileError );
	delete pConfigTree;
	pConfigTree = NULL;
	return bRet;
}

bool CConfig::ReadConfigFile(const char* pConfigFileName, char* pBuffer, unsigned uBufferSize)
{
	if (!pConfigFileName)
	{
		TDVASSERT(false, "No configuration file name given");
		return false;
	}

	if (!pBuffer)
	{
		TDVASSERT(false, "No buffer given");
		return false;
	}

	// open the file and read its contents into a string
	FILE* pConfigFile = fopen(pConfigFileName, "r");
	if (!pConfigFile)
	{
		TDVASSERT(false, "Failed to open configuration file");
		return false;
	}

	int iBytes = fread((void*)pBuffer, sizeof(char), uBufferSize - 1, pConfigFile);
	if(feof(pConfigFile) != 0)
	{
		// EOF, so config read properly
		// terminate the string
		pBuffer[iBytes] = 0;
	}
	else
	{
		// oops - config failed
		TDVASSERT(false, "Couldn't read all of configuration file");
	}
	fclose(pConfigFile);
	return true;
}

CXMLTree* CConfig::GetConfigTree(const char* pXml)
{
	if (!pXml)
	{
		return NULL;
	}

	CXMLTree* pConfigTree = NULL;

#ifdef _DEBUG
	long lNumErrors = 0;
	pConfigTree = CXMLTree::Parse(pXml, true, &lNumErrors);
	if (lNumErrors > 0)
	{
		TDVASSERT(false, "Parsing XML config data produced errors.");

		if (pConfigTree)
		{
			CTDVString dump;
			pConfigTree->DebugDumpTree(dump);
			TDVASSERT(false, dump);
		}
	}
#else
	pConfigTree = CXMLTree::Parse(pXml);
#endif

	if (!pConfigTree)
	{
		TDVASSERT(false, "Parsing XML config data produced NULL tree.");
		return false;
	}

	return pConfigTree;
}


bool CConfig::Init(CXMLTree& configTree,  const char* pConfigFileName, CTDVString& sConfigFileError )
{
	m_bIsInitialised = false;

	CXMLTree* pRoot = NULL;
	bool bRet=GetElementEx(&configTree, "RIPLEY", pRoot, pConfigFileName, sConfigFileError );

	{
		CXMLTree* pDbNode = NULL;
		bRet = bRet && GetElementEx(pRoot, "DBSERVER", pDbNode, pConfigFileName, sConfigFileError );
		bRet = bRet && GetElementEx(pRoot, "SQLSERVER", pDbNode, pConfigFileName, sConfigFileError );

		bRet = bRet && GetStringEx(pDbNode, "SERVERNAME", m_sDbServer, pConfigFileName, sConfigFileError );
		bRet = bRet && GetStringEx(pDbNode, "DBNAME", m_sDbName, pConfigFileName, sConfigFileError );
		bRet = bRet && GetStringEx(pDbNode, "UID", m_sDbUser, pConfigFileName, sConfigFileError );
		bRet = bRet && GetStringEx(pDbNode, "PASSWORD", m_sDbPassword, pConfigFileName, sConfigFileError );

		CXMLTree* pDbAppNode = NULL;
		if (GetElement(pRoot, "APP", pDbAppNode))
		{
			bRet = bRet && GetStringEx(pDbNode, "APP", m_sDbApp, pConfigFileName, sConfigFileError );
		}
		CXMLTree* pDbPoolingNode = NULL;
		if (GetElement(pRoot, "POOLING", pDbPoolingNode))
		{
			bRet = bRet && GetStringEx(pDbNode, "POOLING", m_sDbPooling, pConfigFileName, sConfigFileError );
		}
	}

	{
		CXMLTree* pDbNode = NULL;
		if (GetElement(pRoot, "DBWRITESERVER", pDbNode))
		{
			bRet = bRet && GetElementEx(pRoot, "SQLSERVER", pDbNode, pConfigFileName, sConfigFileError);
			bRet = bRet && GetStringEx(pDbNode, "SERVERNAME", m_sDbServer, pConfigFileName, sConfigFileError);
			bRet = bRet && GetStringEx(pDbNode, "DBNAME", m_sWriteDbName, pConfigFileName, sConfigFileError);
			bRet = bRet && GetStringEx(pDbNode, "UID", m_sWriteDbUser, pConfigFileName, sConfigFileError);
			bRet = bRet && GetStringEx(pDbNode, "PASSWORD", m_sWriteDbPassword, pConfigFileName, sConfigFileError);
			CXMLTree* pDbAppNode = NULL;
			if (GetElement(pRoot, "APP", pDbAppNode))
			{
				bRet = bRet && GetStringEx(pDbNode, "APP", m_sWriteDbApp, pConfigFileName, sConfigFileError );
			}
			CXMLTree* pDbPoolingNode = NULL;
			if (GetElement(pRoot, "POOLING", pDbPoolingNode))
			{
				bRet = bRet && GetStringEx(pDbNode, "POOLING", m_sWriteDbPooling, pConfigFileName, sConfigFileError );
			}
		}
		else
		{
			m_sWriteDbServer = m_sDbServer;
			m_sWriteDbName = m_sDbName;
			m_sWriteDbUser = m_sDbUser;
			m_sWriteDbPassword = m_sDbPassword;
			m_sWriteDbApp = m_sDbApp;
			m_sWriteDbPooling = m_sDbPooling;
		}
	}

	bRet = bRet && GetStringEx(pRoot, "SMILEY-LIST", m_sSmileyListFile, pConfigFileName, sConfigFileError);

	bRet = bRet && GetStringEx(pRoot, "SMTPSERVER", m_sSmtpServer, pConfigFileName, sConfigFileError);

	bRet = bRet && GetStringEx(pRoot, "SITEROOT", m_SiteRoot, pConfigFileName, sConfigFileError);

	{
		CXMLTree* pRegNode = NULL;
		bRet = bRet && GetElementEx(pRoot, "REGISTRATION", pRegNode, pConfigFileName, sConfigFileError);

		bRet = bRet && GetStringEx(pRegNode, "SERVER", m_RegServer, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pRegNode, "SCRIPT", m_RegScript, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pRegNode, "PROXY", m_RegProxy, pConfigFileName, sConfigFileError);
	}

	{
		CXMLTree* pPostcoder = NULL;
		bRet = bRet && GetElementEx(pRoot, "POSTCODER", pPostcoder, pConfigFileName, sConfigFileError);

		//Postcoder Server
		bRet = bRet && GetStringEx(pPostcoder, "SERVER", m_PostcoderServer, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pPostcoder, "PROXY", m_PostcoderProxy, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pPostcoder, "PLACE", m_PostcoderPlace, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pPostcoder, "POSTCODEDATA", m_PostcoderPostcodeData, pConfigFileName, sConfigFileError);

		//PostCoder Cookie Server
		bRet = bRet && GetStringEx(pPostcoder, "COOKIESERVER", m_PostcoderCookieServer, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pPostcoder, "COOKIEPROXY", m_PostcoderCookieProxy, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pPostcoder, "COOKIEURL", m_PostcoderCookieURL, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pPostcoder, "COOKIENAME", m_PostcoderCookieName, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pPostcoder, "COOKIEPOSTCODEKEY", m_PostcoderCookiePostcodeKey, pConfigFileName, sConfigFileError);
	}

	bRet = bRet && GetStringEx(pRoot, "COOKIE-DOMAIN", m_sCookieDomain, pConfigFileName, sConfigFileError);
	bRet = bRet && GetStringEx(pRoot, "COOKIE-NAME", m_sCookieName, pConfigFileName, sConfigFileError);
	bRet = bRet && GetStringEx(pRoot, "CACHEROOT", m_CacheRoot, pConfigFileName, sConfigFileError);
	bRet = bRet && GetStringEx(pRoot, "INPUTLOGPATH", m_sInputLogPath, pConfigFileName, sConfigFileError);
	bRet = bRet && GetStringEx(pRoot, "PROFILECONFFILE", m_sMdbConfFile, pConfigFileName, sConfigFileError);
	bRet = bRet && GetStringEx(pRoot, "BLOBCACHEROOT", m_sBlobCacheRoot, pConfigFileName, sConfigFileError);
	bRet = bRet && GetStringEx(pRoot, "DEFAULT-SKIN", m_DefaultSkin, pConfigFileName, sConfigFileError);
	
	// TODO: should really check for existence of the skin here
	{
		CXMLTree* pServerFarm = NULL;
		bRet = bRet && GetElementEx(pRoot, "SERVERFARM", pServerFarm, pConfigFileName, sConfigFileError);

		if (bRet)
		{
			CXMLTree* pName = pServerFarm->FindFirstTagName("ADDRESS", pServerFarm);
			while (pName)
			{
				CTDVString sName;
				pName->GetTextContents(sName);
				m_ServerArray.push_back(sName);
				pName = pName->FindNextTagNode("ADDRESS", pServerFarm);
			}
		}

		pServerFarm = NULL;
		bRet = bRet && GetElementEx(pRoot, "DOTNET-SERVERFARM", pServerFarm, pConfigFileName, sConfigFileError);

		if (bRet)
		{
			CXMLTree* pName = pServerFarm->FindFirstTagName("ADDRESS", pServerFarm);
			while (pName)
			{
				CTDVString sName;
				pName->GetTextContents(sName);
				m_DotNetServerArray.push_back(sName);
				pName = pName->FindNextTagNode("ADDRESS", pServerFarm);
			}
		}
	}

	bRet = bRet && GetStringEx(pRoot, "SECRET-KEY", m_sSecretKey, pConfigFileName, sConfigFileError);

	{
		CXMLTree* pImageLib = NULL;
		bRet = bRet && GetElementEx(pRoot, "IMAGELIBRARY", pImageLib, pConfigFileName, sConfigFileError);
		bRet = bRet && GetIntEx(pImageLib, "MAXUPLOADBYTES", m_iMaxUploadBytes, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "FTPSERVER", m_sImageLibraryFtpServer, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "FTPUSER", m_sImageLibraryFtpUser, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "FTPPASSWORD", m_sImageLibraryFtpPassword, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "FTPRAW", m_sImageLibraryFtpRaw, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "FTPPUBLIC", m_sImageLibraryFtpPublic, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "AWAITINGMODERATION", m_sImageLibraryAwaitingModeration, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "FAILEDMODERATION", m_sImageLibraryFailedModeration, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "TMPLOCALDIR", m_sImageLibraryTmpLocalDir, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "PUBLICURLBASE", m_sImageLibraryPublicUrlBase, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "RAWURLBASE", m_sImageLibraryRawUrlBase, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pImageLib, "PREVIEWIMAGE", m_sImageLibraryPreviewImage, pConfigFileName, sConfigFileError);
	}

	{
		CXMLTree* pMediaAsset = NULL;
		bRet = bRet && GetElementEx(pRoot, "MEDIAASSET", pMediaAsset, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pMediaAsset, "FTPSERVER", m_sMediaAssetFtpServer, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pMediaAsset, "FTPUSER", m_sMediaAssetFtpUser, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pMediaAsset, "FTPPASSWORD", m_sMediaAssetFtpPassword, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pMediaAsset, "FTPHOMEDIRECTORY", m_sMediaAssetFtpHomeDirectory, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pMediaAsset, "UPLOADQUEUE", m_sMediaAssetUploadQueueLocalDir, pConfigFileName, sConfigFileError);
		bRet = bRet && GetStringEx(pMediaAsset, "UPLOADQUEUETEMP", m_sMediaAssetUploadQueueTmpLocalDir, pConfigFileName, sConfigFileError);
	}

	{
		m_iInitialLogFileSize = 0;
		bRet = bRet && GetIntEx(pRoot, "INITIALLOGFILESIZE", m_iInitialLogFileSize, pConfigFileName, sConfigFileError);
		if (m_iInitialLogFileSize <= 0 || m_iInitialLogFileSize > 500)
		{
			// Initialise to a sensible value
			#if _DEBUG
			m_iInitialLogFileSize = 1; // Initialise to a sensible value
			#else
			m_iInitialLogFileSize = 10; // Initialise to a sensible value
			#endif
		}

		m_iInitialLogFileSize = m_iInitialLogFileSize * 1024 * 1024;
	}
	
	// Get the identity uri for the web service
	bRet = bRet && GetStringEx(pRoot, "IDENTITYURI", m_sIdentityUri, pConfigFileName, sConfigFileError);

	// Check to see if we're being asked to use extra signin logging
	if (!GetIntEx(pRoot, "EXTRASIGNINLOGGING", m_bExtraSigninlogging, pConfigFileName, sConfigFileError))
	{
		m_bExtraSigninlogging = false;
	}

	m_iServerTooBusyLimit = 50;
	GetIntEx(pRoot, "SERVERTOOBUSYLIMIT", m_iServerTooBusyLimit, pConfigFileName, sConfigFileError);
	if (m_iServerTooBusyLimit < 5 || m_iServerTooBusyLimit > 70)
	{
		m_iServerTooBusyLimit = 50;
	}

	m_bIsInitialised = bRet;

	return bRet;	
}

bool CConfig::GetElementEx(CXMLTree* pStartNode, const char* pElementName, CXMLTree*& pElement,  const char* pConfigFileName, CTDVString& sConfigFileError )
{
	bool bRet = GetElement(pStartNode, pElementName, pElement);

	if ( bRet == false)
	{
		CTDVString sNodeError = "Failed to read the XML node ";
		sNodeError = sNodeError + pStartNode->GetXPath(pElementName );
		sNodeError = sNodeError + " from the file " + pConfigFileName;
		sConfigFileError = sNodeError;
	}
																									
	return bRet;																									
}

bool CConfig::GetStringEx(CXMLTree* pStartNode, const char* pElementName, CTDVString& sValue,  const char* pConfigFileName, CTDVString& sConfigFileError )
{
	sValue.Empty( );
	bool bRet = GetString(pStartNode, pElementName, sValue);

	if ( bRet == false)
	{
		CTDVString sNodeError = "Failed to read the XML node ";
		sNodeError = sNodeError + pStartNode->GetXPath(pElementName );
		sNodeError = sNodeError + " from the file " + pConfigFileName;
		sConfigFileError = sNodeError;
	}
																									
	return bRet;		
}

bool CConfig::GetIntEx(CXMLTree* pStartNode, const char* pElementName, int& iValue,  const char* pConfigFileName, CTDVString& sConfigFileError )
{
	CTDVString sValue; 
	bool bRet = GetString(pStartNode, pElementName, sValue);
	if ( bRet == false)
	{
		CTDVString sNodeError = "Failed to read the XML node ";
		sNodeError = sNodeError + pStartNode->GetXPath(pElementName );
		sNodeError = sNodeError + " from the file " + pConfigFileName;
		sConfigFileError = sNodeError;
	}
	else
	{
		iValue = atoi(sValue);
	}

	return bRet;
}