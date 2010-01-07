#pragma once

class CSimpleFtp
{
	protected:
		static const int MAX_ERROR_BUFFER = 255;

		static const char* const DEFAULT_SERVER;
		static const char* const DEFAULT_USER;
		static const char* const DEFAULT_PASSWORD;

		TCHAR m_ErrorMessage[MAX_ERROR_BUFFER];
		HINTERNET m_hInternet;
		HINTERNET m_hConnection;

	public:
		static const bool BINARY = true;
		static const bool ASCII = false;

		//bool failIfExists for Get
		static const bool FAILIFEXISTS = true;
		static const bool DONTFAILIFEXISTS = false;


	public:
		CSimpleFtp();
		virtual ~CSimpleFtp();

		bool Connect(const char* pServer, const char* pUser,  const char* pPassword);
		bool IsConnected() { return m_hConnection != NULL; }
		void Disconnect();

		bool Put(const char* pLocalFile, const char* pRemoteFile, bool bBinary);
		bool Get(const char* pRemoteFile, const char* pLocalFile, bool bFailIfExists,
			DWORD dwFileAttributes,	bool bBinary);
		bool Delete(const char* pFileName);
		bool Move(const char* pRemoteFileSrc, const char* pRemoteFileDst, bool bBinary);

		const char* GetErrorMessage();
		DWORD GetErrorNumber() { return GetLastError(); }
		bool Rename(const char* pExistingFile, const char* pNewFile);

	protected:
		void CloseHandle(HINTERNET& handle)
		{
			InternetCloseHandle(handle);
			handle = NULL;
		}
};
