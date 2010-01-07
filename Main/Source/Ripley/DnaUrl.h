/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/

#pragma once

#if !defined(AFX_DNALINK_H__18377F09_6E1E_465F_BFD1_8ED99759E914__INCLUDED_)
#define AFX_DNALINK_H__18377F09_6E1E_465F_BFD1_8ED99759E914__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "XMLObject.h"

/*********************************************************************************
class CDnaUrl
Author:		Igor Loboda
Created:	14/01/2005
Purpose:	Give it a url and it will parse it and try to identify what type
			that url is. If this is one of recognized urls it will try ot
			extract target (article, campaign) id from the url. 
			See Parse method for more information.
*********************************************************************************/

class CDnaUrl : public CXMLObject 
{
	protected:
		static const int ARTICLE;
		static const int CLUB;
		static const int EXTERNAL;	
		static const int EMPTY;
		static const int UNKNOWN;

	public:
		static const bool DONTDEFAULTTOHTTP;
		static const bool DEFAULTTOHTTP;

	public:
		CDnaUrl(CInputContext& inputContext);
		virtual ~CDnaUrl();

		bool Initialise(const char* pUrl, bool bDefaultToHttp = true);

		const char* GetTypeName() const;
		const char* GetUrl() const { return m_sUrl; }
		int GetTargetId() const { return m_iTargetId; }

		bool IsExternal() const { return m_iType == EXTERNAL; }
		bool IsArticle() const { return m_iType == ARTICLE; }
		bool IsClub() const { return m_iType == CLUB; }
		bool IsEmpty() const { return m_iType == EMPTY; }
		bool IsUnknown() const { return m_iType == UNKNOWN; }

	protected:
		void Parse(const char*);
		void ExternalUrl(const CTDVString& sUrl);
		bool CheckUrlScheme(const CTDVString& sUrl);
		bool DnaUrl(const CTDVString& sUrlIn);
	
	protected:
		CTDVString m_sUrl;
		int m_iTargetId;
		int m_iType;
};

#endif