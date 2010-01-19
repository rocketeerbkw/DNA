#pragma once


//
// Asset Upload Queue management. Sends Assets to upload
// queue, ready for processing and uploading to download
// servers
//
class CAssetUploadQueue : public CXMLObject
{

public:
	CAssetUploadQueue(CInputContext& inputContext);
	~CAssetUploadQueue();

	bool AddAsset(int nAssetID);
	bool RemoveAsset(int nAssetID);
};
