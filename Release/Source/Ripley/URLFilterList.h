// URLFilter.h: interface for the CURLFilter class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_URLFILTERLIST_H__CE68AB99_D442_4548_A734_FCECDFCDFF8A__INCLUDED_)
#define AFX_URLFILTER_H__CE68AB99_D442_4548_A734_FCECDFCDFF8A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <vector>
#include "XMLObject.h"
#include "TDVString.h"
#include "InputContext.h"

class CURLFilterList : public CXMLObject
{
public:
	CURLFilterList(CInputContext& inputContext);
	virtual ~CURLFilterList(void);

	bool GetURLFilterList(void);
	bool UpdateAllowedURL(const int iAllowedURLID, const CTDVString& sAllowedURL, const int iSiteID);
	bool DeleteAllowedURL(const int iAllowedURLID);
	bool AddNewAllowedURL(const CTDVString& sAllowedURL, const int iSiteID);
};
#endif // !defined(AFX_URLFILTERLIST_H__CE68AB99_D442_4548_A734_FCECDFCDFF8A__INCLUDED_)
