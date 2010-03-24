#pragma once

#include <map>
#include <vector>
#include "TDVString.h"

using namespace std;

class CInputContext;
class CXMLTree;

typedef vector<CTDVString> STRINGVECTOR;

class CConfig
{
	protected:
		bool m_bIsInitialised;

		CTDVString m_sImageLibraryPreviewImage;
		int m_iMaxUploadBytes;
		CTDVString m_sImageLibraryFtpServer;
		CTDVString m_sImageLibraryFtpUser;
		CTDVString m_sImageLibraryFtpPassword;
		CTDVString m_sImageLibraryFtpRaw;
		CTDVString m_sImageLibraryFtpPublic;
		CTDVString m_sImageLibraryAwaitingModeration;
		CTDVString m_sImageLibraryFailedModeration;
		CTDVString m_sImageLibraryTmpLocalDir;
		CTDVString m_sImageLibraryPublicUrlBase;
		CTDVString m_sImageLibraryRawUrlBase;
		
		CTDVString m_sSecretKey;
		CTDVString m_sBlobCacheRoot;
		STRINGVECTOR m_ServerArray;
		STRINGVECTOR m_DotNetServerArray;
		CTDVString m_sMdbConfFile;
		CTDVString m_sInputLogPath;
		int		   m_iInitialLogFileSize;
		int		   m_iServerTooBusyLimit;
		CTDVString m_CacheRoot;
		CTDVString m_SiteRoot;
		CTDVString m_sSmtpServer;
		CTDVString m_DefaultSkin;
		CTDVString m_sSmileyListFile;

		CTDVString m_sCookieName;
		CTDVString m_sCookieDomain;

		CTDVString m_PostcoderServer;
		CTDVString m_PostcoderProxy;
		CTDVString m_PostcoderPlace;
		CTDVString m_PostcoderPostcodeData;

		CTDVString m_PostcoderCookieServer;			//Postcoder cookie server.
		CTDVString m_PostcoderCookieProxy;			//Proxy Server
		CTDVString m_PostcoderCookieURL;			//Path of Postcoder Cookie server
		CTDVString m_PostcoderCookieName;			// Name of BBC Postcoder Cookie.
		CTDVString m_PostcoderCookiePostcodeKey;	//Token used to identify Postcode in cookie

		CTDVString m_RegProxy;
		CTDVString m_RegScript;
		CTDVString m_RegServer;

		CTDVString m_sDbServer;
		CTDVString m_sDbName;
		CTDVString m_sDbUser;
		CTDVString m_sDbPassword;

		CTDVString m_sDbApp;
		CTDVString m_sDbPooling;

		CTDVString m_sWriteDbServer;
		CTDVString m_sWriteDbName;
		CTDVString m_sWriteDbUser;
		CTDVString m_sWriteDbPassword;

		CTDVString m_sWriteDbApp;
		CTDVString m_sWriteDbPooling;

		CTDVString m_sMediaAssetFtpServer;
		CTDVString m_sMediaAssetFtpUser;
		CTDVString m_sMediaAssetFtpPassword;
		CTDVString m_sMediaAssetFtpHomeDirectory;
		CTDVString m_sMediaAssetUploadQueueLocalDir;
		CTDVString m_sMediaAssetUploadQueueTmpLocalDir;

		CTDVString m_sIdentityUri;
		int m_bExtraSigninlogging;

	public:
		CConfig();
		~CConfig(void);

		bool Init(const char* pConfigFileName,  CTDVString& sConfigFileError );
		bool IsInitialised() const { return m_bIsInitialised; }

		const char* GetDbServer() const { return m_sDbServer; }
		const char* GetDbName() const { return m_sDbName; }
		const char* GetDbUser() const { return m_sDbUser; }
		const char* GetDbPassword() const { return m_sDbPassword; }

		const char* GetDbApp() const { return m_sDbApp; }
		const char* GetDbPooling() const { return m_sDbPooling; }

		const char* GetWriteDbServer() const { return m_sWriteDbServer; }
		const char* GetWriteDbName() const { return m_sWriteDbName; }
		const char* GetWriteDbUser() const { return m_sWriteDbUser; }
		const char* GetWriteDbPassword() const { return m_sWriteDbPassword; }

		const char* GetWriteDbApp() const { return m_sWriteDbApp; }
		const char* GetWriteDbPooling() const { return m_sWriteDbPooling; }

		//Information for contacting the Postcoder service.
		const char* GetPostcoderServer() const { return m_PostcoderServer; }
		const char* GetPostcoderProxy() const { return m_PostcoderProxy; }
		const char* GetPostcoderPlace() const { return m_PostcoderPlace; }
		const char* GetPostcoderData() const { return m_PostcoderPostcodeData; }

