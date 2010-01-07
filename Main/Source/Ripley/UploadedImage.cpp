#include "stdafx.h"
#include ".\uploadedimage.h"

#include "UploadedImage.h"
#include "InputContext.h"
#include "Config.h"

CUploadedImage::CUploadedImage(CInputContext& inputContext)
	:
	CUploadedObject(inputContext)
{
}

const char* CUploadedImage::GetTypeName() const 
{ 
	return "image"; 
}

void CUploadedImage::MakeFileName(CTDVString& out, int iImageId, 
	const char* pMime, CInputContext& inputContext)
{
	out = "I";
	out << iImageId << "." << inputContext.GetMimeExtension(pMime);
}

bool CUploadedImage::Fetch(int iId)
{
	m_SP.StartStoredProcedure("getimagemetadata");
	m_SP.AddParam("ImageID", iId);
	m_SP.ExecuteStoredProcedure();
	m_iUserId = m_SP.GetIntField("UserID");
	m_SP.GetField("Description", m_sTag);
	m_SP.GetField("Mime", m_sMime);
	m_iId = iId;

	MakeFileName(m_sFileName, m_iId, m_sMime, m_InputContext);
	m_sPublicUrl = m_InputContext.GetImageLibraryPublicUrlBase();
	m_sPublicUrl << m_sFileName;
	m_sModerationUrl = m_InputContext.GetImageLibraryFtpRaw();
	m_sModerationUrl << m_sFileName;

	int iErrorCode;
	CTDVString sTemp;
	return !m_SP.GetLastError(&sTemp, iErrorCode);
}
