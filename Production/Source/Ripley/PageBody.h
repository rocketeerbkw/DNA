// PageBody.h: interface for the CPageBody class.
//
//////////////////////////////////////////////////////////////////////

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


#if !defined(AFX_PAGEBODY_H__958C148E_EDFA_11D3_BD68_00A02480D5F4__INCLUDED_)
#define AFX_PAGEBODY_H__958C148E_EDFA_11D3_BD68_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/*
	class CPageBody

	Author:		Oscar Gillesquie
	Created:	28/02/2000
	Modified:	29/02/2000
	Inherits:	CXMLObject
	Purpose:	Subclass of CXMLObject that represents a tasty XML
				chunklet of plain text.
*/


#include "XMLObject.h"
#include "ExtraInfo.h"

class CPageBody : public CXMLObject  
{
public:
	CPageBody(CInputContext& inputContext);
	virtual ~CPageBody();

public:
	virtual bool Initialise(int h2g2ID);
	virtual bool Initialise(const TDVCHAR* ArticleName, int iSiteID = 1);
	virtual bool CreatePageFromXMLText(const TDVCHAR* pSubject, const TDVCHAR* pBody, CExtraInfo* pExtraInfo = NULL);
	virtual bool CreatePageFromPlainText(const TDVCHAR* pSubject, const TDVCHAR* pBody);

	bool IsInitialised() { return m_bIsInitialised; }

	bool GetTagContentsAsXML(const TDVCHAR* pTag, CTDVString& sText);
	bool SetElementText(const TDVCHAR* pNodeName, CTDVString& sText);

	bool GetSubject(CTDVString* oSubject);

	bool GetBodyText(CTDVString* oText);
	void UpdateBody();

	CExtraInfo* GetExtraInfo() { return &m_ExtraInfo; }
	bool UpdateExtraInfo(CExtraInfo& ExtraInfo);

protected:
	void UpdateSubjectAndBody();
	bool CreateFromXMLText(const TDVCHAR* pXMLText, CTDVString* pErrorReport = NULL, bool bDestroyTreeFirst = false);

	CTDVString m_sBodyText;
	CTDVString m_sSubject;
	CExtraInfo m_ExtraInfo;
	bool m_bIsInitialised;
};

#endif // !defined(AFX_PAGEBODY_H__958C148E_EDFA_11D3_BD68_00A02480D5F4__INCLUDED_)
