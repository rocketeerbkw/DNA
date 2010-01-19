// TopFives.h: interface for the CTopFives class.
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


#if !defined(AFX_TOPFIVES_H__2BE58206_EF5C_11D3_8A05_00104BF83D2F__INCLUDED_)
#define AFX_TOPFIVES_H__2BE58206_EF5C_11D3_8A05_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLobject.h"

class CTopFives : public CXMLObject  
{
public:
	void ClearCache(int iSiteID);
	bool Initialise(int iSiteID, bool bNoCache = false, bool bRefreshCache = true);
	virtual bool Destroy();
	virtual bool IsEmpty();
	bool AddTopFive(const TDVCHAR* pTopFiveName);
	CTopFives(CInputContext& inputContext);
	virtual ~CTopFives();

protected:
	bool m_bFetched;
	int m_iSiteID;

	virtual CXMLTree* ExtractTree();
};

#endif // !defined(AFX_TOPFIVES_H__2BE58206_EF5C_11D3_8A05_00104BF83D2F__INCLUDED_)