		//Information for locating the Postcoder Cookie Service
		const char* GetPostcoderCookieServer() const { return m_PostcoderCookieServer; }
		const char* GetPostcoderCookieProxy() const { return m_PostcoderCookieProxy; }
		const char* GetPostcoderCookieURL() const { return m_PostcoderCookieURL; }
		const char* GetPostcoderCookieName() const { return m_PostcoderCookieName; }
		const char* GetPostcoderCookiePostcodeKey() const { return m_PostcoderCookiePostcodeKey; }

		const char* GetCookieName() const { return m_sCookieName; }
		const char* GetCookieDomain() const { return m_sCookieDomain; }

		const char* GetRegServer() const { return m_RegServer; }
		const char* GetRegProxy() const { return m_RegProxy; }
		const char* GetRegScript() const { return m_RegScript; }

		const char* GetSmileyListFile() const { return m_sSmileyListFile; }
		const char* GetDefaultSkin() const { return m_DefaultSkin; }
		const char* GetSmtpServer() const { return m_sSmtpServer; }
		const char* GetSiteRoot() const { return m_SiteRoot; }
		const char* GetCacheRootPath() const { return m_CacheRoot; }
		const char* GetInputLogPath() const { return m_sInputLogPath; }
		int GetInitialLogFileSize() const { return m_iInitialLogFileSize; }
		int GetServerTooBusyLimit() const { return m_iServerTooBusyLimit; }
		const char* GetMdbConfigFile() const { return m_sMdbConfFile; }
		const char* GetSecretKey() const { return m_sSecretKey; }
		const char* GetBlobCacheRoot() const { return m_sBlobCacheRoot; }
		const STRINGVECTOR& GetServerArray() const { return m_ServerArray; }
		const STRINGVECTOR& GetDotNetServerArray() const { return m_DotNetServerArray; }

		const char* GetImageLibraryPreviewImage() const { return m_sImageLibraryPreviewImage; }
		int GetImageLibraryMaxUploadBytes() const { return m_iMaxUploadBytes; } 
		const char* GetImageLibraryFtpServer() const { return m_sImageLibraryFtpServer; } 
		const char* GetImageLibraryFtpUser() const { return m_sImageLibraryFtpUser; } 
		const char* GetImageLibraryFtpPassword() const { return m_sImageLibraryFtpPassword; } 
		const char* GetImageLibraryFtpRaw() const { return m_sImageLibraryFtpRaw; } 
		const char* GetImageLibraryFtpPublic() const { return m_sImageLibraryFtpPublic; } 
		const char* GetImageLibraryAwaitingModeration() const { return m_sImageLibraryAwaitingModeration; } 
		const char* GetImageLibraryFailedModeration() const { return m_sImageLibraryFailedModeration; } 
		const char* GetImageLibraryTmpLocalDir() const { return m_sImageLibraryTmpLocalDir; } 
		const char* GetImageLibraryPublicUrlBase() const { return m_sImageLibraryPublicUrlBase; } 
		const char* GetImageLibraryRawUrlBase() const { return m_sImageLibraryRawUrlBase; } 

		const char* GetMediaAssetFtpServer() const { return m_sMediaAssetFtpServer; } 
		const char* GetMediaAssetFtpUser() const { return m_sMediaAssetFtpUser; } 
		const char* GetMediaAssetFtpPassword() const { return m_sMediaAssetFtpPassword; } 
		const char* GetMediaAssetFtpHomeDirectory() const { return m_sMediaAssetFtpHomeDirectory; } 
		const char* GetMediaAssetUploadQueueLocalDir() const { return m_sMediaAssetUploadQueueLocalDir; } 
		const char* GetMediaAssetUploadQueueTmpLocalDir() const { return m_sMediaAssetUploadQueueTmpLocalDir; } 

		const char* GetIdentityUri() const { return m_sIdentityUri; }
		bool UseExtraSigninlogging() { return m_bExtraSigninlogging > 0; }

	protected:
		bool Init(CXMLTree& configTree,  const char* pConfigFileName, CTDVString& sConfigFileError );
		bool GetString(CXMLTree* pStartNode, const char* pElementName, CTDVString& sValue/*, const char* pDefault = NULL*/);
		bool GetInt(CXMLTree* pStartNode, const char* pElementName, int& iValue/*, int* pDefault = NULL*/);
		bool GetElement(CXMLTree* pStartNode, const char* pElementName, CXMLTree*& pElement);
		bool ReadConfigFile(const char* pConfigFileName, char* pBuffer, unsigned uBufferSize);
		CXMLTree* GetConfigTree(const char* pXml);

		 bool GetElementEx(CXMLTree* pStartNode, const char* pElementName, CXMLTree*& pElement,  const char* pConfigFileName, CTDVString& sConfigFileError );
		 bool GetStringEx(CXMLTree* pStartNode, const char* pElementName, CTDVString& sValue,  const char* pConfigFileName, CTDVString& sConfigFileError );
		 bool GetIntEx(CXMLTree* pStartNode, const char* pElementName, int& iValue,  const char* pConfigFileName, CTDVString& sConfigFileError );
};

extern CConfig theConfig;