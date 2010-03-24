#include "stdafx.h"
#include "tdvassert.h"
#include "tdvstring.h"
#include "xmlobject.h"
#include "AssetUploadQueue.h"

CAssetUploadQueue::CAssetUploadQueue(CInputContext& inputContext) : CXMLObject(inputContext)
{
	if(!CreateFromXMLText("<ASSET-UPLOADER/>"))
	{
		TDVASSERT(false, "CAssetUploadQueue::CAssetUploadQueue() CreateFromXMLText failed");
		// Subsequent calls to AddInside will fail
	}
}

CAssetUploadQueue::~CAssetUploadQueue()
{
	
}



/*********************************************************************************

	bool CAssetUploadQueue::AddAsset(int nAssetID)

		Author:		James Pullicino
        Created:	26/10/2005
        Inputs:		AssetID is ID of Asset. Asset record must be created before 
					it can be added to the upload queue
        Outputs:	-
        Returns:	false on failure. A 'true' return does not mean that the asset
					was actually added. There is no mechanism to determine this other
					than inspecting the queue. 
        Purpose:	Takes asset data from input context and adds it to the
					upload queue

*********************************************************************************/

bool CAssetUploadQueue::AddAsset(int nAssetID)
{
	// We need a user
	CUser *pUser;
	if((pUser = m_InputContext.GetCurrentUser()) == NULL)
	{
		if(!AddInside("ASSET-UPLOADER", "<UPLOAD-RESULT><ERROR TYPE=1>User not logged in</ERROR></UPLOAD-RESULT>"))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}

	// Get mime type and length
	int iLength;
	CTDVString sMime;
	if (!m_InputContext.GetNamedSectionMetadata("file", iLength, sMime))
	{
		if(!AddInside("ASSET-UPLOADER", "<UPLOAD-RESULT><ERROR TYPE=2>file not found</ERROR></UPLOAD-RESULT>"))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}

	// Check if mime type is supported
	// This part should be extented as we add support
	// for more file formats
	if(!sMime.CompareText("image/jpeg") 
		&& !sMime.CompareText("image/gif"))
	{
		CTDVString sErr;
		sErr << "<UPLOAD-RESULT><ERROR TYPE=3>File format not supported (" << sMime << ")</ERROR></UPLOAD-RESULT>";
		if(!AddInside("ASSET-UPLOADER", sErr))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}

	// Make sure file is not too big.
	// 5megs = 5242880 bytes (http://www.google.co.uk/search?hl=en&q=bytes+in+5+megabytes)
	if(iLength > 5242880)
	{
		CTDVString sErr;
		sErr << "<UPLOAD-RESULT><ERROR TYPE=4>File too big (" << iLength << ")</ERROR></UPLOAD-RESULT>";
		if(!AddInside("ASSET-UPLOADER", sErr))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}

	// Copy file to folder //

	// Make sure folder exists (c:\\assetuploadqueue for time being) 
	const char * sQueueFolder = "c:\\assetuploadqueue";

	DWORD dwLastError;
	if(!CreateDirectory(sQueueFolder, NULL)
		&& (dwLastError = GetLastError()) != ERROR_ALREADY_EXISTS)
	{
		CTDVString sErr;
		sErr << "<UPLOAD-RESULT><ERROR TYPE=5>Failed to create folder (" << (long)dwLastError << ")</ERROR></UPLOAD-RESULT>";
		if(!AddInside("ASSET-UPLOADER", sErr))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}

	// Copy data into buffer
	std::vector<char> filebuf(iLength);
	if(!m_InputContext.GetParamFile("file", filebuf.size(), &filebuf[0], iLength, sMime))
	{
		if(!AddInside("ASSET-UPLOADER", "<UPLOAD-RESULT><ERROR TYPE=5>Failed to get file data</ERROR></UPLOAD-RESULT>"))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}

	// Dump to disk
	CTDVString sFilename;
	sFilename << sQueueFolder << "\\" << nAssetID;
	HANDLE hFile = CreateFile(sFilename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if(hFile == INVALID_HANDLE_VALUE)
	{
		CTDVString sErr;
		sErr << "<UPLOAD-RESULT><ERROR TYPE=5>Failed to create file (" << (long)GetLastError() << ")</ERROR></UPLOAD-RESULT>";
		if(!AddInside("ASSET-UPLOADER", sErr))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}
    
	DWORD dwNumberOfBytesWritten;
	if(!WriteFile(hFile, &filebuf[0], filebuf.size(), &dwNumberOfBytesWritten, NULL))
	{
		DWORD dwError = GetLastError();
		
		CloseHandle(hFile);
		
		CTDVString sErr;
		sErr << "<UPLOAD-RESULT><ERROR TYPE=5>Failed to write to file (" << (long)dwError << ")</ERROR></UPLOAD-RESULT>";

		if(!AddInside("ASSET-UPLOADER", sErr))
		{
			TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
			return false;
		}

		return true;
	}

	CloseHandle(hFile);

	// Add record to table
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CAssetUploadQueue::AddAsset() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	CTDVString sServer;
	m_InputContext.GetServerName(&sServer);

	if(!SP.MediaAssetUploadQueueAdd(nAssetID, sServer))
	{
		TDVASSERT(false, "CAssetUploadQueue::AddAsset() SP.MediaAssetUploadQueueAdd failed");
		return false;
	}

	// Report succcess
	CTDVString sMsg;
	if(!AddInside("ASSET-UPLOADER", "<UPLOAD-RESULT/>"))
	{
		TDVASSERT(false, "CAssetUploadQueue::AddAsset() AddInside failed");
		return false;
	}

	return true;
}