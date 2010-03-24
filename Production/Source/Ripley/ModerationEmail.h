#pragma once

#include "subst.h"
#include "StoredProcedureBase.h"
#include "UploadedObject.h"

class CTDVString;

class CModerationEmail
{
	protected:
		CStoredProcedureBase m_SP;

	public:
		CModerationEmail(CInputContext& inputContext);
		virtual ~CModerationEmail(void);

		bool GetEmail(const char* pEmailName, int iSiteId, CSubst* pSubst,
			CTDVString& sEmailSubject, CTDVString& sEmailText);

	protected:
		bool FetchEmailText(int iSiteId, const char* pEmailName, 
			CTDVString& pSubject, CTDVString& pText);

};
