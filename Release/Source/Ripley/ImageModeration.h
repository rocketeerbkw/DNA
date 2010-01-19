#pragma once
#include "storedprocedurebase.h"
#include "ImageLibrary.h"

class CInputContext;

class CImageModeration
{
	public:
		static const int PASS;
		static const int FAIL;
		static const int UNREFER;
		static const int FAILEDIT;

	protected:
		CStoredProcedureBase m_SP;
		CTDVString m_sAuthorsEmail;
		CTDVString m_sComplainantsEmail;
		CImageLibrary m_ImageLibrary;
		CInputContext& m_InputContext;
		int m_iAuthorID; 
		int m_iComplainantID; 

	public:
		CImageModeration(CInputContext& inputContext);
		virtual ~CImageModeration(void);
		bool UnreferImage(const CUploadedImage& image, int iModID, const char* pNotes);
		bool GetModerationBatchXml(int iUserId, const char* pErrorXml, 
			bool bComplaints, bool bReferrals, CTDVString& sXml);
		bool ModerateImage(const CUploadedImage& image, 
			int iModId, int iStatus, 
			const char* pNotes, int iReferredBy, int iReferTo);

		const char* GetAuthorsEmail() { return m_sAuthorsEmail; }
		int GetAuthorID() { return m_iAuthorID; }

		const char* GetComplainantsEmail() { return m_sComplainantsEmail; }
		int GetComplainantID() { return m_iComplainantID; }

	protected:
		bool FetchImageModerationBatch(int iUserID, 
			bool bComplaints, bool bReferrals);

};
