#pragma once

#include "UploadedObject.h"

class CUploadedImage : public CUploadedObject
{
	public:
		CUploadedImage(CInputContext& inputContext);
		const char* GetTypeName() const;
		bool Fetch(int iId);
		static void MakeFileName(CTDVString& out, int iImageId, 
			const char* pMime, CInputContext& inputContext);
};