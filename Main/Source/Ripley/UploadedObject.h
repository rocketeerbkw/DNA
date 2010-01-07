#pragma once

#include "storedprocedurebase.h"
#include "TDVString.h"

class CInputContext;

class CUploadedObject
{
	protected:
		CInputContext& m_InputContext;
        CStoredProcedureBase m_SP;
		int m_iId;
		int m_iUserId;
		CTDVString m_sTag;
		CTDVString m_sMime;
		CTDVString m_sPublicUrl;
		CTDVString m_sModerationUrl;
		CTDVString m_sFileName;

	public:
		CUploadedObject(CInputContext& inputContext);
		virtual ~CUploadedObject(void);
		virtual bool Fetch(int iId) = 0;
		int GetId() const { return m_iId; }
		int GetUserId() const { return m_iUserId; }
		const char* GetTag() const { return m_sTag; }
		const char* GetMime() const { return m_sMime; }
		const char* GetPublicUrl() const { return m_sPublicUrl; }
		const char* GetModerationUrl() const { return m_sModerationUrl; }
		const char* GetFileName() const { return m_sFileName; }
		virtual const char* GetTypeName() const = 0;
};
